# NovaControl Frontend

Frontend do projeto NovaControl, construido com Vue 3, TypeScript, Vite e Vuetify.

## Requisitos

- Node.js 20+
- pnpm

## Rodando em desenvolvimento

```bash
pnpm install
pnpm dev
```

Aplicacao disponivel em `http://localhost:5173`.

## Scripts

- `pnpm dev`: sobe o servidor de desenvolvimento
- `pnpm build`: gera build de producao
- `pnpm preview`: executa preview da build local

## Estado atual

- Interface com drawer lateral e visualizacao de despesas por ano/mes.
- Tabela de despesas ainda utiliza dados mockados em `src/App.vue`.
- Integracao com a API sera o proximo passo.
