import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/assignments_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const CampusFlowApp());
}

class CampusFlowApp extends StatefulWidget {
  const CampusFlowApp({super.key});

  @override
  State<CampusFlowApp> createState() => _CampusFlowAppState();
}

class _CampusFlowAppState extends State<CampusFlowApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusFlow',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3157D5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F8CFF),
          brightness: Brightness.dark,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),

      home: CampusFlowHome(
        isDarkMode: isDarkMode,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

class CampusFlowHome extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const CampusFlowHome({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<CampusFlowHome> createState() => _CampusFlowHomeState();
}

class _CampusFlowHomeState extends State<CampusFlowHome> {
  int selectedIndex = 0;

  int pendingAssignments = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    TimetableScreen(),
    AssignmentsScreen(),
    AttendanceScreen(),
    GoalsScreen(),
    ProfileScreen(),
  ];

  final List<String> titles = [
    'Dashboard',
    'Timetable',
    'Assignments',
    'Attendance',
    'Goals',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _loadNotificationCount();
  }

  Future<void> _loadNotificationCount() async {
    final assignments = await StorageService.loadAssignments();

    if (!mounted) return;

    setState(() {
      pendingAssignments = assignments
          .where((assignment) => assignment['completed'] != true)
          .length;
    });
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          themeMode:
              widget.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          onThemeChanged: (mode) {
            final shouldBeDark = mode == ThemeMode.dark;

            if (shouldBeDark != widget.isDarkMode) {
              widget.onThemeChanged();
            }
          },
        ),
      ),
    );

    await _loadNotificationCount();
  }

  void _selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });

    _loadNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Text(
                titles[selectedIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                _notificationButton(),
                IconButton(
                  tooltip: 'Settings',
                  onPressed: _openSettings,
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            )
          : null,

      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: _selectPage,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month),
                  label: 'Schedule',
                ),
                NavigationDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment),
                  label: 'Tasks',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: 'Stats',
                ),
                NavigationDestination(
                  icon: Icon(Icons.flag_outlined),
                  selectedIcon: Icon(Icons.flag),
                  label: 'Goals',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,

      body: isMobile
          ? pages[selectedIndex]
          : Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: _selectPage,
                  labelType: NavigationRailLabelType.all,

                  leading: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: const Color(0xFF3157D5),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'CampusFlow',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(Icons.calendar_month),
                      label: Text('Timetable'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.assignment_outlined),
                      selectedIcon: Icon(Icons.assignment),
                      label: Text('Assignments'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bar_chart_outlined),
                      selectedIcon: Icon(Icons.bar_chart),
                      label: Text('Attendance'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.flag_outlined),
                      selectedIcon: Icon(Icons.flag),
                      label: Text('Goals'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),

                const VerticalDivider(width: 1),

                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface,
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              titles[selectedIndex],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Spacer(),

                            IconButton(
                              tooltip: 'Toggle theme',
                              onPressed: widget.onThemeChanged,
                              icon: Icon(
                                widget.isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                              ),
                            ),

                            _notificationButton(),

                            IconButton(
                              tooltip: 'Settings',
                              onPressed: _openSettings,
                              icon: const Icon(
                                Icons.settings_outlined,
                              ),
                            ),

                            const SizedBox(width: 10),

                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: pages[selectedIndex],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _notificationButton() {
    return IconButton(
      tooltip: 'Notifications',
      onPressed: () {
        showNotifications(
          context,
          pendingAssignments,
        );
      },
      icon: Badge(
        isLabelVisible: pendingAssignments > 0,
        label: Text(
          pendingAssignments.toString(),
        ),
        child: const Icon(
          Icons.notifications_outlined,
        ),
      ),
    );
  }
}

void showNotifications(
  BuildContext context,
  int pendingAssignments,
) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (pendingAssignments > 0)
              ListTile(
                leading: const Icon(
                  Icons.assignment_outlined,
                ),
                title: Text(
                  '$pendingAssignments pending assignment'
                  '${pendingAssignments == 1 ? '' : 's'}',
                ),
                subtitle: const Text(
                  'Check your assignments and complete '
                  'upcoming tasks.',
                ),
              )
            else
              const ListTile(
                leading: Icon(
                  Icons.check_circle_outline,
                ),
                title: Text(
                  'No pending assignments',
                ),
                subtitle: Text(
                  'You are all caught up!',
                ),
              ),

            const ListTile(
              leading: Icon(
                Icons.warning_amber_outlined,
              ),
              title: Text(
                'Attendance reminder',
              ),
              subtitle: Text(
                'Keep checking your subject attendance '
                'regularly.',
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
