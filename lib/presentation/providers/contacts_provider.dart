import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_crm_task/data/models/contact_model.dart';
import 'package:flutter_crm_task/data/services/contacts_service.dart';

final contactsServiceProvider = Provider<ContactsService>((ref) {
  return ContactsService();
});

final contactsProvider =
    StateNotifierProvider<ContactsNotifier, List<ContactModel>>((ref) {
  return ContactsNotifier(ref.watch(contactsServiceProvider));
});

class ContactsNotifier extends StateNotifier<List<ContactModel>> {
  final ContactsService _contactsService;
  bool _isLoading = false;

  ContactsNotifier(this._contactsService) : super([]);

  bool get isLoading => _isLoading;

  Future<void> loadContacts() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final contacts = await _contactsService.getContacts();
      state = contacts;
    } catch (e) {
      // Handle error
      state = [];
    } finally {
      _isLoading = false;
    }
  }

  Future<void> syncContact(ContactModel contact) async {
    try {
      await _contactsService.syncContact(contact);
      state = [
        for (final c in state)
          if (c.id == contact.id) contact.copyWith(isSynced: true) else c
      ];
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteContact(String contactId) async {
    try {
      await _contactsService.deleteContact(contactId);
      state = state.where((contact) => contact.id != contactId).toList();
    } catch (e) {
      // Handle error
    }
  }
} 