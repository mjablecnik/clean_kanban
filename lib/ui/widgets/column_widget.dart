import 'package:clean_kanban/clean_kanban.dart';
import 'package:flutter/material.dart';

class ColumnWidget extends StatelessWidget {
  final KanbanColumn column;
  final Color columnBackgroundColor;
  final Color columnBorderColor;
  final Color columnHeaderColor;
  final Color columnHeaderTextColor;
  final Function(String title, String subtitle)? onAddTask;
  final Function(KanbanColumn column, int oldIndex, int newIndex)?
      onReorderedTask;
  final Function(int sourceTaskIndex)? onMoveTaskLeftToRight;
  final Function(int sourceTaskIndex)? onMoveTaskRightToLeft;

  const ColumnWidget({
    Key? key,
    required this.column,
    this.columnBackgroundColor = Colors.white,
    this.columnBorderColor = const Color(0xFFE0E0E0),
    this.columnHeaderColor = Colors.blue,
    this.columnHeaderTextColor = Colors.black87,
    this.onAddTask,
    this.onReorderedTask,
    this.onMoveTaskLeftToRight,
    this.onMoveTaskRightToLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: columnBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: columnBorderColor.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: column.tasks.length,
                itemBuilder: (context, index) {
                  final task = column.tasks[index];
                  return _buildDragTargetItem(task, index);
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildDragTargetItem(Task task, int index) {
    return DragTarget<String>(builder: (context, candidateData, rejectedData) {
      return TaskCard(
          task: task,
          onMoveLeft: () {
            if (onMoveTaskRightToLeft != null) {
              onMoveTaskRightToLeft!(index);
            }
          },
          onMoveRight: () {
            if (onMoveTaskLeftToRight != null) {
              onMoveTaskLeftToRight!(index);
            }
          });
    }, onWillAcceptWithDetails: (details) {
      return onReorderedTask != null;
    }, onAcceptWithDetails: (details) {
      final draggedIndex =
          column.tasks.indexWhere((task) => task.id == details.data);
      if (draggedIndex == -1 && draggedIndex == index) return;
      onReorderedTask?.call(column, draggedIndex, index);
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 64.0,
      decoration: BoxDecoration(
        color: columnHeaderColor,
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
                  color: columnHeaderTextColor,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: columnBackgroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  column.columnLimit != null
                      ? '${column.tasks.length}/${column.columnLimit}'
                      : '${column.tasks.length}',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: columnHeaderTextColor,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (column.canAddTask && onAddTask != null)
            Container(
              height: 32.0,
              width: 32.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.add_rounded, size: 20.0),
                padding: EdgeInsets.zero,
                color: Colors.white,
                onPressed: onAddTask != null
                    ? () {
                        onAddTask!('New Task', 'Description');
                      }
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
