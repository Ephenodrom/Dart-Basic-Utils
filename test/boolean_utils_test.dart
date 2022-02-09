import 'package:basic_utils/src/BooleanUtils.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Test list and',
    () {
      test('GIVEN all true THEN true', () {
        final result = BooleanUtils.and([true, true]);
        expect(result, true);
      });

      test('GIVEN one false THEN false', () {
        final result = BooleanUtils.and([true, false]);
        expect(result, false);
      });

      test('GIVEN all false THEN false', () {
        final result = BooleanUtils.and([false, false]);
        expect(result, false);
      });

      test('GIVEN one false THEN false', () {
        final result = BooleanUtils.and([true, false, true]);
        expect(result, false);
      });
    },
  );

  group(
    'Test list or',
    () {
      test('GIVEN all true THEN true', () {
        final result = BooleanUtils.or([true, true]);
        expect(result, true);
      });

      test('GIVEN one false THEN true', () {
        final result = BooleanUtils.or([true, false]);
        expect(result, true);
      });

      test('GIVEN all false THEN false', () {
        final result = BooleanUtils.or([false, false]);
        expect(result, false);
      });

      test('GIVEN one false THEN true', () {
        final result = BooleanUtils.or([true, false, true]);
        expect(result, true);
      });
    },
  );

  group(
    'Test list xor',
    () {
      test('GIVEN all true THEN false', () {
        final result = BooleanUtils.xor([true, true]);
        expect(result, false);
      });

      test('GIVEN one false THEN true', () {
        final result = BooleanUtils.xor([true, false]);
        expect(result, true);
      });

      test('GIVEN all false THEN false', () {
        final result = BooleanUtils.xor([false, false]);
        expect(result, false);
      });

      test('GIVEN one false THEN true', () {
        final result = BooleanUtils.xor([true, false, true]);
        expect(result, false);
      });
    },
  );

  group('booleanValues', () {
    test('GIVEN nothing THEN boolean values', () {
      final result = BooleanUtils.booleanValues();
      expect(result, [false, true]);
    });
  });

  group('compare', () {
    test('GIVEN true and true THEN 0', () {
      final result = BooleanUtils.compare(true, true);
      expect(result, 0);
    });

    test('GIVEN false and false THEN 0', () {
      final result = BooleanUtils.compare(false, false);
      expect(result, 0);
    });

    test('GIVEN true and false THEN 1', () {
      final result = BooleanUtils.compare(true, false);
      expect(result, 1);
    });

    test('GIVEN false and true THEN -1', () {
      final result = BooleanUtils.compare(false, true);
      expect(result, -1);
    });
  });

  group('toBoolean', () {
    test('GIVEN 0 THEN boolean false', () {
      final result = BooleanUtils.toBoolean(0);
      expect(result, false);
    });

    test('GIVEN 1 THEN boolean false', () {
      final result = BooleanUtils.toBoolean(1);
      expect(result, true);
    });

    test('GIVEN 2 THEN boolean false', () {
      final result = BooleanUtils.toBoolean(2);
      expect(result, true);
    });

    test('GIVEN -1 THEN boolean false', () {
      final result = BooleanUtils.toBoolean(-1);
      expect(result, true);
    });
  });

  group('toBooleanObject', () {
    test('GIVEN "true" THEN true', () {
      final result = BooleanUtils.toBooleanObject('true');
      expect(result, true);
    });

    test('GIVEN "false" THEN false', () {
      final result = BooleanUtils.toBooleanObject('false');
      expect(result, false);
    });

    test('GIVEN "yes" THEN true', () {
      final result = BooleanUtils.toBooleanObject('yes');
      expect(result, true);
    });

    test('GIVEN "no" THEN false', () {
      final result = BooleanUtils.toBooleanObject('no');
      expect(result, false);
    });

    test('GIVEN "t" THEN true', () {
      final result = BooleanUtils.toBooleanObject('t');
      expect(result, true);
    });

    test('GIVEN "f" THEN false', () {
      final result = BooleanUtils.toBooleanObject('f');
      expect(result, false);
    });

    test('GIVEN "1" THEN true', () {
      final result = BooleanUtils.toBooleanObject('1');
      expect(result, true);
    });

    test('GIVEN "0" THEN false', () {
      final result = BooleanUtils.toBooleanObject('0');
      expect(result, false);
    });
  });

  group('toBooleanDefaultIfNull', () {
    test('GIVEN true and default false THEN true', () {
      final result = BooleanUtils.toBooleanDefaultIfNull(true, false);
      expect(result, true);
    });

    test('GIVEN true and default true THEN true', () {
      final result = BooleanUtils.toBooleanDefaultIfNull(true, true);
      expect(result, true);
    });

    test('GIVEN true and default false THEN true', () {
      final result = BooleanUtils.toBooleanDefaultIfNull(false, true);
      expect(result, false);
    });

    test('GIVEN false and default false THEN true', () {
      final result = BooleanUtils.toBooleanDefaultIfNull(false, false);
      expect(result, false);
    });

    test('GIVEN null and default true THEN true', () {
      final result = BooleanUtils.toBooleanDefaultIfNull(null, true);
      expect(result, true);
    });

    test('GIVEN null and default false THEN true', () {
      final result = BooleanUtils.toBooleanDefaultIfNull(null, false);
      expect(result, false);
    });
  });

  group('toInteger', () {
    test('GIVEN true THEN 1', () {
      final result = BooleanUtils.toInteger(true);
      expect(result, 1);
    });

    test('GIVEN false THEN 0', () {
      final result = BooleanUtils.toInteger(false);
      expect(result, 0);
    });
  });

  group('toBooleanString', () {
    test('GIVEN true THEN "true', () {
      final result = BooleanUtils.toBooleanString(true);
      expect(result, 'true');
    });

    test('GIVEN false THEN "false"', () {
      final result = BooleanUtils.toBooleanString(false);
      expect(result, 'false');
    });
  });
}
