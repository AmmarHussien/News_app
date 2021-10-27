
import 'package:news_app/shared/network/local/cashe_helper.dart';

import 'componanets.dart';

void printFullText(String text)
{
  final pattern = RegExp('.(1,800)');
  pattern.allMatches(text).forEach((element) {
    print(element.group(0));
  });
}

String token = '';