import 'dart:convert';

import 'package:emee_admin/service/auth_service.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://cuddly-athena-emeeapp-f2eaeb08.koyeb.app";

Future loginAcc(String id, String password, String role) async {
  try {
    final url = await http.post(
      Uri.parse('$baseUrl/login/admin'),
      headers: {"Content-type" : "application/json"},
      body : jsonEncode({
        "id" : id,
        "password" : password,
        "role" : role
      })
    );

    return url;
  } catch(err) {
    return http.Response(err.toString(), 500);
  }
}

Future logout() async {
  final auth = AuthService();
  final token = await auth.getAccessToken();

  try {
    if (token != null) {
      final url = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    }

    await auth.clearTokens();
  } catch(err) {
    return http.Response(err.toString(), 500);
  }
  
}