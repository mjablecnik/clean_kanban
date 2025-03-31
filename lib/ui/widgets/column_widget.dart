import 'package:clean_kanban/clean_kanban.dart';
import 'package:flutter/material.dart';
import './task_drag_data.dart';

class KanbanColumnTheme {
  final Color columnBackgroundColor;
  final Color columnBorderColor;
  final Color columnHeaderColor;
  final Color columnHeaderTextColor;
  final Color columnAddButtonBoxColor;
  final Color columnAddIconColor;

  const KanbanColumnTheme({
    this.columnBackgroundColor = Colors.white,
    this.columnBorderColor = const Color(0xFFE0E0E0),
    this.columnHeaderColor = Colors.blue,
    this.columnHeaderTextColor = Colors.black87,
    this.columnAddButtonBoxColor = const Color.fromARGB(255, 76, 127, 175),
    this.columnAddIconColor = Colors.white,
  });
}

class ColumnWidget extends StatelessWidget {
  final KanbanColumn column;
  final KanbanColumnTheme theme;
  final Function()? onAddTask;
  final Function(KanbanColumn column, int oldIndex, int newIndex)?
      onReorderedTask;
  final Function(KanbanColumn source, int sourceIndex, KanbanColumn destination,
      int? destinationIndex)? onTaskDropped;
  final Function(int sourceTaskIndex)? onMoveTaskLeftToRight;
  final Function(int sourceTaskIndex)? onMoveTaskRightToLeft;
  final Function()? onClearDone;
  final bool canMoveLeft;
  final bool canMoveRight;

  const ColumnWidget({
    Key? key,
    required this.column,
    required this.theme,
    this.onAddTask,
    this.onReorderedTask,
    this.onTaskDropped,
    this.onMoveTaskLeftToRight,
    this.onMoveTaskRightToLeft,
    this.onClearDone,
    this.canMoveLeft = true,
    this.canMoveRight = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: theme.columnBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: theme.columnBorderColor.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: DragTarget<TaskDragData>(builder: (context, candidateData, rejectedData) { 
              return ListView.builder(
                  itemCount: column.tasks.length,
                  itemBuilder: (context, index) {
                    final task = column.tasks[index];
                    return _buildDragTargetItem(task, index);
                  },
                ); 
              }, onWillAcceptWithDetails: (details) {
                return details.data.sourceColumn != column;
              }, onAcceptWithDetails: (details) {
                if (details.data.sourceColumn == column && details.data.sourceIndex != 0) {
                  onReorderedTask?.call(column, details.data.sourceIndex, 0);
                } else {
                  onTaskDropped?.call(
                    details.data.sourceColumn,
                    details.data.sourceIndex,
                    column,
                    0,
                  );
                }
              })
            ),
          ],
        ));
  }

  Widget _buildDragTargetItem(Task task, int index) {
    return DragTarget<TaskDragData>(builder: (context, candidateData, rejectedData) {
      final effectiveTheme = KanbanThemeProvider.of(context);
      return TaskCard(
          data: TaskDragData(
            task: task,
            sourceColumn: column,
            sourceIndex: index,
          ),
          theme: effectiveTheme.cardTheme,
          onMoveLeft: () {
            if (onMoveTaskRightToLeft != null) {
              onMoveTaskRightToLeft!(index);
            }
          },
          onMoveRight: () {
            if (onMoveTaskLeftToRight != null) {
              onMoveTaskLeftToRight!(index);
            }
          },
          canMoveLeft: canMoveLeft,
          canMoveRight: canMoveRight);
    }, onWillAcceptWithDetails: (details) {
      if (details.data.sourceColumn == column) {
        return true; // this is same colum reorder task, so we will accept it 
      } 
      if (details.data.sourceColumn != column) {
          return true; // this is different column, so we will accept it if target column limit not reached
      }
      // default to false
      return false;
    }, onAcceptWithDetails: (details) {
      if (details.data.sourceColumn == column && details.data.sourceIndex != index) {
        onReorderedTask?.call(column, details.data.sourceIndex, index);
      } else {
        onTaskDropped?.call(
          details.data.sourceColumn,
          details.data.sourceIndex,
          column,
          index,
        );
      }
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 64.0,
      decoration: BoxDecoration(
        color: theme.columnHeaderColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title and count grouped together
          Row(
            children: [
              Text(
                column.header,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: theme.columnHeaderTextColor,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: theme.columnBackgroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  column.columnLimit != null
                      ? '${column.tasks.length}/${column.columnLimit}'
                      : '${column.tasks.length}',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: theme.columnHeaderTextColor,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              if (column.isDoneColumn())
                Container(
                  height: 32.0,
                  width: 32.0,
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.red[400]?.withValues(alpha: 
                      column.tasks.isNotEmpty && onClearDone != null ? 1.0 : 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.clear_all, size: 20.0),
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    tooltip: column.tasks.isEmpty
                        ? 'No tasks to clear'
                        : 'Clear all done tasks',
                    onPressed: (column.tasks.isNotEmpty && onClearDone != null)
                        ? () => _showClearConfirmDialog(context)
                        : null,
                  ),
                ),
              if (column.canAddTask && onAddTask != null)
                Container(
                  height: 32.0,
                  width: 32.0,
                  decoration: BoxDecoration(
                    color: theme.columnAddButtonBoxColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_rounded, size: 20.0),
                    padding: EdgeInsets.zero,
                    color: theme.columnAddIconColor,
                    onPressed: onAddTask != null
                        ? () {
                            onAddTask!();
                          }
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Done Tasks'),
        content: const Text(
          'Are you sure you want to clear all completed tasks? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[400],
            ),
            child: const Text('Clear'),
            onPressed: () {
              onClearDone?.call();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
