-- Nossa Sessão — banco de dados
-- Cole tudo isto no Supabase: menu "SQL Editor" → "New query" → cole → "Run".

create table if not exists perfis (
  id uuid primary key references auth.users on delete cascade,
  nome text not null
);

create table if not exists filmes (
  id uuid primary key default gen_random_uuid(),
  tmdb_id int,
  titulo text not null,
  original text,
  ano int,
  diretor text,
  generos text[] default '{}',
  duracao int,
  sinopse text,
  elenco text[] default '{}',
  poster text,
  backdrop text,
  trailer text,
  status text not null default 'quero' check (status in ('quero','visto')),
  added_by uuid references auth.users on delete set null default auth.uid(),
  added_at timestamptz not null default now(),
  visto_em timestamptz
);

create table if not exists avaliacoes (
  filme_id uuid references filmes on delete cascade,
  user_id uuid references auth.users on delete cascade default auth.uid(),
  nota int not null check (nota between 1 and 10),
  gostou text[] default '{}',
  nao_gostou text[] default '{}',
  comentario text,
  em timestamptz not null default now(),
  primary key (filme_id, user_id)
);

-- Acesso pela API (só para quem entrou com conta).
grant usage on schema public to authenticated;
grant select, insert, update, delete on perfis, filmes, avaliacoes to authenticated;

-- Segurança: só quem entrou com conta vê e mexe; cada um só mexe na própria nota.
alter table perfis enable row level security;
alter table filmes enable row level security;
alter table avaliacoes enable row level security;

create policy "perfis: ler" on perfis for select to authenticated using (true);
create policy "perfis: criar o meu" on perfis for insert to authenticated with check (id = auth.uid());
create policy "perfis: editar o meu" on perfis for update to authenticated using (id = auth.uid());

create policy "filmes: tudo" on filmes for all to authenticated using (true) with check (true);

create policy "notas: ler" on avaliacoes for select to authenticated using (true);
create policy "notas: criar a minha" on avaliacoes for insert to authenticated with check (user_id = auth.uid());
create policy "notas: editar a minha" on avaliacoes for update to authenticated using (user_id = auth.uid());
create policy "notas: apagar a minha" on avaliacoes for delete to authenticated using (user_id = auth.uid());

-- Atualização ao vivo: o que um faz aparece na hora para o outro.
alter publication supabase_realtime add table filmes, avaliacoes, perfis;

-- Cards de avaliação compartilhados (editáveis pelos dois)
create table if not exists public.cards(
  id uuid primary key default gen_random_uuid(),
  tipo text not null check (tipo in ('gostou','nao_gostou')),
  nome text not null,
  ordem int not null default 0,
  criado_em timestamptz not null default now(),
  unique (tipo, nome)
);
grant select, insert, update, delete on public.cards to authenticated;
alter table public.cards enable row level security;
drop policy if exists "cards do casal" on public.cards;
create policy "cards do casal" on public.cards for all to authenticated using (true) with check (true);
alter publication supabase_realtime add table public.cards;

-- Séries: tipo do título e número de temporadas
alter table public.filmes add column if not exists tipo text not null default 'filme';
alter table public.filmes add column if not exists temporadas int;
alter table public.filmes drop constraint if exists filmes_tipo_check;
alter table public.filmes add constraint filmes_tipo_check check (tipo in ('filme','serie'));

-- Títulos individuais: dono preenchido = lista individual daquela pessoa
alter table public.filmes add column if not exists dono uuid references auth.users(id) on delete cascade;

-- Episódios assistidos das séries
create table if not exists public.episodios(
  filme_id uuid not null references public.filmes(id) on delete cascade,
  temporada int not null,
  episodio int not null,
  por uuid default auth.uid(),
  em timestamptz not null default now(),
  primary key (filme_id, temporada, episodio)
);
grant select, insert, update, delete on public.episodios to authenticated;
alter table public.episodios enable row level security;
create policy "episodios do casal" on public.episodios for all to authenticated using (true) with check (true);
alter publication supabase_realtime add table public.episodios;

-- Recomendações: quem recomendou o título para a lista individual
alter table public.filmes add column if not exists recomendado_por uuid references auth.users(id) on delete set null;
