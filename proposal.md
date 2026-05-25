## Why

Professores precisam de uma forma de avaliar o trabalho realizado pelos alunos em atividades específicas. Atualmente, o sistema não permite o registro de notas para cada atividade, o que impossibilita o acompanhamento do desempenho dos alunos e a geração de relatórios acadêmicos.

## What Changes

- **Criar tabela `activity_grades`**: Uma nova tabela para armazenar as notas que os professores lançam para os alunos em atividades específicas.
- **Criar API `POST /activity_grades`**: Um novo endpoint que permitirá aos professores registrar essas notas no sistema.

## Capabilities

### New Capabilities
- `activity-grades`: Adiciona a capacidade de armazenar e registrar notas de atividades para os alunos.

## Impact

- **Banco de dados**: Adição da nova tabela `activity_grades`, que terá relacionamentos com as tabelas `users` (para o aluno e para o professor) e `academic_tasks` (para a atividade).
- **APIs**: Adição de um novo endpoint `POST /activity_grades` para o lançamento de notas.