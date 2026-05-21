// Academic tasks registered by students to track their academic obligations
// (lessons, tests, assignments) linked to specific subjects with status tracking.
table academic_task {
  auth = false

  schema {
    int id
    
    timestamp created_at?=now {
      visibility = "private"
    }
    
    timestamp updated_at?=now {
      visibility = "private"
    }

    // Student who owns/created this academic task
    int user_id {
      table = "user"
    }

    // Subject this task is linked to
    int subject_id {
      table = "subject"
    }

    // Task title/name (required)
    text title filters=trim {
      validations = "required|max:255"
    }
    
    // Detailed task description (optional)
    text description? filters=trim {
      validations = "max:2000"
    }
    
    // Due date for task completion
    date due_date {
      validations = "required|date"
    }

    // Status of task completion
    enum status {
      values = ["pending", "in_progress", "completed", "overdue"]
      default = "pending"
    }

    // Additional metadata stored as JSON
    JSON? metadata {
      visibility = "private"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
    {type: "btree", field: [{name: "updated_at", op: "desc"}]}
    {type: "btree", field: [{name: "user_id", op: "asc"}, {name: "idx_user_id"}]}
    {type: "btree", field: [{name: "subject_id", op: "asc"}, {name: "idx_subject_id"}]}
    {type: "btree", field: [{name: "status", op: "asc"}, {name: "idx_status"}]}
    {type: "btree", field: [{name: "user_id", op: "asc"}, {name: "status", op: "asc"}, {name: "idx_user_status"}]}
    {type: "btree", field: [{name: "due_date", op: "asc"}, {name: "idx_due_date"}]}
  ]

  tags = ["xano:academic-tasks"]
}
