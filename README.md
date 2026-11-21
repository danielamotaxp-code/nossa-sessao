# Nossa Sessão 🎬

O app de filmes do casal: lista do que queremos ver, do que já vimos e as notas de cada um (1 a 10), com capas e banners oficiais.

- **Filmes, capas, banners e trailers:** [TMDB](https://www.themoviedb.org) (grátis)
- **Lista compartilhada e contas:** [Supabase](https://supabase.com) (grátis)
- **Site:** GitHub Pages (grátis)

Nada disso usa créditos do Claude.

---

## Configuração (uma vez só, ~20 minutos)

### 1. Banco de dados (Supabase)
1. Crie uma conta em **supabase.com** e clique em **New project**.
   - Nome: `nossa-sessao` · crie uma senha qualquer · Região: **South America (São Paulo)**.
2. Quando o projeto terminar de criar, abra **SQL Editor** → **New query**.
3. Copie todo o conteúdo do arquivo **`supabase.sql`** deste repositório, cole lá e clique em **Run**. Deve aparecer "Success".
4. (Recomendado) **Authentication → Sign In / Providers → Email**: desligue **Confirm email**, para a conta funcionar na hora sem precisar confirmar por e-mail. Salve.
5. Pegue as duas chaves em **Project Settings → API** (ou no botão **Connect**):
   - **Project URL** (algo como `https://abcd.supabase.co`)
   - **anon public** (ou **publishable**) — uma chave longa

### 2. Chave de filmes (TMDB)
1. Crie uma conta em **themoviedb.org** e confirme o e-mail.
2. Vá em **Configurações → API** e peça uma chave do tipo **Developer** (uso pessoal; pode preencher o site como o endereço do GitHub Pages abaixo).
3. Copie a **Chave da API** (ou o **Token de Leitura da API** — qualquer um dos dois funciona).

### 3. Colocar as chaves no app
Abra o arquivo **`config.js`** aqui no GitHub, clique no lápis ✏️ e preencha as três linhas entre as aspas. Clique em **Commit changes**.

### 4. Publicar o site
No repositório: **Settings → Pages** → em *Branch* escolha **main** e **/ (root)** → **Save**.
Em 1–2 minutos o app fica no ar em:
**https://danielamotaxp-code.github.io/nossa-sessao/**

### 5. No iPhone (cada um no seu)
1. Abra o link no **Safari**.
2. Toque em **Criar conta**, com o seu nome, e-mail e senha.
3. Toque em **Compartilhar** (quadrado com seta) → **Adicionar à Tela de Início**.
   O app abre em tela cheia, como um app de verdade.

### 6. Trancar o app para só vocês dois
Depois que **os dois** criarem a conta: Supabase → **Authentication → Sign In / Providers** → desligue **Allow new users to sign up** → Save.
A partir daí ninguém mais consegue criar conta, e só vocês dois veem e mexem na lista.

---

## Bom saber
- **Projeto parado:** no plano grátis, o Supabase pausa o projeto depois de 7 dias sem nenhum uso. Se o app parar de carregar, entre em supabase.com e clique em **Restore project**. Usando toda semana, isso não acontece.
- **As chaves no `config.js` ficam públicas** no GitHub. Isso é normal para a chave *anon* do Supabase: quem protege os dados são as regras de segurança do `supabase.sql` e o passo 6. A chave do TMDB só serve para buscar filmes.
- Cada um só pode editar ou apagar a **própria** nota. Filmes da lista os dois podem editar.
