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

import 'package:latlong/latlong.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('> Range', () {
      expect(() => LatLng(-80.0, 0.0), returnsNormally);
      expect(() => LatLng(-100.0, 0.0), throwsArgumentError);
      expect(() => LatLng(80.0, 0.0), returnsNormally);
      expect(() => LatLng(100.0, 0.0), throwsArgumentError);
      expect(() => LatLng(0.0, -170.0), returnsNormally);
      expect(() => LatLng(0.0, -190.0), throwsArgumentError);
      expect(() => LatLng(0.0, 170.0), returnsNormally);
      expect(() => LatLng(0.0, 190.0), throwsArgumentError);
    });

    test('> Rad', () {
      expect(LatLng(-80.0, 0.0).latitudeInRad, -1.3962634015954636);
      expect(LatLng(90.0, 0.0).latitudeInRad, 1.5707963267948966);
      expect(LatLng(0.0, 80.0).longitudeInRad, 1.3962634015954636);
      expect(LatLng(0.0, 90.0).longitudeInRad, 1.5707963267948966);
    });

    test('> toString', () {
      expect(LatLng(-80.0, 0.0).toString(),
          'LatLng(latitude:-80.0, longitude:0.0)');
      expect(LatLng(-80.123456, 0.0).toString(),
          'LatLng(latitude:-80.123456, longitude:0.0)');
    });

    test('> equal', () {
      expect(LatLng(-80.0, 0.0), LatLng(-80.0, 0.0));
      expect(LatLng(-80.0, 0.0), isNot(LatLng(-80.1, 0.0)));
      expect(LatLng(-80.0, 0.0), isNot(LatLng(0.0, 80.0)));
    });
  });
}
