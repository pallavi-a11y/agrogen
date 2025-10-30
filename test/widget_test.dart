// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:agrogen/main.dart';
import 'package:agrogen/app_state.dart';
import 'package:agrogen/screens/crop_details_screen.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Create a mock AppState
    final appState = AppState();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(appState: appState));

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('CropDetailsScreen displays correctly with null-safe fields', (
    WidgetTester tester,
  ) async {
    final appState = AppState();
    // Mock current crops with null values
    appState.currentCrops = [
      {
        'name': 'Tomato',
        'planted_date': null,
        'expected_harvest': null,
        'area': 2.5,
        'image': null,
        'status': 'Growing',
        'health': 'Good',
      },
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: appState,
          child: const CropDetailsScreen(),
        ),
      ),
    );

    // Verify the screen title
    expect(find.text('Crop Details'), findsOneWidget);

    // Verify crop name is displayed
    expect(find.text('Tomato'), findsOneWidget);

    // Verify null-safe fields show 'N/A'
    expect(find.text('Planted: N/A'), findsOneWidget);
    expect(find.text('Harvest: N/A'), findsOneWidget);

    // Verify area is displayed
    expect(find.text('Area: 2.5'), findsOneWidget);

    // Verify status and health
    expect(find.text('Growing'), findsOneWidget);
    expect(find.text('Good'), findsOneWidget);
  });

  testWidgets('Floating action button opens add crop dialog', (
    WidgetTester tester,
  ) async {
    final appState = AppState();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: appState,
          child: const CropDetailsScreen(),
        ),
      ),
    );

    // Find and tap the floating action button
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Verify dialog is shown
    expect(find.text('Add New Crop'), findsOneWidget);
    expect(find.text('Crop Name'), findsOneWidget);
    expect(find.text('Planted Date'), findsOneWidget);
    expect(find.text('Area (acres)'), findsOneWidget);
    expect(find.text('Expected Harvest'), findsOneWidget);
  });
}
