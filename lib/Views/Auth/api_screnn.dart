import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiScreen {
  Future(String username, password) async {
    Response response = await http.post(
      Uri.parse('http://58.65.169.108:999/MobileApp/Login'),
      headers: {"Accept": "Application/json"},
      body: {
        'strLoginName': username,
        'strPasswordHash': password,
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return data;
    }
  }
}
