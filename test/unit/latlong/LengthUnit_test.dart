import 'package:latlong/latlong.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('LengthUnit', () {
    setUp(() {});

    test('> Millimeter', () {
      expect(LengthUnit.Millimeter.to(LengthUnit.Millimeter, 1.0), 1.0);
      expect(LengthUnit.Millimeter.to(LengthUnit.Centimeter, 1.0), 0.1);
      expect(LengthUnit.Millimeter.to(LengthUnit.Meter, 1000.0), 1.0);
      expect(LengthUnit.Millimeter.to(LengthUnit.Kilometer, 1000000.0), 1);
    });
    test('> Centimeter', () {
      expect(LengthUnit.Centimeter.to(LengthUnit.Centimeter, 1.0), 1.0);
      expect(LengthUnit.Centimeter.to(LengthUnit.Millimeter, 1.0), 10.0);
    });

    test('> Meter', () {
      expect(LengthUnit.Meter.to(LengthUnit.Meter, 100.0), 100.0);
      expect(LengthUnit.Meter.to(LengthUnit.Kilometer, 1.0), 0.001);
    });

    test('> Kilometer', () {
      expect(LengthUnit.Kilometer.to(LengthUnit.Kilometer, 1.0), 1.0);
      expect(LengthUnit.Kilometer.to(LengthUnit.Meter, 1.0), 1000.0);
    });

    test('> Mike', () {
      expect((LengthUnit.Mile.to(LengthUnit.Meter, 1.0) * 100).round() / 100,
          1609.34);
    });
  });
}
