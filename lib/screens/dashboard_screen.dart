import 'package:flutter/material.dart';

import '../widgets/stat_card.dart';
import '../widgets/class_card.dart';
import '../widgets/assignment_card.dart';
import '../services/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String studentName = 'Student';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await StorageService.loadProfile();

    if (!mounted) return;

    setState(() {
      studentName = profile['name'] ?? 'Student';
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmall ? 18 : 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcome(context),

          const SizedBox(height: 28),

          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 1000
                  ? 3
                  : constraints.maxWidth > 600
                      ? 2
                      : 1;

              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.4,
                children: const [
                  StatCard(
                    title: 'Attendance',
                    value: '82%',
                    icon: Icons.check_circle_outline,
                  ),
                  StatCard(
                    title: 'Pending Tasks',
                    value: '3',
                    icon: Icons.assignment_outlined,
                  ),
                  StatCard(
                    title: 'Study Progress',
                    value: '75%',
                    icon: Icons.trending_up,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _classesSection(context),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: _progressSection(context),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _classesSection(context),
                  const SizedBox(height: 20),
                  _progressSection(context),
                ],
              );
            },
          ),

          const SizedBox(height: 30),

          _assignmentsSection(context),
        ],
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning, $studentName 👋',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stay organized, stay focused and make '
                  'the most of your college day.',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer
                        .withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width > 600)
            const Icon(
              Icons.school,
              size: 70,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _classesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Classes",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),

        const ClassCard(
          time: '09:00 AM',
          subject: 'Database Management Systems',
          room: 'Room 204',
          icon: Icons.storage,
        ),

        const SizedBox(height: 10),

        const ClassCard(
          time: '11:00 AM',
          subject: 'Computer Networks',
          room: 'Room 301',
          icon: Icons.lan,
        ),

        const SizedBox(height: 10),

        const ClassCard(
          time: '02:00 PM',
          subject: 'Flutter Development Lab',
          room: 'Lab 2',
          icon: Icons.code,
        ),
      ],
    );
  }

  Widget _progressSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 22),

            const Center(
              child: SizedBox(
                height: 130,
                width: 130,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 12,
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Center(
              child: Text(
                '75% Complete',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Keep going! You are doing great this week.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _assignmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Assignments',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 14),

        const AssignmentCard(
          title: 'Flutter Web Application',
          subject: 'Flutter Lab',
          dueDate: 'Tomorrow',
        ),

        const SizedBox(height: 10),

        const AssignmentCard(
          title: 'SQL Queries Assignment',
          subject: 'DBMS',
          dueDate: 'Friday',
        ),
      ],
    );
  }
}