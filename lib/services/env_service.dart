import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  loadFromEnvFile(String message) {
    return dotenv.env[message]!;
  }

  loadBackendApiFromEnvFile() {
    return loadFromEnvFile('BACKEND_API_URL');
  }
}
