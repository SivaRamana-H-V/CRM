import 'package:contacts_service/contacts_service.dart';

class ContactModel {
  final String id;
  final String displayName;
  final List<String> phoneNumbers;
  final String? email;
  final String? avatar;
  final bool isSynced;

  ContactModel({
    required this.id,
    required this.displayName,
    required this.phoneNumbers,
    this.email,
    this.avatar,
    this.isSynced = false,
  });

  factory ContactModel.fromContact(Contact contact) {
    return ContactModel(
      id: contact.identifier ?? DateTime.now().toString(),
      displayName: contact.displayName ?? '',
      phoneNumbers: contact.phones?.map((phone) => phone.value ?? '').toList() ?? [],
      email: contact.emails?.firstOrNull?.value,
      avatar: contact.avatar != null ? String.fromCharCodes(contact.avatar!) : null,
      isSynced: false,
    );
  }

  ContactModel copyWith({
    String? id,
    String? displayName,
    List<String>? phoneNumbers,
    String? email,
    String? avatar,
    bool? isSynced,
  }) {
    return ContactModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      isSynced: isSynced ?? this.isSynced,
    );
  }
} 