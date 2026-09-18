import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_durations.dart';

/// Page with the 160ms dissolve used across the design. Honours reduced
/// motion by collapsing the duration to zero.
class KalpiPage<T> extends CustomTransitionPage<T> {
  KalpiPage({required super.child, super.key, super.name})
    : super(
        transitionDuration: AppDurations.page,
        reverseTransitionDuration: AppDurations.page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (MediaQuery.disableAnimationsOf(context)) return child;
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      );
}
