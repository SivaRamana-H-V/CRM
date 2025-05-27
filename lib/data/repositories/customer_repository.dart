import 'package:flutter_crm_task/domain/entities/customer_entity.dart';
import 'package:hive/hive.dart';
import 'package:flutter_crm_task/data/models/customer_model.dart';

class CustomerRepository {
  static const String _boxName = 'customers';
  Box<CustomerModel>? _box;

  Future<void> init() async {
    if (_box != null) return;

    try {
      if (!Hive.isBoxOpen(_boxName)) {
        _box = await Hive.openBox<CustomerModel>(_boxName);
      } else {
        _box = Hive.box<CustomerModel>(_boxName);
      }
    } catch (e) {
      // If there's an error opening the box, try to delete and recreate it
      await Hive.deleteBoxFromDisk(_boxName);
      _box = await Hive.openBox<CustomerModel>(_boxName);
    }
  }

  Box<CustomerModel> get _getBox {
    if (_box == null) {
      throw StateError('Repository not initialized. Call init() first.');
    }
    return _box!;
  }

  CustomerEntity _modelToEntity(CustomerModel model) {
    return CustomerEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      phone: model.phone,
      isActive: model.isActive,
    );
  }

  CustomerModel _entityToModel(CustomerEntity entity) {
    return CustomerModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      isActive: entity.isActive,
    );
  }

  Future<void> addCustomer(CustomerEntity customer) async {
    final model = _entityToModel(customer);
    await _getBox.put(model.id, model);
  }

  Future<void> updateCustomer(CustomerEntity customer) async {
    final model = _entityToModel(customer);
    await _getBox.put(model.id, model);
  }

  Future<void> deleteCustomer(String id) async {
    await _getBox.delete(id);
  }

  Future<CustomerEntity?> getCustomer(String id) async {
    final model = _getBox.get(id);
    return model != null ? _modelToEntity(model) : null;
  }

  List<CustomerEntity> getAllCustomers() {
    return _getBox.values.map(_modelToEntity).toList();
  }

  List<CustomerEntity> searchCustomers(String query) {
    query = query.toLowerCase();
    return _getBox.values
        .where((model) {
          return model.name.toLowerCase().contains(query) ||
              model.email.toLowerCase().contains(query) ||
              model.phone.toLowerCase().contains(query);
        })
        .map(_modelToEntity)
        .toList();
  }

  Future<void> toggleCustomerStatus(String id) async {
    final model = _getBox.get(id);
    if (model != null) {
      final updatedModel = model.copyWith(isActive: !model.isActive);
      await _getBox.put(id, updatedModel);
    }
  }

  Future<void> dispose() async {
    await _box?.close();
    _box = null;
  }
}
