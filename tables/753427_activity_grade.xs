table "activity_grade" {
  description = "Armazena as notas das atividades dos alunos, com isolamento multi-tenant e auditoria."

  schema {
    int id {
      description = "Identificador único da nota"
    }
    timestamp created_at {
      description = "Timestamp de criação do registro"
    }
    timestamp updated_at {
      description = "Timestamp da última atualização do registro"
    }
    int account_id {
      table = "account"
      description = "ID da conta para isolamento multi-tenant"
    }
    int activity_id {
      table = "academic_task"
      description = "ID da atividade acadêmica avaliada"
    }
    int student_id {
      table = "user"
      description = "ID do aluno que recebeu a nota"
    }
    int professor_id {
      table = "user"
      description = "ID do professor que lançou a nota"
    }
    decimal grade filters=min:0.0|max:10.0 {
      description = "Valor numérico da nota, entre 0.0 e 10.0"
    }
    text? feedback {
      description = "Comentários/feedback opcional do professor"
    }
    text status?="submitted" {
      description = "Estado da nota (ex: submitted, reviewed, disputed)"
    }
    bool is_active?=true {
      description = "Flag para soft-delete"
    }
    int created_by {
      table = "user"
      description = "ID do usuário que criou o registro (auditoria)"
    }
    int updated_by {
      table = "user"
      description = "ID do usuário que atualizou o registro por último (auditoria)"
    }
  }

  index = [
    { type: "primary", field: [{ name: "id" }] },
    { type: "unique", field: [{ name: "account_id" }, { name: "activity_id" }, { name: "student_id" }], name: "idx_unique_grade_per_student_activity" },
    { type: "btree", field: [{ name: "account_id" }] },
    { type: "btree", field: [{ name: "activity_id" }] },
    { type: "btree", field: [{ name: "student_id" }] },
    { type: "btree", field: [{ name: "professor_id" }] }
  ]
}