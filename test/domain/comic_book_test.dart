import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/domain/comic_book.dart';

import '../util/test_util.dart';

void main() {
  group("comic_book_test", () {
    test("test_parse_list_from_json", () async {
      var jsonContent = await TestUtil.loadFile("comic_books_js_result.json");

      var list = ComicBook.fromJsonList(jsonContent);

      expect(list, isNotEmpty);
    });
  });
}
