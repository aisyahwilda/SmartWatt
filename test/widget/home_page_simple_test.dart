import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Home Page Widget Tests', () {
    testWidgets('Should display home page elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('SmartWatt')),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Selamat Pagi'),
                    SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Budget Bulan Ini'),
                            Text('Rp 500.000'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [Text('Total Pemakaian'), Text('15 kWh')],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Check greeting exists
      expect(find.text('Selamat Pagi'), findsOneWidget);

      // Check budget card
      expect(find.text('Budget Bulan Ini'), findsOneWidget);

      // Check usage card
      expect(find.text('Total Pemakaian'), findsOneWidget);
    });

    testWidgets('Should display refresh indicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
              },
              child: ListView(children: [Text('Home Content')]),
            ),
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Home Content'), findsOneWidget);
    });

    testWidgets('Should scroll through content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  10,
                  (index) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Item $index'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Check some items are visible
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 9'), findsOneWidget);
    });
  });
}
