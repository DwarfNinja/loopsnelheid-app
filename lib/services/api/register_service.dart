import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loopsnelheidapp/models/user.dart';
import 'package:loopsnelheidapp/models/verify_token.dart';
import 'package:loopsnelheidapp/services/env_service.dart';

class RegisterService {
  final String registerUserEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/register";

  final String verifyMailEndpoint = EnvService().loadBackendApiFromEnvFile() + "/auth/verify/code/";

  Future<http.Response?> registerUser(User user) {
    return http.post(Uri.parse(registerUserEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(user));
  }

  Future<bool> verifyEmailByDigitalCode(VerifyToken verifyToken) async {
    final response = await http.post(Uri.parse(verifyMailEndpoint + verifyToken.userId.toString() + "/" + verifyToken.digitalCode));

    return response.statusCode == 200;
  }
}
