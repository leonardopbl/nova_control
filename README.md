# NovaControl

Aplicacao full stack para controle de despesas pessoais, com frontend em Vue 3 + Vuetify e API REST em Elixir/Phoenix.

## Stack

- Frontend: Vue 3, TypeScript, Vite, Vuetify
- Backend: Elixir, Phoenix, Ecto
- Banco de dados: PostgreSQL

## Estrutura

- `app/`: interface web
- `api/nova_control/`: API e regras de negocio

## Funcionalidades atuais

- Cadastro de usuario com credenciais (`/api/auth/signup`)
- Listagem, atualizacao e exclusao de usuarios
- Listagem, criacao e atualizacao de despesas
- Endpoint de status da API

## Como rodar localmente

### 1. Banco de dados (PostgreSQL)

Na pasta `api/nova_control`:

```bash
docker compose up -d
```

### 2. Backend (Phoenix)

Na pasta `api/nova_control`:

```bash
mix setup
mix phx.server
```

API disponivel em `http://localhost:4000`.

### 3. Frontend (Vue)

Na pasta `app`:

```bash
pnpm install
pnpm dev
```

Frontend disponivel em `http://localhost:5173`.

## API (resumo)

Base URL local: `http://localhost:4000/api`

- `GET /status`
- `POST /auth/signup`
- `GET /users`
- `PUT /users/:id`
- `DELETE /users/:id`
- `GET /expenses`
- `POST /expenses`
- `PUT /expenses/:id`
