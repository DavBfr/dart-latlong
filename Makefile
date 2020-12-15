# Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied. See the License for the specific language
# governing permissions and limitations under the License.

DART_SRC=$(shell find . -name '*.dart')

all: format

format: format-dart

format-dart: $(DART_SRC)
	dartfmt -w --fix $^

clean:
	git clean -fdx -e .vscode

test:
	dart pub get
	dart pub run test --coverage=.coverage
	dart pub global run coverage:format_coverage --packages=.packages -i .coverage --report-on lib --lcov --out lcov.info

publish: format analyze clean
	test -z "$(shell git status --porcelain)"
	find . -name pubspec.yaml -exec sed -i -e 's/^dependency_overrides:/_dependency_overrides:/g' '{}' ';'
	pub publish -f
	find . -name pubspec.yaml -exec sed -i -e 's/^_dependency_overrides:/dependency_overrides:/g' '{}' ';'
	git tag $(shell grep version pubspec.yaml | sed 's/version\s*:\s*/v/g')

.pana:
	dart pub global activate pana
	touch $@

fix: $(DART_SRC)
	dart fix --apply

analyze: $(DART_SRC)
	flutter analyze --suppress-analytics

pana: .pana
	dart pub global run pana --no-warning --source path .

.PHONY: format format-dart clean publish test fix analyze
