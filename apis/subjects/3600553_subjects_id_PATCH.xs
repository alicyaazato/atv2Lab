// Update a subject
query "subjects/{id}" verb=PATCH {
  api_group = "Subjects"

  input {
    number id
    text name?
    text code?
    text description?
    number credits?
    text semester?
    number year?
    text status?
    boolean is_active?
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

    // Validate input fields
    if $input.name {
      precondition ($input.name.length > 0 && $input.name.length <= 255) {
        error_type = "validation_error"
        error = "Subject name must be between 1 and 255 characters"
      }
    }

    if $input.code {
      // Check if code already exists for different subject in same account
      db.query subject {
        filter = {
          account_id: $subject.account_id
          code: $input.code
        }
      } as $code_exists

      if $code_exists.items && $code_exists.items.length > 0 {
        if $code_exists.items[0].id != $input.id {
          precondition (false) {
            error_type = "validation_error"
            error = "Subject code already exists in this account"
          }
        }
      }
    }

    if $input.description {
      precondition ($input.description.length <= 2000) {
        error_type = "validation_error"
        error = "Description must be max 2000 characters"
      }
    }

    if $input.credits {
      precondition ($input.credits >= 0 && $input.credits <= 20) {
        error_type = "validation_error"
        error = "Credits must be between 0 and 20"
      }
    }

    if $input.year {
      precondition ($input.year >= 1900 && $input.year <= 2100) {
        error_type = "validation_error"
        error = "Year must be between 1900 and 2100"
      }
    }

    if $input.status {
      precondition ($input.status == "active" || $input.status == "archived" || $input.status == "draft") {
        error_type = "validation_error"
        error = "Status must be one of: active, archived, draft"
      }
    }

    // Build update data
    set $update_data = {
      updated_at: "now"
    }

    if $input.name {
      set $update_data.name = $input.name
    }

    if $input.code != null {
      set $update_data.code = $input.code
    }

    if $input.description != null {
      set $update_data.description = $input.description
    }

    if $input.credits != null {
      set $update_data.credits = $input.credits
    }

    if $input.semester != null {
      set $update_data.semester = $input.semester
    }

    if $input.year != null {
      set $update_data.year = $input.year
    }

    if $input.status {
      set $update_data.status = $input.status
    }

    if $input.is_active != null {
      set $update_data.is_active = $input.is_active
    }

    // Update subject
    db.update subject {
      filter = {id: $input.id}
      data = $update_data
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
    } as $updated_subject
  }

  response = {data: $updated_subject.items[0]}
  tags = ["xano:quick-start"]
}
