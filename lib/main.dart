import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app_bloc_observer.dart';
import 'app/di/app_dependencies.dart';
import 'app/kalpi_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  final dependencies = await AppDependencies.create();
  runApp(KalpiApp(dependencies: dependencies));
}
