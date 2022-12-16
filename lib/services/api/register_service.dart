import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/user.dart';
import 'package:loopsnelheidapp/models/verify_token.dart';

class RegisterService {
  final String registerUserEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/register";

  final String verifyMailEndpoint =
      dotenv.env['BACKEND_API_URL']! + "/auth/verify/code/";

  Future<http.Response?> registerUser(User user) {
    return http.post(Uri.parse(registerUserEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(user));
  }

  Future<bool> verifyEmailByDigitalCode(VerifyToken verifyToken) async {
    final response = await http.post(Uri.parse(verifyMailEndpoint +
        verifyToken.userId.toString() + "/" + verifyToken.digitalCode));

    return response.statusCode == 200;
  }
}
