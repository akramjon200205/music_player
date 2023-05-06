import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main(List<String> args) async {
  final url = Uri.parse("https://easydownloader-p7jz.onrender.com/instagram/");
  File file = await File("${function(url)}");

  // print(file.path);
  file.writeAsBytesSync(await function(url));
}

function(Uri url) async {
  http.Response response = await http.post(
    url,
    body: json.encode(
      {
        "link": 'https://www.instagram.com/reel/Crq0ju_O349/?igshid=MDJmNzVkMjY=',
      },
    ),
  );
  return response;
}
