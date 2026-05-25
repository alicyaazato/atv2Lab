# Especificação de Requisitos Formais - Subject Database

## Requisitos Funcionais

### Armazenamento de Subjects

1. **REQ-001**: The system SHALL store subjects in a persistent database table named `subject`
   - Each subject record SHALL have a unique identifier (`id`)
   - The `id` SHALL be auto-generated and immutable
   - Storage SHALL support at least 1,000,000 subject records

2. **REQ-002**: The system SHALL store the following attributes for each subject:
   - `name` (required, text, max 255 characters) - Name of the academic discipline
   - `code` (optional, text, max 50 characters) - Discipline code (e.g., MAT101)
   - `description` (optional, text, max 2000 characters) - Course description and syllabus
   - `credits` (optional, integer, range 0-20) - Credit hours
   - `semester` (optional, text) - Academic semester
   - `year` (optional, integer, range 1900-2100) - Academic year
   - `status` (required, enum: active|archived|draft) - Subject state
   - `is_active` (required, boolean) - Activity flag

3. **REQ-003**: The system SHALL enforce data validation rules:
   - `name` SHALL NOT be empty
   - `credits` SHALL be between 0 and 20
   - `year` SHALL be between 1900 and 2100
   - `code` SHALL be unique within an account
   - `status` SHALL only accept predefined enum values

### Associação com Usuários

4. **REQ-004**: The system SHALL associate each subject with a user owner
   - Each subject record SHALL contain a `owner_id` field
   - `owner_id` SHALL reference an existing `user.id`
   - The relationship SHALL be one user to many subjects
   - The system SHALL prevent orphaned subjects (owner must exist)

5. **REQ-005**: The system SHALL associate each subject with an account
   - Each subject record SHALL contain an `account_id` field
   - `account_id` SHALL reference an existing `account.id`
   - The relationship SHALL enable multi-tenant isolation
   - Subjects from different accounts SHALL be logically isolated

6. **REQ-006**: The system SHALL maintain ownership clarity
   - The `owner_id` SHALL indicate who created/owns the subject
   - The system SHALL NOT allow ownership transfer without explicit authorization
   - The system SHALL log ownership-related changes

### Timestamps e Auditoria

7. **REQ-007**: The system SHALL track subject lifecycle events
   - `created_at` SHALL be automatically set to current timestamp on creation
   - `updated_at` SHALL be automatically set to current timestamp on any modification
   - Both timestamps SHALL be immutable after initial set (system-managed only)

8. **REQ-008**: The system SHALL maintain audit trail
   - The system SHALL record all subject creation events in `event_logs`
   - The system SHALL record all subject modification events in `event_logs`
   - The system SHALL record all subject deletion events in `event_logs`
   - Audit records SHALL include user_id, account_id, action, and timestamp

### Acesso e Permissões

9. **REQ-009**: The system SHALL enforce access control
   - Users SHALL only access subjects they own
   - Admins SHALL access all subjects within their account
   - The system SHALL return 403 Forbidden for unauthorized access
   - The system SHALL return 404 Not Found (not 403) to prevent resource enumeration

10. **REQ-010**: The system SHALL support role-based access control
    - `owner` role: Can create, read, update, delete own subjects
    - `admin` role: Can manage all subjects in account
    - `member` role: Can access only own subjects
    - The system SHALL verify role at every endpoint

### Operações CRUD

11. **REQ-011**: The system SHALL support subject creation
    - The system SHALL accept POST request to `/subjects`
    - Required fields: `name`, `account_id`
    - The system SHALL set `owner_id` to authenticated user
    - The system SHALL return 201 Created with full subject data
    - The system SHALL validate all input fields

12. **REQ-012**: The system SHALL support subject retrieval
    - The system SHALL accept GET request to `/subjects/my` for user's subjects
    - The system SHALL accept GET request to `/subjects/{id}` for specific subject
    - The system SHALL return 200 OK with subject data
    - The system SHALL support pagination on list endpoint

