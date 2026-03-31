// Trigger definitions for subject table
// Handles automatic event logging on create, update, delete

trigger on subject table_before_insert {
  // Validate foreign key references before insert
  db.query user {
    filter = {id: $record.owner_id}
  } as $owner_exists
  
  if !$owner_exists.items {
    return error("Owner user does not exist")
  }
  
  db.query account {
    filter = {id: $record.account_id}
  } as $account_exists
  
  if !$account_exists.items {
    return error("Account does not exist")
  }
  
  set $record.created_at = "now"
  set $record.updated_at = "now"
}

trigger on subject table_after_insert {
  // Log subject creation event
  fn.call "Getting Started Template/create_event_log" {
    user_id: $record.owner_id
    account_id: $record.account_id
    action: "subject.created"
    metadata: {
      subject_id: $record.id
      subject_name: $record.name
      code: $record.code
      status: $record.status
      credits: $record.credits
    }
  }
}

trigger on subject table_before_update {
  // Update the updated_at timestamp
  set $record.updated_at = "now"
}

trigger on subject table_after_update {
  // Log subject update event with changes
  db.query subject {
    filter = {id: $record.id}
  } as $old_record
  
  set $changes = {}
  
  if $old_record.items[0].name != $record.name {
    set $changes.name = {
      from: $old_record.items[0].name
      to: $record.name
    }
  }
  
  if $old_record.items[0].status != $record.status {
    set $changes.status = {
      from: $old_record.items[0].status
      to: $record.status
    }
  }
  
  if $old_record.items[0].credits != $record.credits {
    set $changes.credits = {
      from: $old_record.items[0].credits
      to: $record.credits
    }
  }
  
  if $changes {
    fn.call "Getting Started Template/create_event_log" {
      user_id: $record.owner_id
      account_id: $record.account_id
      action: "subject.updated"
      metadata: {
        subject_id: $record.id
        subject_name: $record.name
        changes: $changes
      }
    }
  }
}

trigger on subject table_before_delete {
  // Soft delete - mark as inactive instead of hard delete
  set $record.is_active = false
  set $record.status = "archived"
  set $record.updated_at = "now"
}

trigger on subject table_after_delete {
  // Log subject deletion/archival event
  fn.call "Getting Started Template/create_event_log" {
    user_id: $auth.user_id
    account_id: $record.account_id
    action: "subject.deleted"
    metadata: {
      subject_id: $record.id
      subject_name: $record.name
      reason: "soft_delete"
    }
  }
}
