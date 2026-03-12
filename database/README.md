# InstaFlow AI — Banco de Dados

## Estratégia atual

O projeto agora usa duas camadas:

1. **Bootstrap**
   Arquivo único para subir um banco novo do zero.
2. **Migrations**
   Alterações incrementais para evolução futura ou reconciliação de ambientes parcialmente aplicados.

Isso evita rerodar o schema inteiro sempre que houver uma mudança.

## Estrutura

```text
database/
├── 001_schema.sql
├── 002_rls_policies.sql
├── 003_add_vectors.sql
├── 004_schema_from_docs.sql
├── migrations/
│   ├── README.md
│   └── 005_reconcile_partial_bootstrap.sql
└── README.md
```

## Quando usar cada arquivo

### Banco novo

Use:

- `004_schema_from_docs.sql`

Esse é o bootstrap derivado de `docs/SCHEMA.md` e ajustado para execução real no Supabase.

### Banco parcialmente aplicado ou evolução futura

Use arquivos em:

- `database/migrations/`

Esses scripts devem ser incrementais, seguros e focados em alterações específicas.

## Recomendação operacional

- Para ambiente novo: execute o bootstrap
- Para ajustes futuros: crie uma migration nova
- Para ambiente quebrado por execução parcial: aplique uma migration de reconciliação, não o bootstrap inteiro

## Observações

- `docs/SCHEMA.md` é documentação, não deve ser executado diretamente
- Criptografia de tokens deve ser feita em código server-side ou Edge Functions, não no bootstrap inicial
- Seeds e templates podem exigir tratamento separado em migrations conforme o ambiente evolui
