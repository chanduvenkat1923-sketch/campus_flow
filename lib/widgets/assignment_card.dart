import 'package:flutter/material.dart';

class AssignmentCard extends StatelessWidget {
  final String title;
  final String subject;
  final String dueDate;

  const AssignmentCard({
    super.key,
    required this.title,
    required this.subject,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.assignment),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subject),
        trailing: Text(
          dueDate,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}