import '../domain/strategy.dart';
import '../domain/strategy_draft.dart';

/// Contract for reading and writing saved strategy definitions.
///
/// Every mutation carries a caller-generated [requestId] so retries after an
/// uncertain outcome never create duplicates.
abstract interface class StrategyRepository {
  Future<List<Strategy>> list();
  Future<Strategy?> get(String id);
  Future<Strategy> create(StrategyDraft draft, {required String requestId});
  Future<Strategy> update(
    String id,
    StrategyDraft draft, {
    required String requestId,
    String? revision,
  });
  Future<void> delete(String id, {required String requestId});
}

class StrategyRepositoryException implements Exception {
  const StrategyRepositoryException(this.message);

  final String message;

  @override
  String toString() => 'StrategyRepositoryException: $message';
}

class StrategyNotFoundException extends StrategyRepositoryException {
  const StrategyNotFoundException(String id) : super('Strategy $id not found');
}

class StaleRevisionException extends StrategyRepositoryException {
  const StaleRevisionException()
    : super('This strategy changed elsewhere. Reload before saving.');
}
