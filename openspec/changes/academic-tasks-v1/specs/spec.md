# academic_task Specification

## Purpose

Define a estrutura de banco de dados para o gerenciamento de tarefas acadêmicas
no EduTrack AI, permitindo que alunos registrem e acompanhem suas obrigações
(lições, provas, trabalhos) vinculadas a disciplinas específicas.

## ADDED Requirements

### Requirement: Create academic_task table

The system SHALL store academic task information for each student in a table
named `academic_task`.

#### Scenario: Student registers a new academic task
- **WHEN** a student submits a new task with `title`, `due_date`, `status` and
  `subject_id`
- **THEN** the system stores the record linked to both the authenticated student
  (`user_id`) and the referenced subject (`subject_id`)

### Requirement: Link tasks to subjects

The system SHALL associate each academic task with an existing subject via
`subject_id`.

#### Scenario: Task is linked to a valid subject
- **WHEN** an academic task is created with a given `subject_id`
- **THEN** `subject_id` SHALL reference an existing record in the `subject` table

### Requirement: Enforce ownership per student

The system SHALL associate each academic task with the student who created it
via `user_id`.

#### Scenario: Task ownership is set on creation
- **WHEN** a student creates a task
- **THEN** `user_id` SHALL be set to the authenticated user's id

### Requirement: Track task completion status

The system SHALL track the completion status of each academic task using a
controlled vocabulary.

#### Scenario: Default status on creation
- **WHEN** a task is created without an explicit `status`
- **THEN** `status` SHALL default to `"pending"`

#### Scenario: Valid status values
- **WHEN** a status value is provided
- **THEN** the system SHALL only accept one of: `pending`, `in_progress`,
  `completed`, `overdue`

### Requirement: Store task due date

The system SHALL store the deadline for each task in a `due_date` field.

#### Scenario: Due date stored correctly
- **WHEN** a task is created with a `due_date`
- **THEN** the system SHALL store it as a date type field
