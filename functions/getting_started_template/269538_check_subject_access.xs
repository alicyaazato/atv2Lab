// Check if user has access to a subject based on ownership and role
function "Getting Started Template/check_subject_access" {
  input {
    // The ID of the subject to check access for
    int subject_id
    
    // The ID of the user making the request
    int user_id
    
    // The account ID the user belongs to
    int account_id
    
    // The action being performed (read, update, delete)
    text action = "read"
  }

  stack {
    // Get the subject details
    db.get subject {
      field_name = "id"
      field_value = $input.subject_id
      output = ["id", "owner_id", "account_id"]
    } as $subject

    // Check if subject exists - return 404 to prevent resource enumeration
    precondition ($subject != null) {
      error_type = "notfound"
      error = "Subject not found"
    }

    // Check if subject belongs to user's account
    precondition ($subject.account_id == $input.account_id) {
      error_type = "notfound"
      error = "Subject not found"
    }

    // Get user details including role
    db.get user {
      field_name = "id"
      field_value = $input.user_id
      output = ["role", "account_id"]
    } as $user

    precondition ($user != null) {
      error_type = "accessdenied"
      error = "User not found"
    }

    // Check authorization based on ownership and role
    set $is_owner = $subject.owner_id == $input.user_id
    set $is_admin = $user.role == "admin"

    // Only owner or admin can perform any action
    conditional {
      if (!$is_owner && !$is_admin) {
        // Not owner and not admin - deny access
        throw {
          name = "accessdenied"
          value = "Access denied to this subject"
        }
      }
    }

    // Additional check for delete action - only owner or admin
    if ($input.action == "delete") {
      conditional {
        if (!$is_owner && !$is_admin) {
          throw {
            name = "accessdenied"
            value = "Only owner or admin can delete this subject"
          }
        }
      }
    }
  }

  response = {
    allowed: true
    is_owner: $is_owner
    is_admin: $is_admin
  }
  tags = ["xano:quick-start"]
}
