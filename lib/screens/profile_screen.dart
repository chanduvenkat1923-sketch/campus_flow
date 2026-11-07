import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Student';
  String department = 'Computer Science Engineering';
  String studentId = 'Student ID';
  String year = '2026–2027';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile = await StorageService.loadProfile();

    if (!mounted) return;

    if (profile.isNotEmpty) {
      setState(() {
        name = profile['name'] ?? name;
        department = profile['department'] ?? department;
        studentId = profile['studentId'] ?? studentId;
        year = profile['year'] ?? year;
      });
    }
  }

  Future<void> editProfile() async {
    final nameController =
        TextEditingController(text: name);

    final departmentController =
        TextEditingController(text: department);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),

          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
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
                final newName =
                    nameController.text.trim().isEmpty
                        ? 'Student'
                        : nameController.text.trim();

                final newDepartment =
                    departmentController.text.trim().isEmpty
                        ? department
                        : departmentController.text.trim();

                setState(() {
                  name = newName;
                  department = newDepartment;
                });

                await StorageService.saveProfile({
                  'name': name,
                  'department': department,
                  'studentId': studentId,
                  'year': year,
                });

                if (!mounted || !dialogContext.mounted) return;

                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    departmentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const SizedBox(height: 20),

          CircleAvatar(
            radius: 55,
            backgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 55,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            department,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 18),

          OutlinedButton.icon(
            onPressed: editProfile,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),

          const SizedBox(height: 30),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Student ID'),
                  subtitle: Text(studentId),
                ),

                const Divider(height: 1),

                ListTile(
                  leading:
                      const Icon(Icons.school_outlined),
                  title: const Text('Department'),
                  subtitle: Text(department),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(
                    Icons.calendar_today_outlined,
                  ),
                  title: const Text('Academic Year'),
                  subtitle: Text(year),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'CampusFlow',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'A smart academic companion designed to help '
            'students organize their college activities.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}