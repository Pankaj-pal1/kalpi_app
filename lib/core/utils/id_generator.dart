import 'package:uuid/uuid.dart';

/// Generates ids for strategies, rules and idempotent requests.
abstract interface class IdGenerator {
  String next();
}

class UuidGenerator implements IdGenerator {
  const UuidGenerator();

  static const Uuid _uuid = Uuid();

  @override
  String next() => _uuid.v4();
}
