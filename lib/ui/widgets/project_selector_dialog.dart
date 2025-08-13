import 'package:flutter/material.dart';

import '../../domain/repositories/toggl_repository.dart';

/// Shows a dialog with a scrollable list of projects.
/// Returns the selected project when a project is clicked, or null if the dialog is dismissed.
Future<Project?> showProjectSelectorDialog(
  BuildContext context,
  List<Project> projects,
) async {
  return showDialog<Project>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select project'),
        content: SizedBox(
          width: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: projects.length,
            itemBuilder: (BuildContext context, int index) {
              final project = projects[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: project.color.hexToColor(),
                  radius: 12,
                ),
                title: Text(project.name),
                onTap: () {
                  Navigator.of(context).pop(project);
                },
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}