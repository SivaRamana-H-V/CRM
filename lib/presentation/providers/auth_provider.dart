import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_model.dart';

final authProvider = StateProvider<UserModel?>((ref) => null);
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);
final userEmailProvider = StateProvider<String?>((ref) => null);
final userRoleProvider = StateProvider<String?>((ref) => null);