import 'package:equatable/equatable.dart';

/// A listed company that can be part of a custom universe.
class Stock extends Equatable {
  const Stock({required this.symbol, required this.name});

  final String symbol;
  final String name;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return symbol.toLowerCase().contains(q) || name.toLowerCase().contains(q);
  }

  @override
  List<Object?> get props => <Object?>[symbol, name];
}
