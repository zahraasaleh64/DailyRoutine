import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/daily_entry.dart';
import '../models/habit.dart';

class DataService {
  static const String _entriesKey = 'daily_entries';
  static const String _habitsKey = 'habits';

  // ========== Daily Entries Methods ==========

  /// Save a daily entry for a specific date
  Future<void> saveEntry(String dateKey, DailyEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get all existing entries
    final entriesJson = prefs.getString(_entriesKey);
    Map<String, dynamic> entries = {};
    
    if (entriesJson != null) {
      entries = json.decode(entriesJson) as Map<String, dynamic>;
    }
    
    // Add or update the entry for this date
    entries[dateKey] = entry.toJson();
    
    // Save back to SharedPreferences
    await prefs.setString(_entriesKey, json.encode(entries));
  }

  /// Get a specific entry by date key (format: "yyyy-MM-dd")
  Future<DailyEntry?> getEntry(String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_entriesKey);
    
    if (entriesJson == null) return null;
    
    final entries = json.decode(entriesJson) as Map<String, dynamic>;
    final entryJson = entries[dateKey];
    
    if (entryJson == null) return null;
    
    return DailyEntry.fromJson(entryJson as Map<String, dynamic>);
  }

  /// Get all entries sorted by date (newest first)
  Future<List<DailyEntry>> getAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_entriesKey);
    
    if (entriesJson == null) return [];
    
    final entries = json.decode(entriesJson) as Map<String, dynamic>;
    final List<DailyEntry> entryList = [];
    
    entries.forEach((dateKey, entryJson) {
      try {
        final entry = DailyEntry.fromJson(entryJson as Map<String, dynamic>);
        entryList.add(entry);
      } catch (e) {
        print('Error parsing entry for $dateKey: $e');
      }
    });
    
    // Sort by date (newest first)
    entryList.sort((a, b) => b.date.compareTo(a.date));
    
    return entryList;
  }

  /// Delete a specific entry by date key
  Future<void> deleteEntry(String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_entriesKey);
    
    if (entriesJson == null) return;
    
    final entries = json.decode(entriesJson) as Map<String, dynamic>;
    entries.remove(dateKey);
    
    await prefs.setString(_entriesKey, json.encode(entries));
  }

  // ========== Habits Methods ==========

  /// Get all habits
  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString(_habitsKey);
    
    if (habitsJson == null) return [];
    
    final List<dynamic> habitsList = json.decode(habitsJson);
    return habitsList.map((json) => Habit.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Add a new habit
  Future<void> addHabit(Habit habit) async {
    final habits = await getHabits();
    habits.add(habit);
    await _saveHabits(habits);
  }

  /// Update an existing habit
  Future<void> updateHabit(Habit updatedHabit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == updatedHabit.id);
    
    if (index != -1) {
      habits[index] = updatedHabit;
      await _saveHabits(habits);
    }
  }

  /// Delete a habit by ID
  Future<void> deleteHabit(String habitId) async {
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == habitId);
    await _saveHabits(habits);
  }

  /// Get a habit by ID
  Future<Habit?> getHabitById(String habitId) async {
    final habits = await getHabits();
    try {
      return habits.firstWhere((h) => h.id == habitId);
    } catch (e) {
      return null;
    }
  }

  /// Private helper method to save habits list
  Future<void> _saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = json.encode(
      habits.map((h) => h.toJson()).toList(),
    );
    await prefs.setString(_habitsKey, habitsJson);
  }

  // ========== Utility Methods ==========

  /// Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_entriesKey);
    await prefs.remove(_habitsKey);
  }
}