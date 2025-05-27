import 'package:contacts_service/contacts_service.dart' as contacts;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_crm_task/data/models/contact_model.dart';

class ContactsService {
  Future<bool> requestPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  Future<List<ContactModel>> getContacts() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        throw Exception('Contacts permission not granted');
      }

      final Iterable<contacts.Contact> deviceContacts =
          await contacts.ContactsService.getContacts();
      return deviceContacts
          .map((contact) => ContactModel.fromContact(contact))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch contacts: $e');
    }
  }

  Future<void> syncContact(ContactModel contact) async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        throw Exception('Contacts permission not granted');
      }

      final deviceContact = contacts.Contact();
      deviceContact.givenName = contact.displayName;

      if (contact.email != null) {
        deviceContact.emails = [
          contacts.Item(label: "email", value: contact.email)
        ];
      }

      deviceContact.phones = contact.phoneNumbers
          .map((phone) => contacts.Item(label: "mobile", value: phone))
          .toList();

      await contacts.ContactsService.addContact(deviceContact);
    } catch (e) {
      throw Exception('Failed to sync contact: $e');
    }
  }

  Future<void> deleteContact(String contactId) async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        throw Exception('Contacts permission not granted');
      }

      final deviceContacts = await contacts.ContactsService.getContacts();
      final targetContact = deviceContacts.firstWhere(
        (contact) => contact.identifier == contactId,
        orElse: () => throw Exception('Contact not found'),
      );

      await contacts.ContactsService.deleteContact(targetContact);
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }
}
