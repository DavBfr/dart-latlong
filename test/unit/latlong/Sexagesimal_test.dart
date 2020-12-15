import 'package:latlong/latlong.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('Sexagesimal', () {
    setUp(() {});

    test('> decimal2sexagesimal', () {
      final sexa1 = decimal2sexagesimal(51.519475);
      final sexa2 = decimal2sexagesimal(-19.37555556);
      final sexa3 = decimal2sexagesimal(50.0);

      expect(sexa1, '51° 31\' 10.11"');
      expect(sexa2, '19° 22\' 32.00"');
      expect(sexa3, '50° 0\' 0.00"');

      final p1 = LatLng(51.519475, -19.37555556);
      expect(p1.toSexagesimal(), '51° 31\' 10.11" N, 19° 22\' 32.00" W');
    });
  });
}
