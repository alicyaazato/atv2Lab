// Get a specific subject by ID
query "subjects/{id}" verb=GET {
  api_group = "Subjects"

  input {
    number id
  }

  stack {
    // Verify user is authenticated
    precondition ($auth.user_id) {
      error_type = "accessdenied"
      error = "Authentication required"
    }

    // Get the subject
    db.get subject {
      field_name = "id"
      field_value = $input.id
      output = [
        "id"
        "name"
        "code"
        "description"
        "owner_id"
        "account_id"
        "credits"
        "semester"
        "year"
        "status"
        "is_active"
        "created_at"
        "updated_at"
      ]
    } as $subject

    // Check if subject exists
    precondition ($subject != null) {
      error_type = "notfound"
      error = "Subject not found"
    }

    // Get user's role in account
    db.get user {
      field_name = "id"
      field_value = $auth.user_id
      output = ["role", "account_id"]
    } as $user

    // Check authorization
    set $is_owner = $subject.owner_id == $auth.user_id
    set $is_admin = $user.role == "admin" && $user.account_id == $subject.account_id
    
    precondition ($is_owner || $is_admin) {
      error_type = "accessdenied"
      error = "Access denied"
    }

    // Log access event
    function.run "Getting Started Template/create_event_log" {
      input = {
        user_id: $auth.user_id
        account_id: $subject.account_id
        action: "subject.accessed"
        metadata: {
          subject_id: $subject.id
          accessor_role: $is_admin ? "admin" : "owner"
        }
      }
    } as $event_log
  }

  response = {data: $subject}
  tags = ["xano:quick-start"]
}
