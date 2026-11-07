import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String assignmentsKey = 'assignments';
  static const String goalsKey = 'goals';
  static const String profileKey = 'profile';

  static Future<void> saveAssignments(
    List<Map<String, dynamic>> assignments,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      assignmentsKey,
      jsonEncode(assignments),
    );
  }

  static Future<List<Map<String, dynamic>>> loadAssignments() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(assignmentsKey);

    if (data == null) {
      return [];
    }

    final decoded = jsonDecode(data);

    return List<Map<String, dynamic>>.from(
      decoded.map(
        (item) => Map<String, dynamic>.from(item),
      ),
    );
  }

  static Future<void> saveGoals(
    List<Map<String, dynamic>> goals,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      goalsKey,
      jsonEncode(goals),
    );
  }

  static Future<List<Map<String, dynamic>>> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(goalsKey);

    if (data == null) {
      return [];
    }

    final decoded = jsonDecode(data);

    return List<Map<String, dynamic>>.from(
      decoded.map(
        (item) => Map<String, dynamic>.from(item),
      ),
    );
  }

  static Future<void> saveProfile(
    Map<String, String> profile,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      profileKey,
      jsonEncode(profile),
    );
  }

  static Future<Map<String, String>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(profileKey);

    if (data == null) {
      return {};
    }

    final decoded = jsonDecode(data);

    return Map<String, String>.from(decoded);
  }
}