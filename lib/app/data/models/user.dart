import 'package:isar/isar.dart';

part 'user.g.dart';

/// User Collection - Represents a local user for authentication
@collection
class User {
  Id id = Isar.autoIncrement;

  /// Username for login
  @Index(unique: true)
  late String username;

  /// Password hash (for local authentication)
  late String passwordHash;

  /// User's display name
  late String displayName;

  /// Is this user active?
  bool isActive = true;

  /// Date created
  DateTime dateCreated = DateTime.now();

  /// Last login date
  DateTime? lastLogin;
}

// Authored by: Moazzam Samoo
