import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test utilities for common test operations
class TestUtils {
  /// Creates a test MaterialApp wrapper
  static Widget createTestApp({required Widget child, ThemeData? theme}) {
    return MaterialApp(home: child, theme: theme);
  }

  /// Creates a test MaterialApp with BlocProvider
  static Widget createTestAppWithBloc<T extends BlocBase<S>, S>({
    required T bloc,
    required Widget child,
    ThemeData? theme,
  }) {
    return MaterialApp(
      home: BlocProvider<T>(create: (context) => bloc, child: child),
      theme: theme,
    );
  }

  /// Creates a test MaterialApp with multiple BlocProviders
  static Widget createTestAppWithBlocs({
    required List<BlocProvider> providers,
    required Widget child,
    ThemeData? theme,
  }) {
    return MaterialApp(
      home: MultiBlocProvider(providers: providers, child: child),
      theme: theme,
    );
  }

  /// Helper to pump widget with pumpAndSettle
  static Future<void> pumpWidget(
    WidgetTester tester,
    Widget widget, {
    Duration? duration,
  }) async {
    await tester.pumpWidget(widget);
    if (duration != null) {
      await tester.pump(duration);
    } else {
      await tester.pumpAndSettle();
    }
  }

  /// Helper to find text in widget tree
  static Finder findText(String text) {
    return find.text(text);
  }

  /// Helper to find widget by type
  static Finder findWidgetByType(Type type) {
    return find.byType(type);
  }

  /// Helper to find widget by key
  static Finder findWidgetByKey(Key key) {
    return find.byKey(key);
  }

  /// Helper to find icon
  static Finder findIcon(IconData icon) {
    return find.byIcon(icon);
  }

  /// Helper to find button
  static Finder findButton(String text) {
    return find.widgetWithText(ElevatedButton, text);
  }

  /// Helper to find icon button
  static Finder findIconButton(IconData icon) {
    return find.widgetWithIcon(IconButton, icon);
  }

  /// Helper to find card
  static Finder findCard() {
    return find.byType(Card);
  }

  /// Helper to find list tile
  static Finder findListTile() {
    return find.byType(ListTile);
  }

  /// Helper to find app bar
  static Finder findAppBar() {
    return find.byType(AppBar);
  }

  /// Helper to find scaffold
  static Finder findScaffold() {
    return find.byType(Scaffold);
  }

  /// Helper to find circular progress indicator
  static Finder findCircularProgressIndicator() {
    return find.byType(CircularProgressIndicator);
  }

  /// Helper to find error text
  static Finder findErrorText() {
    return find.byType(Text);
  }

  /// Helper to find refresh button
  static Finder findRefreshButton() {
    return findIconButton(Icons.refresh);
  }

  /// Helper to find theme toggle button
  static Finder findThemeToggleButton() {
    return findIconButton(Icons.dark_mode);
  }

  /// Helper to find light mode icon
  static Finder findLightModeIcon() {
    return findIconButton(Icons.light_mode);
  }

  /// Helper to find system theme icon
  static Finder findSystemThemeIcon() {
    return findIconButton(Icons.settings_system_daydream);
  }
}
