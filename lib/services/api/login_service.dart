import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final String loginUserEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/login";

  Future<http.Response> authenticate(String email, String password) {
     return http.post(Uri.parse(loginUserEndpoint),
        body: jsonEncode(<String, String> {
          "email": email,
          "password": password
        }));
  }
}
