// Create a new subject
query "subjects" verb=POST {
  api_group = "Subjects"

  input {
    text name filters=trim
    text code? filters=trim
    text description? filters=trim
    number credits?
    text semester?
    number year?
    text status = "active"
    number account_id
  }

  stack {
    // Verify user is authenticated
    precondition ($auth.user_id) {
      error_type = "accessdenied"
      error = "Authentication required"
    }

    // Validate required fields
    precondition ($input.name && $input.name.length > 0) {
      error_type = "validation_error"
      error = "Subject name is required"
    }

    precondition ($input.name.length <= 255) {
      error_type = "validation_error"
      error = "Subject name must be max 255 characters"
    }

    // Validate account exists and user has access
    db.get account {
      field_name = "id"
      field_value = $input.account_id
      output = ["id"]
    } as $account

    precondition ($account != null) {
      error_type = "notfound"
      error = "Account not found"
    }

    // Get user's account
    db.get user {
      field_name = "id"
      field_value = $auth.user_id
      output = ["account_id", "role"]
    } as $user

    // Check user belongs to the account
    precondition ($user.account_id == $input.account_id) {
      error_type = "accessdenied"
      error = "You do not have access to this account"
    }

    // Validate code is unique if provided
    if $input.code {
      db.query subject {
        filter = {
          account_id: $input.account_id
          code: $input.code
        }
      } as $code_exists

      precondition (!$code_exists.items || $code_exists.items.length == 0) {
        error_type = "validation_error"
        error = "Subject code already exists in this account"
      }
    }

    // Validate optional fields
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

    precondition ($input.status == "active" || $input.status == "archived" || $input.status == "draft") {
      error_type = "validation_error"
      error = "Status must be one of: active, archived, draft"
    }

    // Create subject
    db.add subject {
      data = {
        name: $input.name
        code: $input.code
        description: $input.description
        credits: $input.credits
        semester: $input.semester
        year: $input.year
        status: $input.status
        owner_id: $auth.user_id
        account_id: $input.account_id
        is_active: true
        created_at: "now"
        updated_at: "now"
      }
    } as $new_subject
  }

  response = {
    data: {
      id: $new_subject.id
      name: $new_subject.name
      code: $new_subject.code
      description: $new_subject.description
      owner_id: $new_subject.owner_id
      account_id: $new_subject.account_id
      credits: $new_subject.credits
      semester: $new_subject.semester
      year: $new_subject.year
      status: $new_subject.status
      is_active: $new_subject.is_active
      created_at: $new_subject.created_at
      updated_at: $new_subject.updated_at
    }
  }
  tags = ["xano:quick-start"]
}
