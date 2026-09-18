import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_typography.dart';

enum KalpiButtonVariant { primary, secondary, danger }

/// 54px action button matching the Penpot component.
///
/// Labels sit at the leading edge with an optional trailing icon, or centred
/// when [centered] is true (sheet actions). While [busy] the width and label
/// area are preserved, the label switches to [busyLabel] and taps are
/// ignored so a request cannot be repeated.
class KalpiButton extends StatelessWidget {
  const KalpiButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = KalpiButtonVariant.primary,
    this.centered = false,
    this.busy = false,
    this.busyLabel,
    this.enabled = true,
    this.semanticLabel,
  });

  const KalpiButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.centered = false,
    this.busy = false,
    this.busyLabel,
    this.enabled = true,
    this.semanticLabel,
  }) : variant = KalpiButtonVariant.secondary;

  const KalpiButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.centered = true,
    this.busy = false,
    this.busyLabel,
    this.enabled = true,
    this.semanticLabel,
  }) : variant = KalpiButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final KalpiButtonVariant variant;
  final bool centered;
  final bool busy;
  final String? busyLabel;
  final bool enabled;
  final String? semanticLabel;

  bool get _interactive => enabled && !busy && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    final Color pressed;
    BorderSide side = BorderSide.none;
    switch (variant) {
      case KalpiButtonVariant.primary:
        background = KalpiColors.primary;
        foreground = KalpiColors.onPrimary;
        pressed = KalpiColors.primaryPressed;
      case KalpiButtonVariant.secondary:
        background = KalpiColors.surface;
        foreground = KalpiColors.text;
        pressed = KalpiColors.surfaceSelected;
        side = const BorderSide(
          color: KalpiColors.border,
          width: AppDimens.borderWidth,
        );
      case KalpiButtonVariant.danger:
        background = KalpiColors.danger;
        foreground = KalpiColors.onPrimary;
        pressed = const Color(0xFF8E353A);
    }

    final text = busy ? (busyLabel ?? label) : label;
    final labelWidget = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: KalpiTextStyles.button.copyWith(color: foreground),
    );

    Widget child;
    if (centered) {
      child = Center(child: labelWidget);
    } else {
      child = Row(
        children: <Widget>[
          const SizedBox(width: AppDimens.space16),
          Expanded(child: labelWidget),
          if (icon != null) ...<Widget>[
            const SizedBox(width: AppDimens.space12),
            _TrailingIcon(icon: icon!, color: foreground, busy: busy),
            const SizedBox(width: AppDimens.space16 + 2),
          ] else
            const SizedBox(width: AppDimens.space16),
        ],
      );
    }

    return Semantics(
      button: true,
      enabled: _interactive,
      label: semanticLabel ?? text,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: SizedBox(
          height: AppDimens.buttonHeight,
          width: double.infinity,
          child: Material(
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusControl),
              side: side,
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: _interactive ? onPressed : null,
              splashFactory: NoSplash.splashFactory,
              highlightColor: pressed,
              hoverColor: variant == KalpiButtonVariant.primary
                  ? KalpiColors.primaryHover
                  : pressed,
              focusColor: pressed,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({
    required this.icon,
    required this.color,
    required this.busy,
  });

  final IconData icon;
  final Color color;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return SizedBox(
        width: AppDimens.iconLarge,
        height: AppDimens.iconLarge,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: CircularProgressIndicator(strokeWidth: 2, color: color),
        ),
      );
    }
    return Icon(icon, size: AppDimens.iconLarge, color: color);
  }
}
