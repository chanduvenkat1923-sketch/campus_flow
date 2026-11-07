import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Map<String, dynamic>> goals = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGoals();
  }

  Future<void> loadGoals() async {
    final saved = await StorageService.loadGoals();

    if (saved.isEmpty) {
      goals = [
        {
          'title': 'Complete DBMS revision',
          'done': true,
        },
        {
          'title': 'Practice 5 DSA problems',
          'done': false,
        },
        {
          'title': 'Study Flutter for 1 hour',
          'done': false,
        },
        {
          'title': 'Revise Computer Networks',
          'done': true,
        },
      ];

      await StorageService.saveGoals(goals);
    } else {
      goals = saved;
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveData() async {
    await StorageService.saveGoals(goals);
  }

  Future<void> addGoal() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Goal'),

          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Goal',
              prefixIcon: Icon(Icons.flag_outlined),
              border: OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  goals.add({
                    'title': controller.text.trim(),
                    'done': false,
                  });
                });

                await saveData();

                if (!mounted || !dialogContext.mounted) return;

                Navigator.pop(dialogContext);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> deleteGoal(int index) async {
    setState(() {
      goals.removeAt(index);
    });

    await saveData();
  }

  Future<void> toggleGoal(
    int index,
    bool value,
  ) async {
    setState(() {
      goals[index]['done'] = value;
    });

    await saveData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final completed =
        goals.where((goal) => goal['done'] == true).length;

    final progress =
        goals.isEmpty ? 0.0 : completed / goals.length;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Daily Goals',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              FilledButton.icon(
                onPressed: addGoal,
                icon: const Icon(Icons.add),
                label: const Text('Add Goal'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          '$completed of ${goals.length} goals completed',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${(progress * 100).toStringAsFixed(0)}% complete',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: goals.isEmpty
                ? _emptyState()
                : ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: CheckboxListTile(
                          value: goals[index]['done'],
                          onChanged: (value) {
                            toggleGoal(
                              index,
                              value ?? false,
                            );
                          },
                          title: Text(
                            goals[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration:
                                  goals[index]['done']
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                          ),
                          secondary: IconButton(
                            tooltip: 'Delete',
                            onPressed: () {
                              deleteGoal(index);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 70,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),

          const SizedBox(height: 16),

          const Text(
            'No goals yet',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Add your first goal and start making progress.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}