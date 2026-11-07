import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() =>
      _TimetableScreenState();
}

class _TimetableScreenState
    extends State<TimetableScreen> {

  int selectedDay = 0;

  final days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  final classes = [
    [
      ['09:00 AM', 'Database Management Systems', 'Room 204'],
      ['11:00 AM', 'Computer Networks', 'Room 301'],
      ['02:00 PM', 'Flutter Development Lab', 'Lab 2'],
    ],
    [
      ['09:00 AM', 'Operating Systems', 'Room 205'],
      ['11:00 AM', 'Software Engineering', 'Room 302'],
      ['02:00 PM', 'Data Structures', 'Lab 1'],
    ],
    [
      ['10:00 AM', 'Artificial Intelligence', 'Room 201'],
      ['12:00 PM', 'DBMS Lab', 'Lab 3'],
    ],
    [
      ['09:00 AM', 'Computer Networks', 'Room 301'],
      ['11:00 AM', 'Operating Systems', 'Room 205'],
    ],
    [
      ['10:00 AM', 'Flutter Development', 'Lab 2'],
      ['01:00 PM', 'Software Engineering', 'Room 302'],
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final selectedClasses =
        classes[selectedDay];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Weekly Timetable',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Select a day to view your classes.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 22),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: List.generate(
                days.length,
                (index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 8),

                    child: ChoiceChip(
                      label: Text(days[index]),
                      selected:
                          selectedDay == index,

                      onSelected: (_) {
                        setState(() {
                          selectedDay = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 25),

          if (selectedClasses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Text(
                  'No classes scheduled.',
                ),
              ),
            )
          else
            ...selectedClasses.map(
              (item) => Card(
                margin:
                    const EdgeInsets.only(bottom: 12),

                child: ListTile(
                  contentPadding:
                      const EdgeInsets.all(18),

                  leading: CircleAvatar(
                    child: Text(
                      item[0].substring(0, 2),
                    ),
                  ),

                  title: Text(
                    item[1],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Padding(
                    padding:
                        const EdgeInsets.only(top: 5),

                    child: Text(
                      '${item[0]}  •  ${item[2]}',
                    ),
                  ),

                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}