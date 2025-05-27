import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_crm_task/presentation/providers/auth_provider.dart';
import 'customer_list_screen.dart';
import 'chat_screen.dart';
import 'call_logs_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CustomerListScreen(),
    const ChatScreen(
      customerId: 'customer123',
      customerName: 'Siva',
      userId: 'agent123',
    ),
    const CallLogsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRole = ref.watch(userRoleProvider);
    final userEmail = ref.watch(userEmailProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Clear authentication state
              ref.read(isAuthenticatedProvider.notifier).state = false;
              ref.read(userEmailProvider.notifier).state = null;
              ref.read(userRoleProvider.notifier).state = null;
              ref.read(authProvider.notifier).state = null;

              // Navigate to login
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userRole ?? ''),
              accountEmail: Text(userEmail ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  (userEmail?.isNotEmpty ?? false)
                      ? userEmail![0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Customers'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Messages'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Call Logs'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            if (userRole == 'Admin')
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Analytics'),
                onTap: () {
                  // TODO: Implement analytics
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // TODO: Implement settings
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Customers'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
        ],
      ),
    );
  }
}
