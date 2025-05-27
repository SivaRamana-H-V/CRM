import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_crm_task/domain/entities/customer_entity.dart';
import 'package:flutter_crm_task/domain/repositories/customer_repository.dart';
import 'package:flutter_crm_task/data/models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final Box<CustomerModel> _box;

  CustomerRepositoryImpl(this._box);

  @override
  Future<List<CustomerEntity>> getCustomers() async {
    return _box.values.map((model) => CustomerEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      isActive: model.isActive,
    )).toList();
  }

  @override
  Future<CustomerEntity?> getCustomerById(String id) async {
    final model = _box.get(id);
    if (model == null) return null;
    return CustomerEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      isActive: model.isActive,
    );
  }

  @override
  Future<void> addCustomer(CustomerEntity customer) async {
    final customerModel = CustomerModel(
      id: customer.id,
      name: customer.name,
      email: customer.email,
      phone: customer.phone,
      isActive: customer.isActive,
    );
    await _box.put(customer.id, customerModel);
  }

  @override
  Future<void> updateCustomer(CustomerEntity customer) async {
    final customerModel = CustomerModel(
      id: customer.id,
      name: customer.name,
      email: customer.email,
      phone: customer.phone,
      isActive: customer.isActive,
    );
    await _box.put(customer.id, customerModel);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> toggleCustomerStatus(String id) async {
    final customer = await getCustomerById(id);
    if (customer != null) {
      final updatedCustomer = CustomerModel(
        id: customer.id,
        name: customer.name,
        email: customer.email,
        phone: customer.phone,
        isActive: !customer.isActive,
      );
      await _box.put(id, updatedCustomer);
    }
  }
}