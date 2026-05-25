# Design Técnico - Base de Dados para Subjects

## Definição das Tabelas

### 1. Tabela `subject`
Armazena as disciplinas acadêmicas de cada usuário com propriedade definida.

**Campos:**
- `id` (int, PK, auto-increment) - Identificador único
- `owner_id` (int, FK → user) - Usuário proprietário da disciplina
- `account_id` (int, FK → account) - Conta/organização responsável
- `name` (text, required) - Nome da disciplina
- `code` (text, unique per account) - Código da disciplina (ex: MAT101)
- `description` (text) - Descrição e ementa
- `credits` (int) - Créditos/carga horária (0-20)
- `semester` (text) - Semestre (1º, 2º, etc)
- `year` (int) - Ano acadêmico
- `status` (enum: active, archived, draft) - Estado da disciplina
- `is_active` (boolean, default: true) - Flag de atividade
- `created_at` (timestamp) - Data de criação
- `updated_at` (timestamp) - Data da última atualização
- `metadata` (JSON, private) - Dados adicionais

## Relacionamentos

```
subject.owner_id ──→ user.id
  └─ Cada subject pertence a um usuário proprietário

subject.account_id ──→ account.id
  └─ Cada subject está associado a uma conta/organização
```

## Índices

- `idx_owner_id` (owner_id) - Otimiza queries por proprietário
- `idx_account_id` (account_id) - Otimiza queries por conta
- `idx_account_code` (account_id, code) - Garante unicidade de código por conta
- `idx_status` (status) - Otimiza filtros por status
- `idx_created_at` (created_at DESC) - Otimiza ordenação temporal

## Decisões Estruturais

### 1. Propriedade e Multi-tenancy
- **Decisão**: Usar `owner_id` + `account_id` para estabelecer propriedade clara
- **Justificativa**: Permite controle granular (usuário é dono) e isolamento por organização
- **Benefício**: Suporta futuras automações e compartilhamento seletivo

### 2. Soft Delete vs Hard Delete
- **Decisão**: Implementar soft delete via status e is_active
- **Justificativa**: Preserva histórico de eventos e referências
- **Implementação**: Trigger before_delete marca como `archived` e `is_active = false`

### 3. Timestamps Automáticos
- **Decisão**: `created_at` e `updated_at` automáticos em nível de banco
- **Justificativa**: Eleva a integridade dos dados e facilitatrilha de auditoria
- **Implementação**: Triggers atualizam `updated_at` em UPDATE

### 4. Validações em Nível de Banco
- **Decisão**: Validações em triggers (FK, limites de campo)
- **Justificativa**: Garante integridade mesmo com múltiplas conexões
- **Constraints**: 
  - Credits: 0-20
  - Year: 1900-2100
  - Name: max 255 chars
  - Description: max 2000 chars

### 5. Separação de Código por Disciplina
- **Decisão**: `code` é único por `account_id` (não global)
- **Justificativa**: Diferentes contas podem ter mesmos códigos
- **Índice Composto**: (account_id, code) mantém unicidade

### 6. Auditoria via Event Logging
- **Decisão**: Triggers automáticos registram eventos em `event_logs`
- **Eventos Gerados**:
  - `subject.created` - Quando disciplina é criada
  - `subject.updated` - Quando disciplina é modificada
  - `subject.deleted` - Quando disciplina é deletada
- **Justificativa**: Rastreabilidade completa sem overhead de aplicação

## Fluxo de Controle de Acesso

```
Request → Verificar Auth → Verificar Ownership → Verificar Role
                              ↓
                    Owner? → Permitir
                       ↓
                    Admin da conta? → Permitir
                       ↓
                    Compartilhado? → Permitir
                       ↓
                    Negar (403/404)
```

## Escalabilidade e Performance

- **Índices B-tree** em FK e status para queries rápidas
- **Índice GIN** em metadata JSON para busca avançada
- **Paginação** obrigatória em endpoints de listagem
- **Filtros** por status, semester, year para reduzir resultados

## Scripts de Migração

Nenhuma migração necessária - tabela `subject` já existe e foi atualizada conforme design.