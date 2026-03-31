// List authenticated user's subjects
query "subjects/my" verb=GET {
  api_group = "Subjects"

  input {
    number limit = 20 filters=min:1|max:100
    number offset = 0 filters=min:0
    text status?
    text semester?
    number year?
  }

  stack {
    // Verify user is authenticated
    precondition ($auth.user_id) {
      error_type = "accessdenied"
      error = "Authentication required"
    }

    // Get user's account
    db.get user {
      field_name = "id"
      field_value = $auth.user_id
      output = ["account_id"]
    } as $user

    // Build filter conditions
    set $filter = {
      owner_id: $auth.user_id,
      account_id: $user.account_id
    }

    // Add optional filters
    if $input.status {
      set $filter.status = $input.status
    }

    if $input.semester {
      set $filter.semester = $input.semester
    }

    if $input.year {
      set $filter.year = $input.year
    }

    // Query subjects
    db.query subject {
      filter = $filter
      limit = $input.limit
      offset = $input.offset
      sort = [{field: "created_at", op: "desc"}]
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
    } as $subjects

    // Get total count
    db.count subject {
      filter = $filter
    } as $total_count
  }

  response = {
    data: $subjects.items
    pagination: {
      total: $total_count
      limit: $input.limit
      offset: $input.offset
    }
  }
  tags = ["xano:quick-start"]
}
