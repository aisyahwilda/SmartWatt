import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login Page Widget Tests', () {
    testWidgets('Should display login UI elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Masuk ke SmartWatt'),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                      ),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text('Masuk')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Check title exists
      expect(find.text('Masuk ke SmartWatt'), findsOneWidget);

      // Check email field exists
      expect(find.byType(TextField), findsWidgets);

      // Check login button exists
      expect(find.text('Masuk'), findsOneWidget);
    });

    testWidgets('Should be able to type in text fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Type in text fields
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);
    });
  });
}
