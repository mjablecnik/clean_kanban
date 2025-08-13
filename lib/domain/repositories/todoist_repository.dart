import 'dart:convert';

import 'package:clean_kanban/config.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:dio/dio.dart';
import 'dart:io' show Platform;

import 'package:clean_kanban/domain/entities/project.dart';

/// Custom exceptions for Todoist API
class TodoistApiException implements Exception {
  final String message;
  final int? statusCode;

  TodoistApiException(this.message, {this.statusCode});

  @override
  String toString() => 'TodoistApiException: $message ${statusCode != null ? '(Status: $statusCode)' : ''}';
}

class TodoistNetworkException extends TodoistApiException {
  TodoistNetworkException(String message) : super('Network error: $message');
}

class TodoistAuthException extends TodoistApiException {
  TodoistAuthException() : super('Authentication failed. Check your API token.', statusCode: 401);
}

/// Repository for interacting with the Todoist API
class TodoistRepository {
  final Dio _dio;
  final String _apiToken;
  final String _baseUrl = 'https://api.todoist.com/rest/v2';

  /// Constructor for TodoistRepository
  TodoistRepository({
    String? apiToken,
    Dio? dio,
  })  : _apiToken = apiToken ?? TaskConfig.todoistApiToken,
        _dio = dio ?? Dio() {
    // Configure Dio with default headers for authentication
    _dio.options.headers['Authorization'] = 'Bearer $_apiToken';
  }

  /// Get API token from environment variables
  static String _getApiTokenFromEnv() {
    final token = Platform.environment['TODOIST_API_TOKEN'];
    if (token == null || token.isEmpty) {
      throw TodoistApiException('Todoist API token not found. Set TODOIST_API_TOKEN environment variable.');
    }
    return token;
  }

  /// Create a new task in Todoist (handles both tasks and subtasks)
  Future<Task> createTask(Task task) async {
    try {
      final data = {
        'content': task.title,
        if (task.subtitle.isNotEmpty) 'description': task.subtitle,
        // Assuming you might want to link to a project ID if available in your Task model
        // if (task.projectId != null) 'project_id': task.projectId,
        // Assuming you might want to link to a parent task ID if available in your Task model
        // if (task.parentId != null) 'parent_id': task.parentId,
        if (task.deadline != null) 'due_date': task.deadline!.toIso8601String().split('T')[0],
        'priority': task.priority,
      };
      final response = await _dio.post('$_baseUrl/tasks', data: data);

      final responseTask = Task(
        id: "${response.data['id']}",
        title: response.data['content'],
        subtitle: response.data['description'] ?? '',
        deadline: response.data['due'] != null ? DateTime.parse(response.data['due']['date']) : null,
        solved: response.data['completed'] ?? false,
        created: DateTime.now(),
        priority: response.data['priority'] ?? 1,
      );
      return responseTask;
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Complete a task in Todoist
  Future<bool> completeTask(String taskId, bool completed) async {
    if (completed) {
      await _dio.post('$_baseUrl/tasks/$taskId/close');
    } else {
      await _dio.post('$_baseUrl/tasks/$taskId/reopen');
    }
    return true;
  }

  /// Update an existing task in Todoist
  Future<Task> updateTask(Task task) async {
    try {
      final data = {
        'content': task.title,
        if (task.subtitle.isNotEmpty) 'description': task.subtitle,
      };
      final response = await _dio.post('$_baseUrl/tasks/${task.id}', data: data);

      // Convert Todoist task to our Task model
      return Task(
        id: response.data['id'],
        title: response.data['content'],
        subtitle: response.data['description'] ?? '',
        deadline: response.data['due'] != null ? DateTime.parse(response.data['due']['date']) : null,
        solved: response.data['completed'] ?? false,
        priority: response.data['priority'] ?? 1,
        created: DateTime.now(), // We don't get creation date from API
      );
    } catch (e) {
      print(e);
      throw _handleApiError(e);
    }
  }

  /// Delete a task from Todoist
  Future<bool> deleteTask(String taskId) async {
    try {
      await _dio.delete('$_baseUrl/tasks/$taskId');
      return true;
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// List all tasks from Todoist
  Future<List<Task>> listAllTasks() async {
    try {
      final response = await _dio.get('$_baseUrl/tasks');

      final List<dynamic> tasksData = response.data;
      return tasksData
          .map((taskData) => Task(
                id: taskData['id'],
                title: taskData['content'],
                subtitle: taskData['description'] ?? '',
                deadline: taskData['due'] != null ? DateTime.parse(taskData['due']['date']) : null,
                solved: taskData['completed'] ?? false,
                priority: taskData['priority'] ?? 1,
                created: DateTime.now(), // We don't get creation date from API
              ))
          .toList();
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// List all projects from Todoist
  Future<List<Project>> listAllProjects() async {
    try {
      final response = await _dio.get('$_baseUrl/projects');

      final List<dynamic> projectsData = response.data;
      return projectsData
          .map((projectData) => Project(
                id: projectData['id'],
                name: projectData['name'],
                created: DateTime.now(), // We don't get creation date from API
              ))
          .toList();
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Get tasks for a specific project
  Future<List<Task>> getTasksByProject(String projectId) async {
    try {
      final response = await _dio.get('$_baseUrl/tasks', queryParameters: {
        'project_id': projectId,
      });

      final List<dynamic> tasksData = response.data;
      return tasksData
          .map((taskData) => Task(
                id: taskData['id'],
                title: taskData['content'],
                subtitle: taskData['description'] ?? '',
                deadline: taskData['due'] != null ? DateTime.parse(taskData['due']['date']) : null,
                solved: taskData['completed'] ?? false,
                priority: taskData['priority'] ?? 1,
                created: DateTime.now(),
              ))
          .toList();
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Handle errors from the Todoist API
  Exception _handleApiError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        final data = error.response!.data;

        switch (statusCode) {
          case 401:
            return TodoistAuthException();
          case 404:
            return TodoistApiException('Resource not found', statusCode: 404);
          case 400:
            return TodoistApiException('Bad request: ${data ?? 'Unknown error'}', statusCode: 400);
          default:
            return TodoistApiException('API error: ${data ?? 'Unknown error'}', statusCode: statusCode);
        }
      }
      return TodoistNetworkException(error.message ?? 'Unknown network error');
    }
    return TodoistApiException('Unexpected error: $error');
  }
}
