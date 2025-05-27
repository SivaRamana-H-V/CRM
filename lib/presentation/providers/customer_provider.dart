import 'package:flutter_crm_task/domain/entities/customer_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_crm_task/data/repositories/customer_repository.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});

final customersProvider =
    StateNotifierProvider<CustomerNotifier, List<CustomerEntity>>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return CustomerNotifier(repository);
});

class CustomerNotifier extends StateNotifier<List<CustomerEntity>> {
  final CustomerRepository _repository;

  CustomerNotifier(this._repository) : super([]) {
    _initializeCustomers();
  }

  Future<void> _initializeCustomers() async {
    await _repository.init();
    state = _repository.getAllCustomers();
  }

  Future<void> addCustomer(CustomerEntity customer) async {
    await _repository.addCustomer(customer);
    state = _repository.getAllCustomers();
  }

  Future<void> updateCustomer(CustomerEntity customer) async {
    await _repository.updateCustomer(customer);
    state = _repository.getAllCustomers();
  }

  Future<void> deleteCustomer(String id) async {
    await _repository.deleteCustomer(id);
    state = _repository.getAllCustomers();
  }

  Future<void> toggleCustomerStatus(String id) async {
    await _repository.toggleCustomerStatus(id);
    state = _repository.getAllCustomers();
  }

  List<CustomerEntity> searchCustomers(String query) {
    if (query.isEmpty) return state;
    return _repository.searchCustomers(query);
  }
}