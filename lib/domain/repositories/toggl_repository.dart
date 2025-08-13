import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

/// Repository for interacting with the Toggl API.
/// Provides functionality to start and stop time tracking.
class TogglRepository {
  final Dio _dio;
  final String _apiToken;
  final String _baseUrl = 'https://api.track.toggl.com/api/v9';

  int? _currentTimeEntryId;
  int? _workspaceId;

  /// Creates a new instance of [TogglRepository].
  ///
  /// [apiToken] is the Toggl API token for authentication.
  /// [dio] is an optional Dio instance. If not provided, a new instance will be created.
  /// [workspaceId] is an optional workspace ID. If not provided, the default workspace will be used.
  TogglRepository({
    String? apiToken,
    Dio? dio,
    int? workspaceId,
  })  : _apiToken = apiToken ?? TaskConfig.togglApiToken,
        _dio = dio ?? Dio(),
        _workspaceId = workspaceId {
    // Configure Dio with base options
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers['Authorization'] = 'Basic ${_getEncodedApiToken()}';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  /// Encodes the API token for Basic Authentication.
  String _getEncodedApiToken() {
    final credentials = '$_apiToken:api_token';
    return base64Encode(utf8.encode(credentials));
  }

  /// Fetches the user's default workspace ID if not provided during initialization.
  Future<int> _getWorkspaceId() async {
    if (_workspaceId != null) {
      return _workspaceId!;
    }

    try {
      final response = await _dio.get('/me');
      final userData = response.data;
      _workspaceId = userData['default_workspace_id'];

      if (_workspaceId == null) {
        throw Exception('No default workspace found');
      }

      return _workspaceId!;
    } catch (e) {
      throw Exception('Failed to get workspace ID: ${e.toString()}');
    }
  }

  /// Starts a new time entry.
  ///
  /// [description] is the description of the time entry.
  /// [projectId] is an optional project ID to associate with the time entry.
  /// [tags] is an optional list of tags to associate with the time entry.
  ///
  /// Returns the ID of the created time entry.
  Future<int> startTimeEntry({
    required String description,
    int? projectId,
    List<String>? tags,
  }) async {
    final workspaceId = await _getWorkspaceId();

    final data = {
      'description': description,
      'created_with': 'Clean Kanban App',
      'start': DateTime.now().toUtc().toIso8601String(),
      'duration': -1,
      'workspace_id': workspaceId,
      if (projectId != null) 'project_id': projectId,
      if (tags != null && tags.isNotEmpty) 'tags': tags,
    };

    try {
      final response = await _dio.post(
        '/workspaces/$workspaceId/time_entries',
        data: data,
      );

      final timeEntryData = response.data;
      _currentTimeEntryId = timeEntryData['id'];

      return _currentTimeEntryId!;
    } catch (e) {
      throw Exception('Failed to start time entry: ${e.toString()}');
    }
  }

  /// Stops the current time entry.
  ///
  /// [timeEntryId] is an optional time entry ID to stop. If not provided, the last started time entry will be stopped.
  ///
  /// Returns the stopped time entry data.
  Future<Map<String, dynamic>> stopTimeEntry({int? timeEntryId}) async {
    final entryId = timeEntryId ?? _currentTimeEntryId;

    if (entryId == null) {
      throw Exception('No time entry to stop');
    }

    final workspaceId = await _getWorkspaceId();

    try {
      final response = await _dio.patch(
        '/workspaces/$workspaceId/time_entries/$entryId/stop',
        data: {
          'stop': DateTime.now().toUtc().toIso8601String(),
        },
      );

      if (entryId == _currentTimeEntryId) {
        _currentTimeEntryId = null;
      }

      return response.data;
    } catch (e) {
      throw Exception('Failed to stop time entry: ${e.toString()}');
    }
  }

  /// Gets the current running time entry, if any.
  ///
  /// Returns the current time entry data or null if no time entry is running.
  Future<Map<String, dynamic>?> getCurrentTimeEntry() async {
    final workspaceId = await _getWorkspaceId();

    try {
      final response = await _dio.get('/workspaces/$workspaceId/time_entries/current');

      if (response.data == null) {
        return null;
      }

      _currentTimeEntryId = response.data['id'];
      return response.data;
    } catch (e) {
      throw Exception('Failed to get current time entry: ${e.toString()}');
    }
  }

  /// Gets a list of recent time entries.
  ///
  /// [limit] is the maximum number of time entries to return.
  ///
  /// Returns a list of time entry data.
  Future<List<Map<String, dynamic>>> getRecentTimeEntries({int limit = 10}) async {
    final workspaceId = await _getWorkspaceId();

    try {
      final response = await _dio.get(
        '/workspaces/$workspaceId/time_entries',
        queryParameters: {
          'limit': limit,
        },
      );

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Failed to get recent time entries: ${e.toString()}');
    }
  }

  /// Gets a list of projects for the workspace.
  ///
  /// Returns a list of project data.
  Future<List<Project>> getProjects() async {
    final workspaceId = await _getWorkspaceId();

    try {
      final response = await _dio.get('/workspaces/$workspaceId/projects');

      final list = List<Map<String, dynamic>>.from(response.data);
      return list.map((e) => Project.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to get projects: ${e.toString()}');
    }
  }

  /// Gets a list of tags for the workspace.
  ///
  /// Returns a list of tag data.
  Future<List<Map<String, dynamic>>> getTags() async {
    final workspaceId = await _getWorkspaceId();

    try {
      final response = await _dio.get('/workspaces/$workspaceId/tags');

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Failed to get tags: ${e.toString()}');
    }
  }
}

class Project {
  final int id;
  final String name;
  final bool isActive;
  final String color;

  Project({
    required this.id,
    required this.name,
    required this.isActive,
    required this.color,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      name: json['name'] as String,
      isActive: json['active'] as bool,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'active': isActive,
      'color': color,
    };
  }

  @override
  String toString() {
    return 'Project{id: $id, name: $name, isActive: $isActive, color: $color}';
  }
}


extension StringExt on String {
  Color? hexToColor() {
    return Color(int.parse(this.substring(1), radix: 16) + 0xFF000000);
  }
}

extension ColorExt on Color {
  String colorToHex() {
    return '#${this.value.toRadixString(16).substring(2)}';
  }
}

