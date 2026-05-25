# Tarefas de Implementação - Feature: academic_tasks
> Referência: tarefa 11_v2.md | 2026-04-16
> Escopo: apenas o que foi explicitamente solicitado (REGRA Nº 1 do AGENTS.md)

---

## Task 1: Criar a tabela `academic_task`

**Agente responsável:** Xano Table Designer
**Arquivo de destino:** `tables/<id>_academic_task.xs`

**Subtarefas:**
- [ ] Verificar `docs/table_guideline.md` antes de criar o arquivo `.xs`
- [ ] Criar campo `id` (int, primary key, auto-increment)
- [ ] Criar campo `created_at` (timestamp, default now, visibility private)
- [ ] Criar campo `updated_at` (timestamp, default now, visibility private)
- [ ] Criar campo `user_id` (int, FK → `user`) — dono da tarefa (aluno)
- [ ] Criar campo `subject_id` (int, FK → `subject`) — disciplina vinculada
- [ ] Criar campo `title` (text, obrigatório, max 255, filtro trim)
- [ ] Criar campo `description` (text, opcional, filtro trim)
- [ ] Criar campo `due_date` (date, obrigatório)
- [ ] Criar campo `status` (enum: pending | in_progress | completed | overdue, default: pending)
- [ ] Adicionar index primary em `id`
- [ ] Adicionar index btree em `user_id` (asc)
- [ ] Adicionar index btree em `subject_id` (asc)
- [ ] Adicionar index btree em `status` (asc)
- [ ] Adicionar index btree em `due_date` (asc)
- [ ] Adicionar index btree composto em `user_id` + `status` (para queries filtradas)
- [ ] Revisar o arquivo gerado antes do push manual
