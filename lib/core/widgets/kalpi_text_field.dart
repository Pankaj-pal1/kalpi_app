import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';
import '../theme/kalpi_typography.dart';

/// Labelled text input with inline error, matching the 54px field.
class KalpiTextField extends StatelessWidget {
  const KalpiTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.height = AppDimens.fieldHeight,
    this.textStyle,
    this.autofocus = false,
    this.highlight = false,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final double height;
  final TextStyle? textStyle;
  final bool autofocus;

  /// Always draw the mint border (used for the duplicate name field).
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final style = textStyle ?? KalpiTextStyles.fieldValue;
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusControl),
      borderSide: BorderSide(
        color: highlight ? KalpiColors.accent : KalpiColors.border,
        width: AppDimens.borderWidth,
      ),
    );
    final focusedBorder = baseBorder.copyWith(
      borderSide: const BorderSide(
        color: KalpiColors.accent,
        width: AppDimens.borderWidth,
      ),
    );
    final errorBorder = baseBorder.copyWith(
      borderSide: const BorderSide(
        color: KalpiColors.dangerText,
        width: AppDimens.errorBorderWidth,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null) ...<Widget>[
          Text(label!, style: KalpiTextStyles.fieldLabelSmall),
          const SizedBox(height: AppDimens.space8),
        ],
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            style: style,
            cursorColor: KalpiColors.accent,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              counterText: '',
              filled: true,
              fillColor: KalpiColors.surface,
              hintText: hint,
              hintStyle: style.copyWith(color: KalpiColors.textSecondary),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.space16,
                vertical: AppDimens.space12,
              ),
              enabledBorder: hasError ? errorBorder : baseBorder,
              focusedBorder: hasError ? errorBorder : focusedBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              border: baseBorder,
              // Errors render below via our own text so layout stays fixed.
              errorText: null,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            ),
          ),
        ),
        if (hasError) ...<Widget>[
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.space4),
            child: Semantics(
              liveRegion: true,
              child: Text(errorText!, style: KalpiTextStyles.fieldError),
            ),
          ),
        ],
      ],
    );
  }
}
