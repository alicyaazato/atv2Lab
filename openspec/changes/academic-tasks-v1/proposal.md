# academic_tasks - Proposal

## Why

O EduTrack AI precisa permitir que alunos registrem e acompanhem suas obrigações
acadêmicas (lições, provas, trabalhos) vinculadas a cada disciplina. Sem essa
estrutura de dados, não há como organizar, priorizar ou rastrear o status de
conclusão das tarefas por disciplina.

## What Changes

- Nova tabela `academic_task` com os campos solicitados:
  - `title` (text, obrigatório) — título da tarefa
  - `description` (text, opcional) — descrição detalhada
  - `due_date` (date, obrigatório) — prazo de entrega
  - `status` (enum, default "pending") — estado de conclusão
  - `subject_id` (int, FK → `subject.id`) — vínculo com a disciplina
- Campos estruturais obrigatórios (por convenção do projeto):
  - `id` (primary key), `created_at`, `updated_at`, `user_id` (FK → `user.id`)
- Indexes em `user_id`, `subject_id`, `status` e `due_date` para performance

## Impact

- Banco de dados: 1 nova tabela `academic_task`
- Relacionamentos novos: `academic_task.subject_id` → `subject.id` e
  `academic_task.user_id` → `user.id`
- Sem impacto em tabelas ou APIs existentes
