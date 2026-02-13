import 'dart:convert';

import 'package:emee_admin/service/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

const String baseUrl = "https://cuddly-athena-emeeapp-f2eaeb08.koyeb.app";

Future<String?> refreshAccessToken() async {
  final refresh = await _authService.getRefreshToken();
  print(refresh);

  if (refresh == null) return null;

  final res = await http.post(
    Uri.parse('$baseUrl/auth/refresh'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'refreshToken': refresh}),
  );

  // if (res.statusCode != 200) {
  //   await _authService.clearTokens();
  //   return null;
  // }

  // final data = jsonDecode(res.body);
  // await _authService.saveTokens(data['accessToken'], data['refreshToken']);

  final data = jsonDecode(res.body);

  final newAccess = data['accessToken'];
  final newRefresh = data['refreshToken'] ?? refresh; // KEEP OLD ONE

  await _authService.saveTokens(newAccess, newRefresh);

  return data['accessToken'];
}