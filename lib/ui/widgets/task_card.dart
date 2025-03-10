import 'package:flutter/material.dart';
import 'package:clean_kanban/domain/entities/task.dart';

class TaskCardTheme {
  final Color cardBackgroundColor;
  final Color cardBorderColor;
  final Color cardTitleColor;
  final Color cardSubtitleColor;
  final Color cardMoveIconEnabledColor;
  final Color cardMoveIconDisabledColor;

  const TaskCardTheme({
    this.cardBackgroundColor = Colors.white,
    this.cardBorderColor = const Color(0xFFE0E0E0),
    this.cardTitleColor = const Color.fromRGBO(0, 0, 0, 0.867),
    this.cardSubtitleColor = const Color.fromRGBO(0, 0, 0, 0.541),
    this.cardMoveIconEnabledColor = const Color.fromRGBO(25, 118, 210, 1),
    this.cardMoveIconDisabledColor = const Color.fromRGBO(224, 224, 224, 1),
  });
}

class TaskCard extends StatelessWidget {
  final Task task;
  final TaskCardTheme theme;
  final VoidCallback? onMoveLeft;
  final VoidCallback? onMoveRight;
  final bool canMoveLeft;
  final bool canMoveRight;

  const TaskCard({
    Key? key,
    required this.task,
    required this.theme,
    this.onMoveLeft,
    this.onMoveRight,
    this.canMoveLeft = true,
    this.canMoveRight = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: task.id,
      feedback: Material(
        elevation: 4.0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: _buildCardContent(isDragging: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildCardContent(isDragging: false),
      ),
      child: _buildCardContent(isDragging: false),
    );
  }

  Widget _buildCardContent({required bool isDragging}) {
    return Card(
      elevation: isDragging ? 0 : 2.0,
      color: theme.cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: theme.cardBorderColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Container(
          decoration: BoxDecoration(
            gradient: isDragging
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.cardBackgroundColor,
                      theme.cardBackgroundColor.withValues(alpha: 0.95),
                    ],
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: theme.cardTitleColor,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            task.subtitle,
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                              color: theme.cardSubtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: theme.cardBorderColor.withValues(alpha: 0.7),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(
                            icon: Icons.chevron_left,
                            onPressed: canMoveLeft ? onMoveLeft : null,
                            tooltip: 'Move to Previous Column',
                            color: canMoveLeft
                                ? theme.cardMoveIconEnabledColor
                                : theme.cardMoveIconDisabledColor,
                          ),
                          Container(
                            height: 1,
                            width: 16,
                            margin: const EdgeInsets.symmetric(vertical: 2.0),
                            color: theme.cardBorderColor.withOpacity(0.7),
                          ),
                          _buildControlButton(
                            icon: Icons.chevron_right,
                            onPressed: canMoveRight ? onMoveRight : null,
                            tooltip: 'Move to Next Column',
                            color: canMoveRight
                                ? theme.cardMoveIconEnabledColor
                                : theme.cardMoveIconDisabledColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onPressed,
    required String tooltip,
    required Color color,
  }) {
    return SizedBox(
      width: 32.0,
      height: 28.0,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 18.0,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
