# NovaControl API

API REST do projeto NovaControl, desenvolvida com Elixir, Phoenix e PostgreSQL.

## Requisitos

- Elixir 1.15+
- Erlang/OTP compativel com o Elixir 1.15+
- PostgreSQL 16+ (ou via Docker Compose)

## Subindo o banco com Docker

```bash
docker compose up -d
```

O `docker-compose.yml` cria um banco local com:

- host: `localhost`
- porta: `5432`
- usuario: `postgres`
- senha: `postgres`
- database: `nova_control_dev`

## Setup da API

```bash
mix setup
mix phx.server
```

API disponivel em `http://localhost:4000`.

## Endpoints

Base local: `http://localhost:4000/api`

- `GET /status`: health check
- `POST /auth/signup`: cria usuario + registro de autenticacao
- `GET /users`: lista usuarios
- `PUT /users/:id`: atualiza usuario
- `DELETE /users/:id`: remove usuario
- `GET /expenses`: lista despesas
- `POST /expenses`: cria despesa
- `PUT /expenses/:id`: atualiza despesa

## Estrutura de dominio

- `User`: nome, email, telefone, data de nascimento
- `Expense`: nome, valor, tipo, vencimento, data de pagamento, usuario
- `Register`: credenciais de autenticacao (password hash com Bcrypt)

## Testes

```bash
mix test
```
