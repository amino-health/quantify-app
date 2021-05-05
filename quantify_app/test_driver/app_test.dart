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

    //final donthave = find.byValueKey('donthaveanaccountyet');

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

    test('Button from welcomescreen', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.

      await driver.tap(buttonFinder);
    });
    /*

    test('Dont have an account yet button', () async {
      var missningaccount = find.byValueKey('donthaveanaccountyet');
      await driver.tap(missningaccount);
    });

    test('Register test', () async {
      var inputName = find.byValueKey('inputName');
      await driver.tap(inputName);
      await driver.enterText('bob stiernborg');
      var inputEmail = find.byValueKey('inputEmail');
      await driver.tap(inputEmail);
      await driver.enterText('bob.stiernborg@gmail.com');
      var inputPassword = find.byValueKey('inputPassword');
      await driver.tap(inputPassword);
      await driver.enterText('lelle123');
      var inputPasswordAgain = find.byValueKey('inputPasswordAgain');
      await driver.tap(inputPasswordAgain);
      await driver.enterText('lelle123');
      var register = find.byValueKey('register');
      await driver.tap(register);
    });

    test('Button from welcomescreen', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.

      await driver.tap(buttonFinder);
    });
*/

    test('Input data', () async {
      var pickDate = find.byValueKey('pickDate');
      await driver.waitFor(pickDate);
      await driver.tap(pickDate);
      await driver.tap(find.text('18'));
      await driver.tap(find.text('OK'));
    });

    test('Input Weight', () async {
      var enterWeight = find.byValueKey('enterWeight');
      await driver.tap(enterWeight);
      await driver.enterText('80');
    });

    test('Input Height', () async {
      var enterHeight = find.byValueKey('enterHeight');
      await driver.tap(enterHeight);
      await driver.enterText('140');
    });

    test('Pick gender', () async {
      var pickGender = find.byValueKey('pickGender');
      await driver.tap(pickGender);
      await driver.waitFor(find.text('Female'));
      await driver.tap(find.text('Female'));
    });

    test('Confirm button', () async {
      var confirm = find.byValueKey('confirm');
      await driver.tap(confirm);
    });

    /*

    test('Input Height', () async {
      var enterHeight = find.byValueKey('enterHeight');
      await driver.tap(enterWeight);
      await driver.enterText('80');
    });


    test('Input email', () async {
      var email = find.byValueKey('emailfield');
      await driver.tap(email);
      await driver.enterText('bob.stiernborg@gmail.com');
      var pass = find.byValueKey('passfield');
      await driver.tap(pass);
      await driver.enterText('lelle123');
      //expect(await driver.getText(counterTextFinder), "1");
    });

*/
    /*
    
    test('Test registration', () async {
      //  await driver.tap(buttonFinder);
     // await driver.tap(donthave);
    });
    test('Test login', () async {
      
      //  await driver.tap(buttonFinder);
      //await driver.tap(donthave);
    });
     */
  });
}
