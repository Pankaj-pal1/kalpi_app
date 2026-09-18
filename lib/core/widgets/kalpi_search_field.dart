import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../constants/app_strings.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_icons.dart';
import '../theme/kalpi_typography.dart';
import 'kalpi_icon_button.dart';

/// 50px search input with a leading glyph and a clear control when non-empty.
class KalpiSearchField extends StatelessWidget {
  const KalpiSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onClear,
    this.focusNode,
    this.height = AppDimens.searchFieldHeight,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final double height;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusControl),
      borderSide: const BorderSide(
        color: KalpiColors.border,
        width: AppDimens.borderWidth,
      ),
    );
    return SizedBox(
      height: height,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          onChanged: onChanged,
          style: KalpiTextStyles.subtitle.copyWith(color: KalpiColors.text),
          cursorColor: KalpiColors.accent,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: KalpiColors.surface,
            hintText: hint,
            hintStyle: KalpiTextStyles.subtitle,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppDimens.space12,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 53,
              minHeight: 0,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(
                left: AppDimens.space16 + 2,
                right: AppDimens.space16 + 1,
              ),
              child: Icon(
                KalpiIcons.search,
                size: AppDimens.iconDefault,
                color: KalpiColors.textSecondary,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : KalpiIconButton(
                    icon: KalpiIcons.close,
                    semanticLabel: AppStrings.clearSearch,
                    color: KalpiColors.textSecondary,
                    size: 14,
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                      onClear?.call();
                    },
                  ),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(
                color: KalpiColors.accent,
                width: AppDimens.borderWidth,
              ),
            ),
            border: border,
          ),
        ),
      ),
    );
  }
}
