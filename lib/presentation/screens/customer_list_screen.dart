import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/customer_entity.dart';
import '../providers/customer_provider.dart';
import 'customer_form_screen.dart';
import '../widgets/no_hero_fab.dart';
import '../../core/routes/no_hero_page_route.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider);
    final filteredCustomers = ref
        .read(customersProvider.notifier)
        .searchCustomers(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: customers.isEmpty
                ? const Center(
                    child: Text(
                      'No customers found.\nTap + to add a new customer.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      return CustomerListTile(customer: customer);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: NoHeroFab(
        onPressed: () {
          Navigator.push(
            context,
            NoHeroPageRoute(
              builder: (context) => const CustomerFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomerListTile extends ConsumerWidget {
  final CustomerEntity customer;

  const CustomerListTile({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.email, size: 16),
                const SizedBox(width: 4),
                Expanded(child: Text(customer.email)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 4),
                Text(customer.phone),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: customer.isActive,
              onChanged: (value) {
                ref
                    .read(customersProvider.notifier)
                    .toggleCustomerStatus(customer.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  NoHeroPageRoute(
                    builder: (context) => CustomerFormScreen(
                      customer: customer,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Customer'),
                    content: const Text(
                      'Are you sure you want to delete this customer?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(customersProvider.notifier)
                              .deleteCustomer(customer.id);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}