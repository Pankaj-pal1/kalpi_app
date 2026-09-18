import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/kalpi_icons.dart';
import '../../../../core/theme/kalpi_typography.dart';
import '../../../../core/widgets/info_banner.dart';
import '../../../../core/widgets/kalpi_button.dart';
import '../../../../core/widgets/kalpi_scaffold.dart';
import '../../../../core/widgets/kalpi_text_field.dart';
import '../../../../core/widgets/kalpi_top_bar.dart';
import '../../../../core/widgets/page_header.dart';
import '../../domain/strategy_validation.dart';
import '../cubit/strategy_list_cubit.dart';

/// Creates an independent copy of a strategy under a new name.
class DuplicateStrategyPage extends StatefulWidget {
  const DuplicateStrategyPage({super.key, required this.strategyId});

  final String strategyId;

  @override
  State<DuplicateStrategyPage> createState() => _DuplicateStrategyPageState();
}

class _DuplicateStrategyPageState extends State<DuplicateStrategyPage> {
  late final TextEditingController _name;
  final FocusNode _focus = FocusNode();
  String? _error;

  @override
  void initState() {
    super.initState();
    final source = context.read<StrategyListCubit>().state.byId(
      widget.strategyId,
    );
    _name = TextEditingController(
      text: source == null ? '' : AppStrings.copyName(source.name),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final cubit = context.read<StrategyListCubit>();
    final source = cubit.state.byId(widget.strategyId);
    if (source == null) return;
    final error = StrategyValidation.validateName(_name.text);
    if (error != null) {
      setState(() => _error = error);
      _focus.requestFocus();
      return;
    }
    setState(() => _error = null);
    final created = await cubit.duplicate(source, _name.text);
    if (created != null && mounted) context.go(AppRoutes.strategies);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StrategyListCubit, StrategyListState>(
      builder: (context, state) {
        final source = state.byId(widget.strategyId);
        return KalpiScaffold(
          body: Column(
            children: <Widget>[
              KalpiTopBar(
                title: AppStrings.duplicateStrategy,
                onBack: () => context.pop(),
              ),
              Expanded(
                child: ScrollableWithFooter(
                  footer: ActionFooter(
                    child: KalpiButton(
                      label: AppStrings.createCopy,
                      icon: KalpiIcons.copy,
                      busy: state.pendingDuplicate,
                      busyLabel: AppStrings.creatingCopy,
                      enabled: source != null,
                      onPressed: _create,
                    ),
                  ),
                  children: <Widget>[
                    const SizedBox(height: AppDimens.space40 - 1),
                    const PageHeader(
                      title: AppStrings.duplicateTitle,
                      subtitle: AppStrings.duplicateSubtitle,
                    ),
                    const SizedBox(height: AppDimens.space48 + 15),
                    Text(
                      AppStrings.newStrategyName,
                      style: KalpiTextStyles.fieldLabel,
                    ),
                    const SizedBox(height: AppDimens.space12 - 1),
                    KalpiTextField(
                      controller: _name,
                      focusNode: _focus,
                      height: AppDimens.fieldHeightTall,
                      textStyle: KalpiTextStyles.fieldValueMedium,
                      highlight: true,
                      maxLength: AppConfig.nameMaxLength,
                      errorText: _error ?? state.duplicateError,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                        if (state.duplicateError != null) {
                          context
                              .read<StrategyListCubit>()
                              .clearDuplicateError();
                        }
                      },
                      onSubmitted: (_) => _create(),
                    ),
                    const SizedBox(height: AppDimens.space32 + 6),
                    const InfoBanner(text: AppStrings.duplicateHint),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
