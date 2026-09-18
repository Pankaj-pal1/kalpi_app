import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_colors.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/dropdown_field.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/kalpi_bottom_sheet.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_icon_button.dart';
import '../../../strategies/domain/metric.dart';
import '../../../strategies/domain/rule.dart';
import '../../../strategies/domain/rule_operator.dart';
import '../../../strategies/domain/strategy_narrator.dart';
import '../../../strategies/domain/strategy_validation.dart';

/// Outcome of the rule editor.
sealed class RuleEditorResult {
  const RuleEditorResult();
}

class RuleSaved extends RuleEditorResult {
  const RuleSaved(this.rule);
  final Rule rule;
}

class RuleRemoved extends RuleEditorResult {
  const RuleRemoved(this.ruleId);
  final String ruleId;
}

/// Opens the rule editor. Pass [existing] to edit, otherwise a new rule with
/// [newRuleId] is created. [otherRules] is used to reject exact duplicates.
Future<RuleEditorResult?> showRuleEditorSheet(
  BuildContext context, {
  required List<Rule> otherRules,
  Rule? existing,
  String? newRuleId,
}) => showKalpiSheet<RuleEditorResult>(
  context: context,
  builder: (context) => RuleEditorSheet(
    existing: existing,
    newRuleId: newRuleId,
    otherRules: otherRules,
  ),
);

class RuleEditorSheet extends StatefulWidget {
  const RuleEditorSheet({
    super.key,
    required this.otherRules,
    this.existing,
    this.newRuleId,
  }) : assert(
         existing != null || newRuleId != null,
         'Need an id for a new rule',
       );

  final List<Rule> otherRules;
  final Rule? existing;
  final String? newRuleId;

  @override
  State<RuleEditorSheet> createState() => _RuleEditorSheetState();
}

