import 'package:flutter_test/flutter_test.dart';
import 'package:anandham_core/anandham_core.dart';

void main() {
  group('Validators', () {
    test('validates email correctly', () {
      expect(Validators.email('test@example.com'), null);
      expect(Validators.email('invalid-email'), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('validates phone correctly', () {
      expect(Validators.phone('+919876543210'), null);
      expect(Validators.phone('123'), isNotNull);
    });

    test('validates required fields', () {
      expect(Validators.required('hello'), null);
      expect(Validators.required(''), isNotNull);
      expect(Validators.required(null), isNotNull);
    });
  });

  group('StringExtensions', () {
    test('capitalised works correctly', () {
      expect('hello'.capitalised, 'Hello');
      expect(''.capitalised, '');
    });

    test('titleCase works correctly', () {
      expect('hello world'.titleCase, 'Hello World');
    });

    test('isValidEmail works correctly', () {
      expect('test@example.com'.isValidEmail, true);
      expect('invalid'.isValidEmail, false);
    });
  });
}
