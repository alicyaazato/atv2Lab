// Academic subjects registered by users with explicit ownership for access control
// and future automation.
table subject {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
    
    timestamp updated_at?=now {
      visibility = "private"
    }

    // Owner user that created/owns this subject record
    int owner_id {
      table = "user"
    }

    // Account context - required for multi-tenant setups
    int account_id {
      table = "account"
    }

    text name filters=trim {
      validations = "max:255"
    }
    
    text code? filters=trim {
      validations = "max:50"
    }
    
    text description? filters=trim {
      validations = "max:2000"
    }
    
    text semester? {
      validations = "pattern:^[0-9]º$"
    }
    
    int year? {
      validations = "min:1900|max:2100"
    }
    
    int credits? {
      validations = "min:0|max:20"
    }

    enum status {
      values = ["active", "archived", "draft"]
      default = "active"
    }
    
    bool is_active? {
      default = true
    }

    JSON? metadata {
      visibility = "private"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
    {type: "btree", field: [{name: "updated_at", op: "desc"}]}
    {type: "btree", field: [{name: "owner_id", op: "asc"}, {name: "idx_owner_id"}]}
    {type: "btree", field: [{name: "account_id", op: "asc"}, {name: "idx_account_id"}]}
    {type: "btree|unique", field: [{name: "account_id", op: "asc"}, {name: "code", op: "asc"}, {name: "idx_account_code"}]}
    {type: "btree", field: [{name: "status", op: "asc"}, {name: "idx_status"}]}
    {type: "gin", field: [{name: "xdo", op: "jsonb_path_op"}]}
  ]

  tags = ["xano:quick-start"]
}