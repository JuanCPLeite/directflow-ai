# Migrations

## Regra

Nunca edite o banco rerodando o bootstrap completo em produção ou em ambientes já usados.

Crie migrations incrementais com nomes sequenciais:

- `005_nome_da_mudanca.sql`
- `006_nome_da_mudanca.sql`

## Objetivo

Cada migration deve:

- resolver um problema específico
- ser clara e pequena
- preferir operações idempotentes quando possível
- evitar depender de banco vazio

## Exemplos de uso

- adicionar coluna
- corrigir constraint
- criar índice novo
- ajustar seed
- reconciliar um banco parcialmente aplicado
