import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs unhandled bloc errors in debug builds.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('[bloc] ${bloc.runtimeType} error: $error');
    }
    super.onError(bloc, error, stackTrace);
  }
}
