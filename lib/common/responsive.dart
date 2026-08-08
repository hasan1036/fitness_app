import 'package:flutter/material.dart';

/// Small dependency-free responsive helpers for this project.
///
/// Design reference width: 390 logical pixels.
/// Values are clamped so the UI does not become extremely small or large.
class AppResponsive {
  AppResponsive._();

  static double widthScale(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return (width / 390.0).clamp(0.82, 1.12);
  }

  static double heightScale(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return (height / 844.0).clamp(0.85, 1.10);
  }

  static double size(BuildContext context, double value) {
    return value * widthScale(context);
  }

  static double height(BuildContext context, double value) {
    return value * heightScale(context);
  }

  static double font(BuildContext context, double value) {
    final double scale = widthScale(context).clamp(0.90, 1.08);
    return value * scale;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    if (width < 350) {
      return const EdgeInsets.symmetric(horizontal: 14);
    }
    if (width >= 600) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 360;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;
}

/// Keeps very large accessibility/system font settings from breaking compact
/// cards while still allowing useful text scaling.
class ResponsiveMediaQuery extends StatelessWidget {
  const ResponsiveMediaQuery({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double scale = media.textScaler.scale(1).clamp(0.90, 1.20);

    return MediaQuery(
      data: media.copyWith(
        textScaler: TextScaler.linear(scale),
      ),
      child: child,
    );
  }
}

/// Centers the phone layout on tablets/desktop without stretching cards
/// across the entire screen.
class ResponsivePageWidth extends StatelessWidget {
  const ResponsivePageWidth({
    super.key,
    required this.child,
    this.maxWidth = 620,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