class _RuleEditorSheetState extends State<RuleEditorSheet> {
  late Metric _metric;
  late RuleOperator _operator;
  late final TextEditingController _value;
  final FocusNode _valueFocus = FocusNode();
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _metric = existing?.metric ?? Metric.roe;
    _operator = existing?.operator ?? RuleOperator.gt;
    _value = TextEditingController(
      text: existing == null ? '15' : formatCompactNumber(existing.value),
    );
  }

  @override
  void dispose() {
    _value.dispose();
    _valueFocus.dispose();
    super.dispose();
  }

  Future<void> _pickMetric() async {
    final picked = await context.push<Metric>(
      '${AppRoutes.metricPicker}?${AppRoutes.queryMode}=${AppRoutes.modeRule}',
    );
    if (picked != null && mounted) {
      setState(() {
        _metric = picked;
        _error = null;
      });
    }
  }

  Future<void> _pickOperator() async {
    final picked = await showKalpiSheet<RuleOperator>(
      context: context,
      builder: (context) => _OperatorList(selected: _operator),
    );
    if (picked != null && mounted) {
      setState(() {
        _operator = picked;
        _error = null;
      });
    }
  }

  void _save() {
    final parsed = StrategyValidation.parseRuleValue(
      _metric,
      _operator,
      _value.text,
    );
    if (!parsed.isValid) {
      setState(() => _error = parsed.error);
      _valueFocus.requestFocus();
      return;
    }
    final rule = Rule(
      id: widget.existing?.id ?? widget.newRuleId!,
      metric: _metric,
      operator: _operator,
      value: parsed.value!,
    );
    if (StrategyValidation.isDuplicateRule(widget.otherRules, rule)) {
      setState(() => _error = AppStrings.duplicateRuleError);
      return;
    }
    Navigator.of(context).pop(RuleSaved(rule));
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEdit
        ? AppStrings.editRuleTitle(
            StrategyNarrator.ruleWord(widget.existing!.metric),
          )
        : AppStrings.addRuleTitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: KalpiTextStyles.sheetTitle),
              ),
            ),
            KalpiIconButton(
              icon: KalpiIcons.close,
              semanticLabel: AppStrings.closeRuleEditor,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space12 + 1),
        Text(AppStrings.metricLabel, style: KalpiTextStyles.fieldLabel),
        const SizedBox(height: 6),
        DropdownField(
          value: _metric.editorLabel,
          onTap: _pickMetric,
          semanticLabel: '${AppStrings.metricLabel}: ${_metric.editorLabel}',
        ),
        const SizedBox(height: AppDimens.space24 - 1),
        Text(AppStrings.conditionLabel, style: KalpiTextStyles.fieldLabel),
        const SizedBox(height: 5),
        Row(
          children: <Widget>[
            Expanded(
              flex: 208,
              child: DropdownField(
                value: _operator.label,
                onTap: _pickOperator,
                height: AppDimens.conditionFieldHeight,
                color: KalpiColors.surface,
                textStyle: KalpiTextStyles.fieldValueRegular,
                semanticLabel:
                    '${AppStrings.conditionLabel}: ${_operator.label}',
              ),
            ),
            const SizedBox(width: AppDimens.space16),
            Expanded(
              flex: 118,
              child: _ValueField(
                controller: _value,
                focusNode: _valueFocus,
                suffix: _metric.unit.suffix,
                hasError: _error != null,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                onSubmitted: (_) => _save(),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space24 + 3),
        InfoBanner(text: _metric.explanation),
        const SizedBox(height: AppDimens.space24 + 1),
        Semantics(
          liveRegion: _error != null,
          child: Text(
            _error ?? AppStrings.exampleRuleHint,
            style: _error == null
                ? KalpiTextStyles.caption
                : KalpiTextStyles.fieldErrorRegular,
          ),
        ),
        const SizedBox(height: AppDimens.space48 - 2),
        KalpiButton(
          label: AppStrings.saveRule,
          icon: KalpiIcons.check,
          onPressed: _save,
        ),
        if (_isEdit) ...<Widget>[
          const SizedBox(height: AppDimens.space8),
          Center(
            child: TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(RuleRemoved(widget.existing!.id)),
              style: TextButton.styleFrom(
                minimumSize: const Size(
                  AppDimens.minTouchTarget,
                  AppDimens.minTouchTarget,
                ),
                foregroundColor: KalpiColors.dangerText,
              ),
              child: Text(
                AppStrings.removeRule,
                style: KalpiTextStyles.body(
                  14,
                  weight: FontWeight.w600,
                  color: KalpiColors.dangerText,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppDimens.space12),
      ],
    );
  }
}

/// Numeric input with the unit suffix; mint outline on a selected surface.
class _ValueField extends StatelessWidget {
  const _ValueField({
    required this.controller,
    required this.focusNode,
    required this.suffix,
    required this.hasError,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String suffix;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) => Container(
    height: AppDimens.conditionFieldHeight,
    decoration: BoxDecoration(
      color: KalpiColors.surfaceSelected,
      borderRadius: BorderRadius.circular(AppDimens.radiusControl),
      border: Border.all(
        color: hasError ? KalpiColors.dangerText : KalpiColors.accent,
        width: hasError ? AppDimens.errorBorderWidth : AppDimens.borderWidth,
      ),
    ),
    padding: const EdgeInsets.only(
      left: AppDimens.space16 + 2,
      right: AppDimens.space20,
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
              LengthLimitingTextInputFormatter(10),
            ],
            textInputAction: TextInputAction.done,
            style: KalpiTextStyles.numericValue,
            cursorColor: KalpiColors.accent,
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              border: InputBorder.none,
              hintText: '—',
              hintStyle: KalpiTextStyles.numericValue,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.space8),
        Text(suffix, style: KalpiTextStyles.subtitle),
      ],
    ),
  );
}

class _OperatorList extends StatelessWidget {
  const _OperatorList({required this.selected});

  final RuleOperator selected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text(AppStrings.conditionLabel, style: KalpiTextStyles.sheetTitle),
      const SizedBox(height: AppDimens.space16),
      for (final op in RuleOperator.values)
        Semantics(
          button: true,
          selected: op == selected,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(op),
            borderRadius: BorderRadius.circular(AppDimens.radiusControl),
            splashFactory: NoSplash.splashFactory,
            highlightColor: KalpiColors.surfaceSelected,
            child: SizedBox(
              height: 56,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: AppDimens.space8),
                  SizedBox(
                    width: AppDimens.space24,
                    child: Text(
                      op.symbol,
                      style: KalpiTextStyles.cardTitle.copyWith(
                        color: KalpiColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.space16),
                  Expanded(
                    child: Text(
                      op.label,
                      style: KalpiTextStyles.cardTitleMedium,
                    ),
                  ),
                  if (op == selected)
                    const Icon(
                      KalpiIcons.check,
                      size: AppDimens.iconSmall,
                      color: KalpiColors.accent,
                    ),
                  const SizedBox(width: AppDimens.space16),
                ],
              ),
            ),
          ),
        ),
      const SizedBox(height: AppDimens.space12),
    ],
  );
}
