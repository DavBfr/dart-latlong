import 'package:latlong/spline.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('CatmullRom 1D', () {
    setUp(() {});

    test('> one dimension', () {
      const spline = CatmullRomSpline(1, 2, 2, 1);

      expect(spline.position(0.25), 2.09375);
      expect(spline.position(0.5), 2.125);
      expect(spline.position(0.75), 2.09375);
    });

    test('> no endpoints', () {
      const spline = CatmullRomSpline.noEndpoints(1, 2);

      expect(spline.position(0.25), 1.203125);
      expect(spline.position(0.5), 1.5);
      expect(spline.percentage(50), 1.5);

      expect(spline.position(0.75), 1.796875);
    });
  });

  group('CatmullRom 2D', () {
    test('> Simple values', () {
      final spline = CatmullRomSpline2D(
          Point2D(1, 1), Point2D(2, 2), Point2D(2, 2), Point2D(1, 1));

      expect(spline.position(0.25).x, 2.09375);
      expect(spline.position(0.25).y, 2.09375);

      expect(spline.position(0.5).x, 2.125);
      expect(spline.position(0.5).y, 2.125);
      expect(spline.percentage(50).x, 2.125);
      expect(spline.percentage(50).y, 2.125);

      expect(spline.position(0.75).x, 2.09375);
      expect(spline.position(0.75).y, 2.09375);
    });

    test('> no Endpoints', () {
      final spline =
          CatmullRomSpline2D.noEndpoints(Point2D(1, 1), Point2D(2, 2));

      expect(spline.position(0.25).x, 1.203125);
      expect(spline.position(0.25).y, 1.203125);
    });

    test('> Exception', () {
      final spline =
          CatmullRomSpline2D.noEndpoints(Point2D(1, 1), Point2D(2, 2));

      expect(() => spline.position(3.0).x, throwsA(isA<AssertionError>()));
    });
  });
}