13. **REQ-013**: The system SHALL support subject updates
    - The system SHALL accept PATCH request to `/subjects/{id}`
    - The system SHALL allow owner or admin to modify subject
    - The system SHALL validate all modified fields
    - The system SHALL update `updated_at` timestamp
    - The system SHALL return 200 OK with updated data

14. **REQ-014**: The system SHALL support subject deletion
    - The system SHALL accept DELETE request to `/subjects/{id}`
    - The system SHALL allow owner or admin to delete subject
    - The system SHALL perform soft delete (set `is_active = false`, `status = archived`)
    - The system SHALL log deletion event
    - The system SHALL return 204 No Content

### Filtragem e Busca

15. **REQ-015**: The system SHALL support filtering on list endpoints
    - Filter by `status` field
    - Filter by `semester` field
    - Filter by `year` field
    - The system SHALL support multiple filters simultaneously

16. **REQ-016**: The system SHALL support pagination
    - The system SHALL accept `limit` parameter (default 20, max 100)
    - The system SHALL accept `offset` parameter (default 0)
    - The system SHALL return total count with paginated results
    - The system SHALL sort by `created_at` descending

## Requisitos Não-Funcionais

### Performance

17. **REQ-017**: The system SHALL perform efficiently
    - Lookup by subject ID SHALL complete in < 100ms
    - List subjects for user SHALL complete in < 500ms for 1000 subjects
    - The system SHALL use database indexes on FK and status fields

### Segurança

18. **REQ-018**: The system SHALL prevent unauthorized access
    - The system SHALL require authentication for all endpoints
    - The system SHALL validate JWT tokens on every request
    - The system SHALL prevent SQL injection via parameterized queries
    - The system SHALL sanitize text inputs to prevent XSS

19. **REQ-019**: The system SHALL protect user data
    - Subjects SHALL only be visible to authorized users
    - Cross-account access SHALL be prevented
    - The system SHALL NOT leak existence of unauthorized resources

### Data Integrity

20. **REQ-020**: The system SHALL maintain data consistency
    - The system SHALL enforce foreign key constraints
    - The system SHALL prevent creation of orphaned records
    - The system SHALL validate constraints at database level
    - The system SHALL rollback failed transactions atomically

### Scalability

21. **REQ-021**: The system SHALL support growth
    - The system SHALL handle 1,000,000+ subject records
    - The system SHALL execute queries efficiently with proper indexing
    - The system SHALL partition data by account for isolation

## Requisitos de Conformidade

22. **REQ-022**: The system SHALL audit all changes
    - All operations SHALL generate audit logs
    - Audit logs SHALL be immutable
    - Audit logs SHALL be queryable for compliance

23. **REQ-023**: The system SHALL maintain data accuracy
    - All required fields SHALL be validated before storage
    - The system SHALL reject invalid data with clear errors
    - The system SHALL return descriptive error messages

## Traceability Matrix

| Requisito | Tipo | Tabela | Campo | Status |
|-----------|------|--------|-------|--------|
| REQ-001 | Storage | subject | id | Implemented |
| REQ-002 | Storage | subject | name, code, description, credits, semester, year, status, is_active | Implemented |
| REQ-003 | Validation | subject | All | Implemented |
| REQ-004 | Association | subject | owner_id | Implemented |
| REQ-005 | Association | subject | account_id | Implemented |
| REQ-006 | Ownership | subject | owner_id | Implemented |
| REQ-007 | Audit | subject | created_at, updated_at | Implemented |
| REQ-008 | Audit | event_logs | Log records | Implemented |
| REQ-009 | Security | API | Access Control | Implemented |
| REQ-010 | Security | API | RBAC | Implemented |
| REQ-011 | CRUD | POST /subjects | Create | Implemented |
| REQ-012 | CRUD | GET /subjects | Read | Implemented |
| REQ-013 | CRUD | PATCH /subjects | Update | Implemented |
| REQ-014 | CRUD | DELETE /subjects | Delete | Implemented |
| REQ-015 | Query | GET /subjects | Filtering | Implemented |
| REQ-016 | Query | GET /subjects | Pagination | Implemented |
