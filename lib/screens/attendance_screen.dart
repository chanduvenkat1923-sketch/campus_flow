import 'package:flutter/material.dart';
import '../data/attendance_data.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  double calculatePercentage(
    int attended,
    int total,
  ) {
    if (total == 0) return 0;

    return attended / total;
  }

  @override
  Widget build(BuildContext context) {
    int totalAttended = 0;
    int totalClasses = 0;

    for (final subject in AttendanceData.subjects) {
      totalAttended += subject['attended'] as int;
      totalClasses += subject['total'] as int;
    }

    final overall =
        calculatePercentage(
      totalAttended,
      totalClasses,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Attendance',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Track your attendance across all subjects.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(28),

              child: Row(
                children: [
                  SizedBox(
                    width: 125,
                    height: 125,

                    child: Stack(
                      alignment: Alignment.center,

                      children: [
                        CircularProgressIndicator(
                          value: overall,
                          strokeWidth: 12,
                        ),

                        Text(
                          '${(overall * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 28),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Overall Attendance',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '$totalAttended of '
                          '$totalClasses classes attended.',
                        ),

                        const SizedBox(height: 10),

                        Text(
                          overall >= 0.75
                              ? '✓ You are above the 75% requirement.'
                              : '⚠ Your attendance is below 75%.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: overall >= 0.75
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          ...AttendanceData.subjects.map(
            (subject) {
              final attended =
                  subject['attended'] as int;

              final total =
                  subject['total'] as int;

              final percentage =
                  calculatePercentage(
                attended,
                total,
              );

              final low = percentage < 0.75;

              return Card(
                margin:
                    const EdgeInsets.only(bottom: 12),

                child: Padding(
                  padding: const EdgeInsets.all(18),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subject['name'],
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          Text(
                            '${(percentage * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              color: low
                                  ? Colors.red
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      LinearProgressIndicator(
                        value: percentage,
                        minHeight: 8,
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Text(
                            '$attended / $total classes',
                            style: TextStyle(
                              color:
                                  Colors.grey.shade600,
                            ),
                          ),

                          const Spacer(),

                          if (low)
                            const Text(
                              'Low Attendance',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}