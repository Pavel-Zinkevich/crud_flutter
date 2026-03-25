import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TaskApp());
}

class Task {
  int id;
  String title;
  Task({required this.id, required this.title});
}

class TaskApp extends StatelessWidget {
  const TaskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskPage(),
    );
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = [];
  int _nextId = 1;

  static const String _kTasksKey = 'tasks';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kTasksKey);
    if (jsonString == null) return;
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      setState(() {
        _tasks = decoded
            .map((e) => Task(id: (e['id'] as int), title: (e['title'] as String)))
            .toList();
        _nextId = _tasks.isEmpty
            ? 1
            : _tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
      });
    } catch (_) {
      // If parsing fails, start with empty list
      setState(() {
        _tasks = [];
        _nextId = 1;
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      _tasks.map((t) => {'id': t.id, 'title': t.title}).toList(),
    );
    await prefs.setString(_kTasksKey, jsonString);
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.add(Task(id: _nextId++, title: text));
      _controller.clear();
    });
    _saveTasks();
  }

  void _deleteTask(int id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
    _saveTasks();
  }

  void _editTask(Task task) async {
    final updated = await showDialog<String>(
      context: context,
      builder: (context) {
        final editController = TextEditingController(text: task.title);
        return AlertDialog(
          title: const Text('Edit task'),
          content: TextField(
            controller: editController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Task title',
            ),
            onSubmitted: (_) {
              Navigator.of(context).pop(editController.text.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(editController.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (updated == null) return; // cancelled
    final newText = updated.trim();
    if (newText.isEmpty) return; // don't allow empty title

    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) _tasks[index] = Task(id: task.id, title: newText);
    });
    _saveTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks CRUD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter a task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('No tasks yet'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          key: ValueKey(task.id),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(task.title),
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editTask(task),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _confirmDelete(task),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) _deleteTask(task.id);
  }
}
