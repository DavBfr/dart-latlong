import 'package:latlong/latlong.dart';
import 'package:test/test.dart';

void main() {
  group('Distance', () {
    setUp(() {});

    test('> Radius', () {
      expect(const Distance().radius, EARTH_RADIUS);
      expect(Distance.withRadius(100.0).radius, 100.0);
    });

    test('> Distance to the same point is 0', () {
      const compute = Distance();
      final p = LatLng(0.0, 0.0);

      expect(compute.distance(p, p), equals(0));
    });

    test('> Distance between 0 and 90.0 is around 10.000km', () {
      const distance = Distance();
      final p1 = LatLng(0.0, 0.0);
      final p2 = LatLng(90.0, 0.0);

      // no rounding
      expect(distance(p1, p2) ~/ 1000, equals(10001));

      expect(
          LengthUnit.Meter.to(LengthUnit.Kilometer, distance(p1, p2)).round(),
          equals(10002));

      // rounds to 10002
      expect(distance.as(LengthUnit.Kilometer, p1, p2), equals(10002));
      expect(distance.as(LengthUnit.Meter, p1, p2), equals(10001966));
    });

    test('> Distance between 0 and 90.0 is 10001.96572931165 km ', () {
      const distance = Distance(roundResult: false);
      final p1 = LatLng(0.0, 0.0);
      final p2 = LatLng(90.0, 0.0);

      expect(
          distance.as(LengthUnit.Kilometer, p1, p2), equals(10001.96572931165));
    });

    test('> distance between 0,-180 and 0,180 is 0', () {
      const distance = Distance();
      final p1 = LatLng(0.0, -180.0);
      final p2 = LatLng(0.0, 180.0);

      expect(distance(p1, p2), 0);
    });

    group('Vincenty', () {
      test('> Test 1', () {
        const distance = Distance();

        expect(
            distance(
                LatLng(52.518611, 13.408056), LatLng(51.519475, 7.46694444)),
            422592);

        expect(
            distance.as(LengthUnit.Kilometer, LatLng(52.518611, 13.408056),
                LatLng(51.519475, 7.46694444)),
            423);
      });
    });

    group('Haversine - not so accurate', () {
      test('> Test 1', () {
        const distance = Distance(calculator: Haversine());

        expect(
            distance(
                LatLng(52.518611, 13.408056), LatLng(51.519475, 7.46694444)),
            421786.0);
      });
    });
  });

  group('Bearing', () {
    test('bearing to the same point is 0 degree', () {
      const distance = Distance();
      final p = LatLng(0.0, 0.0);
      expect(distance.bearing(p, p), equals(0));
    });

    test('bearing between 0,0 and 90,0 is 0 degree', () {
      const distance = Distance();
      final p1 = LatLng(0.0, 0.0);
      final p2 = LatLng(90.0, 0.0);
      expect(distance.bearing(p1, p2), equals(0));
    });

    test('bearing between 0,0 and -90,0 is 180 degree', () {
      const distance = Distance();
      final p1 = LatLng(0.0, 0.0);
      final p2 = LatLng(-90.0, 0.0);
      expect(distance.bearing(p1, p2), equals(180));
    });

    test('bearing between 0,-90 and 0,90 is -90 degree', () {
      const distance = Distance();
      final p1 = LatLng(0.0, -90.0);
      final p2 = LatLng(0.0, 90.0);
      expect(distance.bearing(p1, p2), equals(90));
    });

    test('bearing between 0,-180 and 0,180 is -90 degree', () {
      const distance = Distance();
      final p1 = LatLng(0.0, -180.0);
      final p2 = LatLng(0.0, 180.0);

      expect(distance.bearing(p1, p2), equals(-90));
      expect(normalizeBearing(distance.bearing(p1, p2)), equals(270));
    });
  });

  group('Offset', () {
    test('offset from 0,0 with bearing 0 and distance 10018.754 km is 90,180',
        () {
      const distance = Distance();

      final num distanceInMeter = (EARTH_RADIUS * PI / 2).round();
      //print("Dist $distanceInMeter");

      final p1 = LatLng(0.0, 0.0);
      final p2 = distance.offset(p1, distanceInMeter.round(), 0);

      //print(p2);
      //print("${decimal2sexagesimal(p2.latitude)} / ${decimal2sexagesimal(p2.longitude)}");

      expect(p2.latitude.round(), equals(90));
      expect(p2.longitude.round(), equals(180));
    });

    test('offset from 0,0 with bearing 180 and distance ~ 5.000 km is -45,0',
        () {
      const distance = Distance();
      final num distanceInMeter = (EARTH_RADIUS * PI / 4).round();

      final p1 = LatLng(0.0, 0.0);
      final p2 = distance.offset(p1, distanceInMeter, 180);

      // print(p2.round());
      // print(p2.toSexagesimal());

      expect(p2.latitude.round(), equals(-45));
      expect(p2.longitude.round(), equals(0));
    });

    test('offset from 0,0 with bearing 180 and distance ~ 10.000 km is -90,180',
        () {
      const distance = Distance();
      final num distanceInMeter = (EARTH_RADIUS * PI / 2).round();

      final p1 = LatLng(0.0, 0.0);
      final p2 = distance.offset(p1, distanceInMeter, 180);

      expect(p2.latitude.round(), equals(-90));
      expect(p2.longitude.round(), equals(180)); // 0 Vincenty
    });

    test('offset from 0,0 with bearing 90 and distance ~ 5.000 km is 0,45', () {
      const distance = Distance();
      final num distanceInMeter = (EARTH_RADIUS * PI / 4).round();

      final p1 = LatLng(0.0, 0.0);
      final p2 = distance.offset(p1, distanceInMeter, 90);

      expect(p2.latitude.round(), equals(0));
      expect(p2.longitude.round(), equals(45));
    });
  });
}