import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/kalpi_bottom_sheet.dart';
import '../../domain/strategy.dart';
import '../cubit/strategy_list_cubit.dart';
import 'strategy_sheets.dart';

/// Named delete confirmation. Resolves true once the strategy is gone.
Future<bool> showDeleteStrategySheet(
  BuildContext context,
  Strategy strategy,
) async {
  final cubit = context.read<StrategyListCubit>();
  cubit.clearDeleteError();
  final result = await showKalpiSheet<bool>(
    context: context,
    isDismissible: false,
    builder: (sheetContext) => BlocProvider.value(
      value: cubit,
      child: BlocBuilder<StrategyListCubit, StrategyListState>(
        builder: (context, state) {
          final busy = state.pendingDeleteId == strategy.id;
          return ConfirmSheetBody(
            title: AppStrings.deleteTitle(strategy.name),
            body: AppStrings.deleteBody,
            keepLabel: AppStrings.keepStrategy,
            destructiveLabel: state.deleteError == null
                ? AppStrings.deleteStrategy
                : AppStrings.retry,
            busy: busy,
            busyLabel: AppStrings.deleting,
            error: state.deleteError,
            onKeep: () => Navigator.of(sheetContext).pop(false),
            onDestructive: () async {
              final ok = await cubit.delete(strategy);
              if (ok && sheetContext.mounted) {
                Navigator.of(sheetContext).pop(true);
              }
            },
          );
        },
      ),
    ),
  );
  return result ?? false;
}
