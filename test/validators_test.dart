import 'package:flutter_test/flutter_test.dart';
import 'package:ultimate_task/misc/email_validator.dart';

void main() {
  group("validations", () {
    test('non empty string', () {
      final validator = NonEmptyStringValidator();
      expect(validator.isValid('test'), true);
    });

    test('empty string', () {
      final validator = NonEmptyStringValidator();
      expect(validator.isValid(''), false);
    });

    test('null string', () {
      final validator = NonEmptyStringValidator();
      expect(validator.isValid(null), false);
    });
  });
}
