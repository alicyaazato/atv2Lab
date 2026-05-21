// Trigger definitions for academic_task table
// Handles automatic event logging on create, update, delete

trigger on academic_task table_before_insert {
  // Validate foreign key references before insert
  db.query user {
    filter = {id: $record.user_id}
  } as $user_exists
  
  if !$user_exists.items {
    return error("User does not exist")
  }
  
  db.query subject {
    filter = {id: $record.subject_id}
  } as $subject_exists
  
  if !$subject_exists.items {
    return error("Subject does not exist")
  }
  
  set $record.created_at = "now"
  set $record.updated_at = "now"
}

trigger on academic_task table_after_insert {
  // Log academic task creation event
  fn.call "Getting Started Template/create_event_log" {
    user_id: $record.user_id
    account_id: null
    action: "academic_task.created"
    metadata: {
      task_id: $record.id
      task_title: $record.title
      user_id: $record.user_id
      subject_id: $record.subject_id
      due_date: $record.due_date
      status: $record.status
    }
  }
}

trigger on academic_task table_before_update {
  // Update the updated_at timestamp
  set $record.updated_at = "now"
}

trigger on academic_task table_after_update {
  // Log academic task update event with changes
  db.query academic_task {
    filter = {id: $record.id}
  } as $old_record
  
  set $changes = {}
  
  if $old_record.items[0].title != $record.title {
    set $changes.title = {
      from: $old_record.items[0].title
      to: $record.title
    }
  }
  
  if $old_record.items[0].status != $record.status {
    set $changes.status = {
      from: $old_record.items[0].status
      to: $record.status
    }
  }
  
  if $old_record.items[0].due_date != $record.due_date {
    set $changes.due_date = {
      from: $old_record.items[0].due_date
      to: $record.due_date
    }
  }
  
  if $old_record.items[0].description != $record.description {
    set $changes.description = {
      from: $old_record.items[0].description
      to: $record.description
    }
  }
  
  if $changes {
    fn.call "Getting Started Template/create_event_log" {
      user_id: $record.user_id
      account_id: null
      action: "academic_task.updated"
      metadata: {
        task_id: $record.id
        task_title: $record.title
        changes: $changes
      }
    }
  }
}

trigger on academic_task table_before_delete {
  // Prepare for deletion - no soft delete for academic_task
  // Just ensure timestamps are updated
  set $record.updated_at = "now"
}

trigger on academic_task table_after_delete {
  // Log academic task deletion event
  fn.call "Getting Started Template/create_event_log" {
    user_id: $auth.user_id
    account_id: null
    action: "academic_task.deleted"
    metadata: {
      task_id: $record.id
      task_title: $record.title
      user_id: $record.user_id
      subject_id: $record.subject_id
      reason: "user_initiated"
    }
  }
}
