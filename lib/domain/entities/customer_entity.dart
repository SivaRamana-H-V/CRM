class CustomerEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isActive;

  CustomerEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
  });

  CustomerEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool? isActive,
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
    );
  }
}
