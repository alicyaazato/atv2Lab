// Delete a subject
query "subjects/{id}" verb=DELETE {
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
        "owner_id"
        "account_id"
      ]
    } as $subject

    // Check if subject exists
    precondition ($subject != null) {
      error_type = "notfound"
      error = "Subject not found"
    }

    // Get user's role
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

    // Delete (soft delete via trigger)
    db.delete subject {
      filter = {id: $input.id}
    }

    // Log deletion event
    function.run "Getting Started Template/create_event_log" {
      input = {
        user_id: $auth.user_id
        account_id: $subject.account_id
        action: "subject.deleted"
        metadata: {
          subject_id: $subject.id
          subject_name: $subject.name
          reason: "user_initiated"
        }
      }
    } as $event_log
  }

  response = {
    message: "Subject deleted successfully"
    data: {
      id: $input.id
    }
  }
  tags = ["xano:quick-start"]
}
