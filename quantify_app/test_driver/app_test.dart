// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:webdriver/io.dart';

void main() {
  group('Quantify App', () {
    // First, define the Finders aqnd use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

    final buttonFinder = find.byValueKey('getstarted');
    final donthave = find.byValueKey('donthaveanaccountyet');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Button from homescreen', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.

      await driver.tap(buttonFinder);
      //expect(await driver.getText(counterTextFinder), "1");
    });
    test('Test registration', () async {
      //  await driver.tap(buttonFinder);
      await driver.tap(donthave);
    });
    test('Test login', () async {
      //  await driver.tap(buttonFinder);
      await driver.tap(donthave);
    });
  });
}
