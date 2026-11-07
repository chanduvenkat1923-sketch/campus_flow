import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() =>
      _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  List<Map<String, dynamic>> assignments = [];

  String searchText = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    final saved = await StorageService.loadAssignments();

    if (saved.isEmpty) {
      assignments = [
        {
          'title': 'Flutter Web Application',
          'subject': 'Flutter Lab',
          'due': 'Tomorrow',
          'completed': false,
        },
        {
          'title': 'SQL Queries',
          'subject': 'DBMS',
          'due': 'Friday',
          'completed': false,
        },
        {
          'title': 'Routing Algorithms',
          'subject': 'Computer Networks',
          'due': 'Monday',
          'completed': true,
        },
      ];

      await StorageService.saveAssignments(assignments);
    } else {
      assignments = saved;
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveData() async {
    await StorageService.saveAssignments(assignments);
  }

  Future<void> addAssignment() async {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();

    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Add Assignment'),

              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Assignment title',
                        prefixIcon:
                            Icon(Icons.assignment_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        prefixIcon:
                            Icon(Icons.book_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: dialogContext,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          initialDate: DateTime.now(),
                        );

                        if (date != null) {
                          setDialogState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        selectedDate == null
                            ? 'Select due date'
                            : '${selectedDate!.day}/'
                                '${selectedDate!.month}/'
                                '${selectedDate!.year}',
                      ),
                    ),
                  ],
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
                    if (titleController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      assignments.add({
                        'title': titleController.text.trim(),
                        'subject':
                            subjectController.text.trim().isEmpty
                                ? 'General'
                                : subjectController.text.trim(),
                        'due': selectedDate == null
                            ? 'No date'
                            : '${selectedDate!.day}/'
                                '${selectedDate!.month}/'
                                '${selectedDate!.year}',
                        'completed': false,
                      });
                    });

                    await saveData();

                    if (!mounted || !dialogContext.mounted) return;

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Add Assignment'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    subjectController.dispose();
  }

  Future<void> deleteAssignment(int index) async {
    setState(() {
      assignments.removeAt(index);
    });

    await saveData();
  }

  Future<void> toggleAssignment(
    int index,
    bool value,
  ) async {
    setState(() {
      assignments[index]['completed'] = value;
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

    final filteredAssignments = assignments.where((assignment) {
      final title =
          assignment['title'].toString().toLowerCase();

      final subject =
          assignment['subject'].toString().toLowerCase();

      final query = searchText.toLowerCase();

      return title.contains(query) ||
          subject.contains(query);
    }).toList();

    final pending = assignments
        .where(
          (assignment) =>
              assignment['completed'] == false,
        )
        .length;

    final completed = assignments
        .where(
          (assignment) =>
              assignment['completed'] == true,
        )
        .length;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Assignments',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              FilledButton.icon(
                onPressed: addAssignment,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            '$pending pending • $completed completed',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search assignments or subjects...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: filteredAssignments.isEmpty
                ? _emptyState()
                : ListView.builder(
                    itemCount: filteredAssignments.length,
                    itemBuilder: (context, index) {
                      final assignment =
                          filteredAssignments[index];

                      final originalIndex =
                          assignments.indexOf(assignment);

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: CheckboxListTile(
                          value: assignment['completed'],
                          onChanged: (value) {
                            toggleAssignment(
                              originalIndex,
                              value ?? false,
                            );
                          },
                          title: Text(
                            assignment['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration:
                                  assignment['completed']
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                          ),
                          subtitle: Text(
                            '${assignment['subject']} • '
                            'Due ${assignment['due']}',
                          ),
                          secondary: IconButton(
                            tooltip: 'Delete',
                            onPressed: () {
                              deleteAssignment(originalIndex);
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
    final hasSearch = searchText.trim().isNotEmpty;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasSearch
                ? Icons.search_off
                : Icons.assignment_outlined,
            size: 70,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),

          const SizedBox(height: 16),

          Text(
            hasSearch
                ? 'No assignments found'
                : 'No assignments yet',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            hasSearch
                ? 'Try a different search term.'
                : 'Add an assignment to get started.',
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