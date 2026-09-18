import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../constants/app_strings.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_icons.dart';
import '../theme/kalpi_typography.dart';

enum KalpiTab { strategies, build, learn }

/// Three-destination bottom bar. Hidden inside the builder and onboarding.
class KalpiBottomNav extends StatelessWidget {
  const KalpiBottomNav({
    super.key,
    required this.current,
    required this.onSelect,
  });

  /// Null when no tab is current (e.g. Learn opened from a card).
  final KalpiTab? current;
  final ValueChanged<KalpiTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: KalpiColors.surface,
        border: Border(top: BorderSide(color: KalpiColors.border, width: 1)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: AppDimens.bottomNavHeight,
        child: Row(
          children: <Widget>[
            _NavItem(
              tab: KalpiTab.strategies,
              icon: KalpiIcons.stack,
              label: AppStrings.navStrategies,
              selected: current == KalpiTab.strategies,
              onTap: () => onSelect(KalpiTab.strategies),
            ),
            _NavItem(
              tab: KalpiTab.build,
              icon: KalpiIcons.plus,
              label: AppStrings.navBuild,
              selected: current == KalpiTab.build,
              onTap: () => onSelect(KalpiTab.build),
            ),
            _NavItem(
              tab: KalpiTab.learn,
              icon: KalpiIcons.book,
              label: AppStrings.navLearn,
              selected: current == KalpiTab.learn,
              onTap: () => onSelect(KalpiTab.learn),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final KalpiTab tab;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? KalpiColors.accent : KalpiColors.textSecondary;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          splashFactory: NoSplash.splashFactory,
          highlightColor: KalpiColors.surfaceSelected.withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: AppDimens.navIndicatorWidth,
                  height: AppDimens.navIndicatorHeight,
                  decoration: BoxDecoration(
                    color: selected
                        ? KalpiColors.surfaceSelected
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppDimens.navIndicatorHeight / 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: AppDimens.iconDefault, color: color),
                ),
                const SizedBox(height: AppDimens.space8),
                Text(
                  label,
                  style: KalpiTextStyles.navLabel.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
