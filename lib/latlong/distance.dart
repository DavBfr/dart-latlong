/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:math' as math;

import '../latlong.dart';
import 'calculator/haversine.dart';
import 'calculator/vincenty.dart';
import 'interfaces.dart';
import 'lat_lng.dart';
import 'length_unit.dart';

/// Calculates the distance between points.
///
/// Default algorithm is [distanceWithVincenty], default radius is [EARTH_RADIUS]
///
///      final Distance distance = new Distance();
///
///      // km = 423
///      final int km = distance.as(LengthUnit.Kilometer,
///         new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));
///
///      // meter = 422592
///      final int meter = distance(new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));
///
class Distance implements DistanceCalculator {
  const Distance({final DistanceCalculator calculator = const Vincenty()})
      : _radius = EARTH_RADIUS,
        _calculator = calculator;

  const Distance.withRadius(
    final double radius, {
    final DistanceCalculator calculator = const Vincenty(),
  })  : _radius = radius,
        _calculator = calculator,
        assert(radius > 0, 'Radius must be greater than 0 but was $radius');

  final double _radius;

  final DistanceCalculator _calculator;

  double get radius => _radius;

  /// Returns either [Haversine] oder [Vincenty] calculator
  ///
  ///     final Distance distance = const DistanceHaversine();
  ///     final Circle circle = new Circle(base, 1000.0,calculator: distance.calculator);
  ///
  DistanceCalculator get calculator => _calculator;

  /// Shortcut for [distance]
  double call(final LatLng p1, final LatLng p2) {
    return distance(p1, p2);
  }

  /// Converts the distance to the given [LengthUnit]
  ///
  ///     final int km = distance.as(LengthUnit.Kilometer,
  ///         new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));
  ///
  double as(final LengthUnit unit, final LatLng p1, final LatLng p2) {
    final dist = _calculator.distance(p1, p2);
    return LengthUnit.Meter.to(unit, dist);
  }

  /// Computes the distance between two points.
  ///
  /// The function uses the [DistanceAlgorithm] specified in the CTOR
  @override
  double distance(final LatLng p1, final LatLng p2) =>
      _calculator.distance(p1, p2);

  /// Returns the great circle bearing (direction) in degrees to the next point ([p2])
  ///
  /// Find out about the difference between rhumb line and
  /// great circle bearing on [Wikipedia](http://en.wikipedia.org/wiki/Rhumb_line#General_and_mathematical_description).
  ///
  ///     final Distance distance = const Distance();
  ///
  ///     final LatLng p1 = new LatLng(0.0, 0.0);
  ///     final LatLng p2 = new LatLng(-90.0, 0.0);
  ///
  ///     expect(distance.direction(p1, p2), equals(180));
  double bearing(final LatLng p1, final LatLng p2) {
    final diffLongitude = p2.longitudeInRad - p1.longitudeInRad;

    final y = math.sin(diffLongitude);
    final x = math.cos(p1.latitudeInRad) * math.tan(p2.latitudeInRad) -
        math.sin(p1.latitudeInRad) * math.cos(diffLongitude);

    return radianToDeg(math.atan2(y, x));
  }

  /// Returns a destination point based on the given [distance] and [bearing]
  ///
  /// Given a [from] (start) point, initial [bearing], and [distance],
  /// this will calculate the destination point and
  /// final bearing travelling along a (shortest distance) great circle arc.
  ///
  ///     final Distance distance = const Distance();
  ///
  ///     final double distanceInMeter = (EARTH_RADIUS * math.PI / 4).round();
  ///
  ///     final p1 = new LatLng(0.0, 0.0);
  ///     final p2 = distance.offset(p1, distanceInMeter, 180);
  ///
  /// Bearing: Left - 270°, right - 90°, up - 0°, down - 180°
  @override
  LatLng offset(
    final LatLng from,
    final double distanceInMeter,
    final double bearing,
  ) =>
      _calculator.offset(from, distanceInMeter, bearing);
}

/// Shortcut for
///     final Distance distance = const Distance(calculator: const Vincenty());
///
class DistanceVincenty extends Distance {
  const DistanceVincenty() : super(calculator: const Vincenty());

  const DistanceVincenty.withRadius(
    final double radius,
  )   : assert(radius > 0, 'Radius must be greater than 0 but was $radius'),
        super.withRadius(radius, calculator: const Vincenty());
}

/// Shortcut for
///     final Distance distance = const Distance(calculator: const Haversine());
///
class DistanceHaversine extends Distance {
  const DistanceHaversine() : super(calculator: const Haversine());

  const DistanceHaversine.withRadius(
    final double radius,
  )   : assert(radius > 0, 'Radius must be greater than 0 but was $radius'),
        super.withRadius(radius, calculator: const Haversine());
}
