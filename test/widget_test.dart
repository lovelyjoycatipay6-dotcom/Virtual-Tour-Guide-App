import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_tour_guide_app/main.dart';
import 'package:virtual_tour_guide_app/models/trip.dart';
import 'package:virtual_tour_guide_app/services/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('home shows YGUIDE discovery and navigation', (tester) async {
    final state = await AppState.load();
    await tester.pumpWidget(YGuideApp(state: state));
    await tester.pump();

    await tester.enterText(
      find.byKey(const ValueKey('auth-email')),
      'alex@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password')),
      'password123',
    );
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('YGUIDE'), findsOneWidget);
    expect(find.text('Popular destinations'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Trips'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
  });

  testWidgets('search opens from the home discovery field', (tester) async {
    final state = await AppState.load();
    await tester.pumpWidget(YGuideApp(state: state));
    await tester.pump();

    await tester.enterText(
      find.byKey(const ValueKey('auth-email')),
      'alex@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password')),
      'password123',
    );
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Search places, cities...'));
    await tester.pumpAndSettle();

    expect(find.text('Explore places'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });

  testWidgets('preview registration and logout return to sign in', (
    tester,
  ) async {
    final state = await AppState.load();
    await tester.pumpWidget(YGuideApp(state: state));
    await tester.pump();

    await tester.ensureVisible(find.text('New here? Create an account'));
    await tester.tap(find.text('New here? Create an account'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('auth-name')),
      'Taylor Traveler',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-email')),
      'taylor@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password')),
      'password123',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-confirm-password')),
      'password123',
    );
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Hello, Taylor 👋'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out').last);
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(
      find.text(
        'Preview mode: authentication is not connected. No password is stored or verified.',
      ),
      findsOneWidget,
    );
  });

  test('saved destinations and trips persist locally', () async {
    final state = await AppState.load();
    await state.toggleSaved('tokyo');
    await state.saveTrip(
      Trip(
        id: 'trip-1',
        destinationId: 'tokyo',
        startingPoint: 'Central, Quezon City',
        startDate: DateTime(2026, 7, 8),
        endDate: DateTime(2026, 7, 12),
        status: 'upcoming',
      ),
    );

    final reopenedState = await AppState.load();
    expect(reopenedState.isSaved('tokyo'), isTrue);
    expect(reopenedState.trips, hasLength(1));
    expect(reopenedState.trips.single.startingPoint, 'Central, Quezon City');
  });
}
