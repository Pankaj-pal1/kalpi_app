import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_icons.dart';
import '../theme/kalpi_typography.dart';
import 'surface_card.dart';

/// Full-width radio card: icon tile, title, description and a selection
/// indicator. The entire card is the tap target.
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.minHeight = 92,
    this.trailing,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final double minHeight;

  /// Replaces the default check/circle indicator.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final indicator =
        trailing ??
        Icon(
          selected ? KalpiIcons.check : KalpiIcons.circle,
          size: AppDimens.iconSmall,
          color: selected ? KalpiColors.accent : KalpiColors.border,
        );
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      button: true,
      label: '$title. $description',
      child: SurfaceCard(
        radius: AppDimens.radiusChoice,
        color: selected ? KalpiColors.surfaceSelected : KalpiColors.surface,
        borderColor: selected ? KalpiColors.accent : KalpiColors.border,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.space16,
              AppDimens.space16 + 2,
              AppDimens.space20,
              AppDimens.space24,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconTile(
                  icon: icon,
                  color: selected
                      ? KalpiColors.surface
                      : KalpiColors.background,
                ),
                const SizedBox(width: AppDimens.space12 + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: KalpiTextStyles.cardTitle),
                      const SizedBox(height: 6),
                      Text(description, style: KalpiTextStyles.cardSubtitle),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: indicator,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
