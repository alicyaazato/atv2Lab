# Tarefas de Implementação - Feature: Notas de Atividades

## Visão Geral
Este documento detalha as tarefas necessárias para implementar a funcionalidade que permite aos professores lançar notas para alunos em atividades específicas. O escopo está estritamente limitado ao que foi solicitado.

---

## Task 1: Criar a tabela `activity_grades`

**Descrição**: Criar a tabela `activity_grades` no banco de dados Xano para armazenar as notas das atividades.

**Subtarefas**:
- [ ] Criar a tabela `activity_grades`.
- [ ] Adicionar campo `id` (int, primary key, auto-increment).
- [ ] Adicionar campo `created_at` (timestamp, auto-set).
- [ ] Adicionar campo `grade` (decimal, para a nota).
- [ ] Adicionar campo `academic_task_id` (int, foreign key para `academic_tasks.id`).
- [ ] Adicionar campo `student_id` (int, foreign key para `users.id`).
- [ ] Adicionar campo `teacher_id` (int, foreign key para `users.id`).

---

## Task 2: Criar a API para Lançar Notas

**Descrição**: Criar o endpoint `POST /activity_grades` que permite a um professor autenticado lançar uma nota para um aluno em uma atividade.

**Subtarefas**:
- [ ] Criar o endpoint da API `POST /activity_grades`.
- [ ] Implementar a lógica para receber `academic_task_id`, `student_id` e `grade` como entradas.
- [ ] Adicionar validação para garantir que o usuário autenticado (professor) tem permissão para lançar notas para a atividade especificada.
- [ ] Inserir o novo registro de nota na tabela `activity_grades`, associando o `teacher_id` ao usuário autenticado.