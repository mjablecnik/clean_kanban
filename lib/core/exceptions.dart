
sealed class KanbanException implements Exception {
  final String message;
  const KanbanException(this.message);
}

class ColumnLimitExceededException extends KanbanException {
  final String columnId;
  const ColumnLimitExceededException(this.columnId)
      : super('Column limit exceeded for $columnId');
}

class OperationLimitedToDoneColumnException extends KanbanException {
  const OperationLimitedToDoneColumnException()
      : super('This operation is only allowed for the Done column');
}

class TaskOperationException extends KanbanException {
  const TaskOperationException(String message) : super(message);
}

class ColumnOperationException extends KanbanException {
  const ColumnOperationException(String message) : super(message);
}