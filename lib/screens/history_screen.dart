import 'package:flutter/material.dart';
import '../models/daily_entry.dart';
import '../services/data_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DataService _dataService = DataService();
  List<DailyEntry> _entries = [];
  String _filter = 'all'; // 'all', 'week', 'month'

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await _dataService.getAllEntries();
    setState(() {
      _entries = entries;
    });
  }

  List<DailyEntry> get _filteredEntries {
    final now = DateTime.now();
    switch (_filter) {
      case 'week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return _entries.where((e) => e.date.isAfter(weekAgo)).toList();
      case 'month':
        final monthAgo = now.subtract(const Duration(days: 30));
        return _entries.where((e) => e.date.isAfter(monthAgo)).toList();
      default:
        return _entries;
    }
  }

  String _getMoodEmoji(String mood) {
    const moodEmojis = {
      'happy': '😊',
      'tired': '😴',
      'stressed': '😰',
      'calm': '😌',
      'sad': '😢',
      'excited': '😃',
      'down': '😔',
      'neutral': '😐',
    };
    return moodEmojis[mood.toLowerCase()] ?? '😐';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEntries;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('All', 'all'),
                _buildFilterButton('Week', 'week'),
                _buildFilterButton('Month', 'month'),
              ],
            ),
          ),
          const Divider(),
          // Entries list
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No entries yet.\nStart tracking your mood!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadEntries,
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final entry = filtered[index];
                        final dateFormat = DateFormat('MMM dd, yyyy');
                        final habitsCount = entry.completedHabits.length;
                        
                        // Load total habits count asynchronously
                        return FutureBuilder<int>(
                          future: _dataService.getHabits().then((h) => h.length),
                          builder: (context, snapshot) {
                            final totalHabits = snapshot.data ?? 0;
                            
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: Text(
                                  _getMoodEmoji(entry.mood),
                                  style: const TextStyle(fontSize: 40),
                                ),
                                title: Text(
                                  dateFormat.format(entry.date),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  '${entry.mood.substring(0, 1).toUpperCase()}${entry.mood.substring(1)} • $habitsCount/$totalHabits habits completed',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isSelected = _filter == value;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _filter = value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}