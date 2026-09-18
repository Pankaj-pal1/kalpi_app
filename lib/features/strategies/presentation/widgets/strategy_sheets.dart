import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/kalpi_bottom_sheet.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/list_tile_row.dart';
import '../../domain/strategy.dart';

enum StrategyAction { edit, duplicate, delete }

/// "Manage your saved strategy" action sheet. Resolves with the chosen
/// action, or null when cancelled.
Future<StrategyAction?> showStrategyActionsSheet(
  BuildContext context,
  Strategy strategy,
) => showKalpiSheet<StrategyAction>(
  context: context,
  builder: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const SizedBox(height: AppDimens.space12),
      Semantics(
        header: true,
        child: Text(
          strategy.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: KalpiTextStyles.sheetTitle,
        ),
      ),
      const SizedBox(height: AppDimens.space8),
      Text(AppStrings.manageSubtitle, style: KalpiTextStyles.subtitle),
      const SizedBox(height: AppDimens.space16 + 1),
      ActionRow(
        icon: KalpiIcons.edit,
        label: AppStrings.editStrategy,
        onTap: () => Navigator.of(context).pop(StrategyAction.edit),
      ),
      const SizedBox(height: AppDimens.space12),
      ActionRow(
        icon: KalpiIcons.copy,
        label: AppStrings.duplicateStrategy,
        onTap: () => Navigator.of(context).pop(StrategyAction.duplicate),
      ),
      const SizedBox(height: AppDimens.space12),
      ActionRow(
        icon: KalpiIcons.delete,
        label: AppStrings.deleteStrategy,
        color: KalpiColors.dangerText,
        onTap: () => Navigator.of(context).pop(StrategyAction.delete),
      ),
      const SizedBox(height: AppDimens.space48 + 1),
      KalpiButton.secondary(
        label: AppStrings.cancel,
        centered: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
      const SizedBox(height: AppDimens.space12),
    ],
  ),
);

/// Shared frame for consequential confirmations (delete, discard draft).
class ConfirmSheetBody extends StatelessWidget {
  const ConfirmSheetBody({
    super.key,
    required this.title,
    required this.body,
    required this.keepLabel,
    required this.destructiveLabel,
    required this.onKeep,
    required this.onDestructive,
    this.busy = false,
    this.busyLabel,
    this.error,
  });

  final String title;
  final String body;
  final String keepLabel;
  final String destructiveLabel;
  final VoidCallback onKeep;
  final VoidCallback onDestructive;
  final bool busy;
  final String? busyLabel;
  final String? error;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const SizedBox(height: AppDimens.space12 - 1),
      Container(
        width: AppDimens.dangerIconTileSize,
        height: AppDimens.dangerIconTileSize,
        decoration: BoxDecoration(
          color: KalpiColors.dangerSurface,
          borderRadius: BorderRadius.circular(AppDimens.dangerIconTileRadius),
        ),
        alignment: Alignment.center,
        child: const Icon(
          KalpiIcons.delete,
          size: AppDimens.iconLarge,
          color: KalpiColors.dangerText,
        ),
      ),
      const SizedBox(height: AppDimens.space24 + 1),
      Semantics(
        header: true,
        child: Text(title, style: KalpiTextStyles.sheetTitle),
      ),
      const SizedBox(height: AppDimens.space20 + 2),
      Text(body, style: KalpiTextStyles.subtitle),
      if (error != null) ...<Widget>[
        const SizedBox(height: AppDimens.space12),
        Semantics(
          liveRegion: true,
          child: Text(error!, style: KalpiTextStyles.fieldErrorRegular),
        ),
      ],
      const SizedBox(height: AppDimens.space32 + 4),
      Focus(
        autofocus: true,
        child: KalpiButton.secondary(
          label: keepLabel,
          centered: true,
          enabled: !busy,
          onPressed: onKeep,
        ),
      ),
      const SizedBox(height: AppDimens.space12),
      KalpiButton.danger(
        label: destructiveLabel,
        busy: busy,
        busyLabel: busyLabel,
        onPressed: onDestructive,
      ),
      const SizedBox(height: AppDimens.space12),
    ],
  );
}

/// Asks before discarding an unsaved builder draft. Resolves true to discard.
Future<bool> showExitConfirmationSheet(BuildContext context) async {
  final result = await showKalpiSheet<bool>(
    context: context,
    isDismissible: false,
    builder: (context) => ConfirmSheetBody(
      title: AppStrings.exitTitle,
      body: AppStrings.exitBody,
      keepLabel: AppStrings.keepBuilding,
      destructiveLabel: AppStrings.discardDraft,
      onKeep: () => Navigator.of(context).pop(false),
      onDestructive: () => Navigator.of(context).pop(true),
    ),
  );
  return result ?? false;
}
