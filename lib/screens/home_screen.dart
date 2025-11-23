import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/daily_entry.dart';
import '../services/data_service.dart';
import 'package:intl/intl.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataService _dataService = DataService();
  
  String? _selectedMood;
  List<Habit> _habits = [];
  Set<String> _completedHabitIds = {};
  DailyEntry? _todayEntry;
  bool _isLoading = true;

  // Available moods with emojis and colors
  final List<Map<String, dynamic>> _moods = [
    {'name': 'happy', 'emoji': '😊', 'color': Colors.amber},
    {'name': 'tired', 'emoji': '😴', 'color': Colors.indigo},
    {'name': 'stressed', 'emoji': '😰', 'color': Colors.red},
    {'name': 'calm', 'emoji': '😌', 'color': Colors.green},
    {'name': 'sad', 'emoji': '😢', 'color': Colors.blue},
    {'name': 'excited', 'emoji': '😃', 'color': Colors.orange},
    {'name': 'down', 'emoji': '😔', 'color': Colors.grey},
    {'name': 'neutral', 'emoji': '😐', 'color': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load habits
      final habits = await _dataService.getHabits();
      
      // Initialize with default habits if none exist
      if (habits.isEmpty) {
        await _initializeDefaultHabits();
        // Reload habits after initialization
        final updatedHabits = await _dataService.getHabits();
        setState(() {
          _habits = updatedHabits;
        });
      } else {
        setState(() {
          _habits = habits;
        });
      }
      
      // Load today's entry if it exists
      final today = DateTime.now();
      final todayKey = DateFormat('yyyy-MM-dd').format(today);
      final entry = await _dataService.getEntry(todayKey);
      
      setState(() {
        if (entry != null) {
          _todayEntry = entry;
          _selectedMood = entry.mood;
          _completedHabitIds = entry.completedHabits.toSet();
        } else {
          _selectedMood = null;
          _completedHabitIds = {};
        }
      });
    } catch (e) {
      // Handle errors gracefully
      print('Error loading data: $e');
      // Set empty state to prevent white screen
      setState(() {
        _habits = [];
        _selectedMood = null;
        _completedHabitIds = {};
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeDefaultHabits() async {
    final defaultHabits = [
      Habit(id: '1', name: 'Drank water'),
      Habit(id: '2', name: 'Studied'),
      Habit(id: '3', name: 'Exercised'),
      Habit(id: '4', name: 'Slept early'),
    ];
    
    for (var habit in defaultHabits) {
      await _dataService.addHabit(habit);
    }
  }

  void _selectMood(String mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  void _toggleHabit(String habitId) {
    setState(() {
      if (_completedHabitIds.contains(habitId)) {
        _completedHabitIds.remove(habitId);
      } else {
        _completedHabitIds.add(habitId);
      }
    });
  }

  Future<void> _saveToday() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a mood first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final today = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(today);
    
    final entry = DailyEntry(
      date: today,
      mood: _selectedMood!,
      completedHabits: _completedHabitIds.toList(),
    );

    await _dataService.saveEntry(todayKey, entry);
    
    setState(() {
      _todayEntry = entry;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved successfully! ✓'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');
    
    // Show loading indicator while data is loading
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Daily Mood & Habit Tracker'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Mood & Habit Tracker'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              ).then((_) => _loadData());
            },
            tooltip: 'History',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ).then((_) => _loadData());
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's date
            Center(
              child: Text(
                dateFormat.format(today),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Mood selector section
            const Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Mood emoji row
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood['name'];
                return GestureDetector(
                  onTap: () => _selectMood(mood['name']!),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        mood['emoji']!,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            
            // Habits section
            const Text(
              'Today\'s Habits',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Habits list
            _habits.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No habits yet.\nGo to Settings to add habits!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : Column(
                    children: _habits.map((habit) {
                      final isCompleted = _completedHabitIds.contains(habit.id);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: CheckboxListTile(
                          title: Text(
                            habit.name,
                            style: TextStyle(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: isCompleted ? Colors.grey : Colors.black,
                            ),
                          ),
                          value: isCompleted,
                          onChanged: (value) => _toggleHabit(habit.id),
                          activeColor: Colors.blueAccent,
                        ),
                      );
                    }).toList(),
                  ),
            
            const SizedBox(height: 30),
            
            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveToday,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Show saved status if entry exists
            if (_todayEntry != null)
              Center(
                child: Text(
                  '✓ Entry saved for today',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}