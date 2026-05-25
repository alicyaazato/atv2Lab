# Tarefas de Implementação - Subject Database

## Overview
Este documento lista todas as tarefas necessárias para implementar completamente a base de dados de subjects com armazenamento, relacionamentos e validações.

---

## Task 1: Create subjects table

**Descrição**: Criar a tabela `subject` no banco de dados Xano com todos os campos necessários conforme especificação.

**Subtarefas**:
- [ ] Criar tabela `subject` no Xano
- [ ] Adicionar campo `id` (int, primary key, auto-increment)
- [ ] Adicionar campo `owner_id` (int) - proprietário do subject
- [ ] Adicionar campo `account_id` (int) - conta/organização
- [ ] Adicionar campo `name` (text, required, max 255 chars)
- [ ] Adicionar campo `code` (text, optional, max 50 chars)
- [ ] Adicionar campo `description` (text, optional, max 2000 chars)
- [ ] Adicionar campo `credits` (int, optional, range 0-20)
- [ ] Adicionar campo `semester` (text, optional)
- [ ] Adicionar campo `year` (int, optional, range 1900-2100)
- [ ] Adicionar campo `status` (enum: active, archived, draft)
- [ ] Adicionar campo `is_active` (boolean, default true)
- [ ] Adicionar campo `created_at` (timestamp, auto-set)
- [ ] Adicionar campo `updated_at` (timestamp, auto-update)
- [ ] Adicionar campo `metadata` (JSON, opcional, private)
- [ ] Verificar que a tabela foi criada com sucesso no Xano
- [ ] Testar inserção de um registro sample

**Critérios de Aceitação**:
- ✓ Tabela `subject` existe no banco de dados
- ✓ Todos os 15 campos estão criados
- ✓ Campo `id` é auto-increment
- ✓ Campo `status` tem valores padrão corretos
- ✓ Timestamps estão configurados como auto-touch
- ✓ Um registro de teste pode ser inserido sem erros

**Tempo Estimado**: 1-2 horas

---

## Task 2: Add foreign key

**Descrição**: Criar relacionamentos entre a tabela `subject` e as tabelas `user` e `account` via foreign keys.

**Subtarefas**:
- [ ] Verificar que tabelas `user` e `account` existem
- [ ] Adicionar foreign key `owner_id` → `user.id`
  - [ ] Configurar constraint para rejeitar deletion se houver subjects
  - [ ] Testar que não é possível criar subject com user_id inválido
  - [ ] Testar que não é possível deletar user com subjects
- [ ] Adicionar foreign key `account_id` → `account.id`
  - [ ] Configurar constraint para rejeitar deletion se houver subjects
  - [ ] Testar que não é possível criar subject com account_id inválido
  - [ ] Testar que não é possível deletar account com subjects
- [ ] Criar índice em `owner_id` para otimizar queries
- [ ] Criar índice em `account_id` para otimizar queries
- [ ] Criar índice composto em `(account_id, code)` para unicidade
- [ ] Realizar testes de integridade referencial
- [ ] Documentar relacionamentos no design.md

**Critérios de Aceitação**:
- ✓ Foreign key `owner_id` → `user.id` funcionando
- ✓ Foreign key `account_id` → `account.id` funcionando
- ✓ Constraints impedem referências inválidas
- ✓ Índices estão criados e otimizando queries
- ✓ Unicidade de (account_id, code) é enforçada
- ✓ Testes de integridade referencial passam

**Tempo Estimado**: 1-2 horas

---

## Task 3: Validate fields

**Descrição**: Implementar validações de campos em nível de banco de dados e API para garantir integridade dos dados.

**Subtarefas**:

### 3.1 Validações em Nível de Banco
- [ ] Adicionar validação: `name` NOT NULL
- [ ] Adicionar validação: `name` máximo 255 caracteres
- [ ] Adicionar validação: `code` máximo 50 caracteres
- [ ] Adicionar validação: `description` máximo 2000 caracteres
- [ ] Adicionar validação: `credits` entre 0 e 20 (se fornecido)
- [ ] Adicionar validação: `year` entre 1900 e 2100 (se fornecido)
- [ ] Adicionar validação: `status` apenas valores do enum (active, archived, draft)
- [ ] Adicionar validação: `owner_id` NOT NULL
- [ ] Adicionar validação: `account_id` NOT NULL
- [ ] Testar cada validação com dados inválidos

### 3.2 Validações em Nível de API
- [ ] Validar `name` não vazio (field required)
- [ ] Validar `code` é único por `account_id`
- [ ] Validar `credits` é numérico e está no range 0-20
- [ ] Validar `year` é numérico e está no range 1900-2100
- [ ] Validar `status` é um dos valores permitidos
- [ ] Validar `owner_id` existe na tabela `user`
- [ ] Validar `account_id` existe na tabela `account`
- [ ] Validar usuário tem acesso à conta especificada

### 3.3 Tratamento de Erros
- [ ] Retornar erro 400 Bad Request para validações falhadas
- [ ] Incluir mensagem de erro descritiva
- [ ] Incluir campo que falhou na validação
- [ ] Testar casos de erro com API

### 3.4 Testes de Validação
- [ ] Testar criar subject com nome vazio → erro
- [ ] Testar criar subject com nome > 255 chars → erro
- [ ] Testar criar subject com code duplicado → erro
- [ ] Testar criar subject com credits < 0 → erro
- [ ] Testar criar subject com credits > 20 → erro
- [ ] Testar criar subject com year < 1900 → erro
- [ ] Testar criar subject com year > 2100 → erro
- [ ] Testar criar subject com status inválido → erro
- [ ] Testar criar subject com owner_id inválido → erro
- [ ] Testar criar subject com account_id inválido → erro
- [ ] Testar criar subject válido → sucesso
- [ ] Testar atualizar subject com dados inválidos → erro
- [ ] Testar atualizar subject com dados válidos → sucesso

**Critérios de Aceitação**:
- ✓ Todas as validações estão implementadas
- ✓ Dados inválidos são rejeitados
- ✓ Erros de validação retornam mensagens claras
- ✓ Dados válidos são aceitos sem problemas
- ✓ 100% dos testes de validação passam
- ✓ Integridade referencial é mantida

**Tempo Estimado**: 2-3 horas

---

## Resumo de Tarefas

| Task | Descrição | Estimado | Status |
|------|-----------|----------|--------|
| 1 | Create subjects table | 1-2h | ⏳ Não iniciado |
| 2 | Add foreign key | 1-2h | ⏳ Não iniciado |
| 3 | Validate fields | 2-3h | ⏳ Não iniciado |
| **TOTAL** | | **4-7h** | |

---

## Checklist Geral de Implementação

- [ ] Tabela criada com todos os campos
- [ ] Foreign keys relacionados a user e account
- [ ] Índices otimizando queries
- [ ] Validações em banco de dados
- [ ] Validações em API
- [ ] Testes de integridade passando
- [ ] Documentação atualizada
- [ ] Código revisado e aprovado
- [ ] Deploy em produção

---

## Notas

- Usar XanoScript para definições de tabela
- Seguir padrões existentes no projeto
- Manter backward compatibility
- Testar cada subtarefa antes de marcar como completa
- Documentar qualquer desvio do plano
