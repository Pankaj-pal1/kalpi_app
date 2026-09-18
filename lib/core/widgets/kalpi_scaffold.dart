import 'package:flutter/material.dart';

import '../constants/app_dimens.dart';
import '../theme/kalpi_colors.dart';

/// App shell: dark background, safe areas, an optional bottom bar and a
/// centred reading column on wide screens.
class KalpiScaffold extends StatelessWidget {
  const KalpiScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.footer,
    this.resizeToAvoidBottomInset = true,
    this.applyTopSafeArea = true,
  });

  final Widget body;
  final Widget? bottomNavigationBar;

  /// Pinned above the bottom safe area, e.g. a primary action.
  final Widget? footer;
  final bool resizeToAvoidBottomInset;
  final bool applyTopSafeArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KalpiColors.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        top: applyTopSafeArea,
        bottom: bottomNavigationBar == null,
        child: KalpiReadingColumn(
          child: footer == null
              ? body
              : Column(
                  children: <Widget>[
                    Expanded(child: body),
                    footer!,
                  ],
                ),
        ),
      ),
    );
  }
}

/// Constrains content to a comfortable width on tablets and desktops.
class KalpiReadingColumn extends StatelessWidget {
  const KalpiReadingColumn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppDimens.maxContentWidth),
      child: child,
    ),
  );
}

/// Standard horizontal page padding.
class PagePadding extends StatelessWidget {
  const PagePadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppDimens.gutter),
    child: child,
  );
}

/// A scrollable page body with a pinned primary action underneath.
///
/// Content scrolls naturally; the footer stays reachable even with the
/// keyboard open because it sits outside the scroll view.
class ScrollableWithFooter extends StatelessWidget {
  const ScrollableWithFooter({
    super.key,
    required this.children,
    required this.footer,
    this.controller,
    this.padding = const EdgeInsets.fromLTRB(
      AppDimens.gutter,
      0,
      AppDimens.gutter,
      AppDimens.space24,
    ),
  });

  final List<Widget> children;
  final Widget footer;
  final ScrollController? controller;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Expanded(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView(
            controller: controller,
            padding: padding,
            children: children,
          ),
        ),
      ),
      footer,
    ],
  );
}

/// Footer wrapper: gutter padding plus bottom spacing above the safe area.
class ActionFooter extends StatelessWidget {
  const ActionFooter({super.key, required this.child, this.caption});

  final Widget child;

  /// Optional helper text shown under the action.
  final Widget? caption;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppDimens.gutter,
      AppDimens.space12,
      AppDimens.gutter,
      AppDimens.space12,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        if (caption != null) ...<Widget>[
          const SizedBox(height: AppDimens.space16),
          caption!,
        ],
      ],
    ),
  );
}
