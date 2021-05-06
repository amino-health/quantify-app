// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Quantify App', () {
    // First, define the Finders aqnd use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

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
      var buttonFinder = find.byValueKey('getstarted');
      await driver.tap(buttonFinder);
    });

    test('Dont have an account yet button', () async {
      var missningaccount = find.byValueKey('donthaveanaccountyet');
      await driver.tap(missningaccount);
    });

    test('Register input name', () async {
      var inputName = find.byValueKey('inputName');
      await driver.tap(inputName);
      await driver.enterText('bob stiernborg');
    });

    test('Register input email', () async {
      var inputEmail = find.byValueKey('inputEmail');
      await driver.tap(inputEmail);
      await driver.enterText('bob.stiernborg@gmail.com');
    });

    test('Register input password', () async {
      var inputPassword = find.byValueKey('inputPassword');
      await driver.tap(inputPassword);
      await driver.enterText('lelle123');
    });

    test('Register input password again', () async {
      var inputPasswordAgain = find.byValueKey('inputPasswordAgain');
      await driver.tap(inputPasswordAgain);
      await driver.enterText('lelle123');
    });

    test('Register button', () async {
      var register = find.byValueKey('register');
      await driver.tap(register);
    });

    test('Input date of birth', () async {
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

    test('Terms and condition screen', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      var tos = find.byValueKey('tos');
      await driver.tap(tos);
      var continueButton = find.byValueKey('continue');
      await driver.tap(continueButton);
    });

    test('Go to profile page', () async {
      var profile = find.text('Profile');
      await driver.tap(profile);
    });

    test('Sign out', () async {
      var signout = find.text('Sign out');
      await driver.tap(signout);
    });

    test('Input email in log in', () async {
      var email = find.byValueKey('emailfield');
      await driver.tap(email);
      await driver.enterText('bob.stiernborg@gmail.com');
    });

    test('Test enter password', () async {
      var pass = find.byValueKey('passfield');
      await driver.tap(pass);
      await driver.enterText('lelle123');
    });

    test('Test log in', () async {
      var signIn = find.byValueKey('signIn');
      await driver.tap(signIn);
    });
  });
}
