import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/domain/comic_section.dart';

import '../util/test_util.dart';

void main() {
  group("comic_section_test", () {
    test("test_parse_section", () async {
      var jsonContent =
          await TestUtil.loadFile("comic_sections_js_result.json");

      var list = ComicSection.fromJsonString(jsonContent);

      expect(list, isNotNull);
      expect(list.name, isNotEmpty);
      expect(list.sections, isNotEmpty);
    });
  });
}
