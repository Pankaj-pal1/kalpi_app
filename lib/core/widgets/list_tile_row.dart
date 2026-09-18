import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_icons.dart';
import '../theme/kalpi_typography.dart';

/// Row with leading icon, label and trailing chevron, used in action sheets.
class ActionRow extends StatelessWidget {
  const ActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = KalpiColors.text,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusControl),
      splashFactory: NoSplash.splashFactory,
      highlightColor: KalpiColors.surfaceSelected,
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            const SizedBox(width: AppDimens.space8),
            SizedBox(
              width: AppDimens.space20,
              child: Icon(icon, size: AppDimens.iconLarge, color: color),
            ),
            const SizedBox(width: AppDimens.space24),
            Expanded(
              child: Text(
                label,
                style: KalpiTextStyles.cardTitleMedium.copyWith(color: color),
              ),
            ),
            Icon(KalpiIcons.chevron, size: 15, color: color),
            const SizedBox(width: AppDimens.space16 - 2),
          ],
        ),
      ),
    ),
  );
}

/// Key/value row inside the detail card.
class KeyValueRow extends StatelessWidget {
  const KeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.secondaryValues = const <String>[],
  });

  final String label;
  final String value;
  final List<String> secondaryValues;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppDimens.space16 + 1),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 140,
          child: Text(label, style: KalpiTextStyles.detailKey),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                value,
                textAlign: TextAlign.end,
                style: KalpiTextStyles.detailValue,
              ),
              for (final extra in secondaryValues) ...<Widget>[
                const SizedBox(height: AppDimens.space4 + 1),
                Text(
                  extra,
                  textAlign: TextAlign.end,
                  style: KalpiTextStyles.detailValueSecondary,
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
