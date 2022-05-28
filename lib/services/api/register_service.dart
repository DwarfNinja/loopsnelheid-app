import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';
import '../../models/verify_token.dart';

class RegisterService {
  final String registerUserEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/register";

  final String verifyMailEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/verify/code/";

  Future<http.Response?> registerUser(User user) {
    return http.post(Uri.parse(registerUserEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user));
  }

  Future<void> verifyEmailByDigitalCode(VerifyToken verifyToken) async {
    await http.post(Uri.parse(verifyMailEndpoint +
        verifyToken.userId +
        "/" +
        verifyToken.digitalCode));
  }
}
