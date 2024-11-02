import 'package:latlong/latlong.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('LengthUnit', () {
    setUp(() {});

    test('> Millimeter', () {
      expect(LengthUnit.millimeter.to(LengthUnit.millimeter, 1.0), 1.0);
      expect(LengthUnit.millimeter.to(LengthUnit.centimeter, 1.0), 0.1);
      expect(LengthUnit.millimeter.to(LengthUnit.meter, 1000.0), 1.0);
      expect(LengthUnit.millimeter.to(LengthUnit.kilometer, 1000000.0), 1);
    });
    test('> Centimeter', () {
      expect(LengthUnit.centimeter.to(LengthUnit.centimeter, 1.0), 1.0);
      expect(LengthUnit.centimeter.to(LengthUnit.millimeter, 1.0), 10.0);
    });

    test('> Meter', () {
      expect(LengthUnit.meter.to(LengthUnit.meter, 100.0), 100.0);
      expect(LengthUnit.meter.to(LengthUnit.kilometer, 1.0), 0.001);
    });

    test('> Kilometer', () {
      expect(LengthUnit.kilometer.to(LengthUnit.kilometer, 1.0), 1.0);
      expect(LengthUnit.kilometer.to(LengthUnit.meter, 1.0), 1000.0);
    });

    test('> Mike', () {
      expect((LengthUnit.mile.to(LengthUnit.meter, 1.0) * 100).round() / 100,
          1609.34);
    });
  });
}
