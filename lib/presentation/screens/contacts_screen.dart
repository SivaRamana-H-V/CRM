import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_crm_task/data/models/contact_model.dart';
import 'package:flutter_crm_task/presentation/providers/contacts_provider.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(contactsProvider.notifier).loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(contactsProvider.notifier).loadContacts();
            },
          ),
        ],
      ),
      body: contacts.isEmpty
          ? const Center(
              child: Text('No contacts found'),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ContactListTile(contact: contact);
              },
            ),
    );
  }
}

class ContactListTile extends ConsumerWidget {
  final ContactModel contact;

  const ContactListTile({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          contact.displayName[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(contact.displayName),
      subtitle: contact.phoneNumbers.isNotEmpty
          ? Text(contact.phoneNumbers.first)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!contact.isSynced)
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () {
                ref.read(contactsProvider.notifier).syncContact(contact);
              },
            ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Navigate to call screen
              // Implementation depends on your navigation setup
            },
          ),
        ],
      ),
    );
  }
} 