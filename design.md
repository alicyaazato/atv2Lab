## Context

O projeto EduTrack AI utiliza Xano como backend (XanoScript) e Streamlit como frontend (Python). Atualmente, não existe capacidade de registrar notas para atividades específicas. Professores precisam avaliar alunos, mas o sistema não fornece interface ou armazenamento para isso.

**Stakeholders:**
- Professores: Lançam notas
- Alunos: Podem consultar próprias notas (futuro)
- Administradores: Gerenciam dados acadêmicos

## Goals / Non-Goals

**Goals:**
- Criar estrutura de dados para armazenar notas de atividades.
- Implementar uma API REST para que professores possam lançar notas.
- Validar permissões (apenas o professor responsável pela disciplina da atividade pode lançar notas).

**Non-Goals:**
- Consulta/listagem de notas (pode ser adicionada posteriormente).
- Cálculo automático de média.
- Integração com relatórios ou exportação.
- Edição ou exclusão de notas já lançadas.

## Decisions

**Decision 1: Estrutura da tabela `activity_grades`**
- **Choice**: Criar uma tabela separada com chaves estrangeiras para `users` (aluno), `academic_tasks` (atividade) e `users` (professor que lançou a nota).
- **Rationale**: Permite rastrear quem lançou a nota, para qual aluno e em qual atividade. Facilita auditoria e futuras consultas. A alternativa de armazenar as notas dentro da tabela `academic_tasks` foi rejeitada por não ser escalável para múltiplos alunos.

**Decision 2: Validação de permissões**
- **Choice**: A validação será implementada na lógica da API em XanoScript. A API verificará se o usuário autenticado (professor) tem permissão para lançar notas para a atividade especificada.
- **Rationale**: Garante a segurança no backend e reutiliza a lógica de autorização existente.

**Decision 3: Endpoint de lançamento de notas**
- **Choice**: Criar um endpoint `POST /activity_grades`.
- **Rationale**: Segue o padrão RESTful para criação de novos recursos.

## Risks / Trade-offs

- **[Risk] Lançamento de nota duplicada**: Um professor poderia, teoricamente, lançar mais de uma nota para o mesmo aluno na mesma atividade.
  - **Mitigation**: A aplicação frontend pode realizar uma verificação prévia. Se necessário, um índice composto `(academic_task_id, student_id)` pode ser adicionado ao banco de dados no futuro para garantir a unicidade.

## Migration Plan

1. Criar a tabela `activity_grades` no Xano.
2. Criar a API `POST /activity_grades` com a lógica de validação de permissão.
3. Testar o endpoint para cenários de sucesso e erro.
4. Documentar a API para consumo pelo frontend.