import 'dart:convert';

import 'package:emee_admin/pages/token_api.dart';
import 'package:emee_admin/service/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

Future getCompany() async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('$baseUrl/admin/units/get/company'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );
    
    if (url.statusCode == 401 || url.statusCode == 403) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      token = newToken;

      url = await http.get(
        Uri.parse('$baseUrl/admin/units/get/company'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch(err) {
    throw Exception("error: $err");
  }
}

Future getDispatchUnits(int serviceid) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('$baseUrl/admin/dispatch/units/get/all/$serviceid'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode == 401 || url.statusCode == 403) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      token = newToken;

      url = await http.get(
        Uri.parse('$baseUrl/admin/dispatch/units/get/all/$serviceid'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch(err) {
    throw Exception("error: $err");
  }
}

Future getDispatchActiveUnits(int serviceid) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('$baseUrl/admin/dispatch/units/get/active/$serviceid'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode == 401 || url.statusCode == 403) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      token = newToken;

      url = await http.get(
        Uri.parse('$baseUrl/admin/dispatch/units/get/active/$serviceid'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch(err) {
    throw Exception("error: $err");
  }
}

Stream getUnit(int unitid) async* {
  String? token;
  token = await _authService.getAccessToken();

  yield* Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    try {
      var url = await http.get(
        Uri.parse('$baseUrl/admin/units/get/$unitid'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );

      if (url.statusCode == 401 || url.statusCode == 403) {
        // 🔁 TRY REFRESH
        final newToken = await refreshAccessToken();
        if (newToken == null) {
          throw Exception('Session expired');
        }

        token = newToken;

        url = await http.get(
          Uri.parse('$baseUrl/admin/units/get/$unitid'),
          headers: {
            "Content-type" : "application/json",
            "Authorization" : "Bearer $token"
          }
        );
      }

      return jsonDecode(url.body);
    } catch(err) {
      throw Exception("error: $err");
    }
  });
}

Stream getUnitProgress(int reportid) async* {
  String? token;
  token = await _authService.getAccessToken();

  yield* Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    try {
      var url = await http.get(
        Uri.parse('$baseUrl/admin/units/progress/get/$reportid'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );

      if (url.statusCode == 401 || url.statusCode == 403) {
        // 🔁 TRY REFRESH
        final newToken = await refreshAccessToken();
        if (newToken == null) {
          throw Exception('Session expired');
        }

        token = newToken;

        url = await http.get(
          Uri.parse('$baseUrl/admin/units/progress/get/$reportid'),
          headers: {
            "Content-type" : "application/json",
            "Authorization" : "Bearer $token"
          }
        );
      }

      return jsonDecode(url.body);
    } catch(err) {
      throw Exception("error: $err");
    }
  });
}

Future getUnitStatus(int unitid) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('$baseUrl/admin/units/status/get/$unitid'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode == 401 || url.statusCode == 403) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      token = newToken;

      url = await http.get(
        Uri.parse('$baseUrl/admin/units/status/get/$unitid'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch(err) {
    throw Exception("error: $err");
  }
}

Future updateUnitStatus(int unitid, String status) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.put(
      Uri.parse('$baseUrl/admin/units/status/put'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "unitid" : unitid,
        "status" : status
      })
    );

    if (url.statusCode == 401 || url.statusCode == 403) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      token = newToken;

      url = await http.put(
        Uri.parse('$baseUrl/admin/units/status/put'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "unitid" : unitid,
          "status" : status
        })
      );
    }

    return jsonDecode(url.body);
  } catch(err) {
    throw Exception("error: $err");
  }
}

Future updateProgressStatus(int progress, int reportid) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.put(
      Uri.parse('$baseUrl/admin/units/progress/put'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "reportid" : reportid,
        "progress" : progress
      })
    );

    if (url.statusCode == 401 || url.statusCode == 403) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      token = newToken;

      url = await http.put(
        Uri.parse('$baseUrl/admin/units/progress/put'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "reportid" : reportid,
          "progress" : progress
        })
      );
    }

    return jsonDecode(url.body);
  } catch(err) {
    throw Exception("error: $err");
  }
}

Future registerUnit(int serviceid, String password, String platnumber, int companyid, String vehicletype) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.post(
      Uri.parse('$baseUrl/admin/units/register/units'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "serviceid" : serviceid,
        "password" : password,
        "platnumber" : platnumber,
        "companyid" : companyid,
        "vehicletype" : vehicletype 
      })
    );

    if (url.statusCode == 401 || url.statusCode == 403) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      token = newToken;

      url = await http.post(
        Uri.parse('$baseUrl/admin/units/register/units'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "serviceid" : serviceid,
          "password" : password,
          "platnumber" : platnumber,
          "companyid" : companyid,
          "vehicletype" : vehicletype 
        })
      );
    }

    return jsonDecode(url.body);

  } catch (err) {
    throw Exception("error: $err");
  }
}

Future chooseUnit(int unitid, int reportid) async{
  String? token;
  token = await _authService.getAccessToken();

  try{
    var url = await http.put(
      Uri.parse('$baseUrl/admin/reports/assignedunit/put'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "reportid" : reportid,
        "unitid" : unitid
      })
    );

    if (url.statusCode == 401 || url.statusCode == 403) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      token = newToken;

      url = await http.put(
        Uri.parse('$baseUrl/admin/reports/assignedunit/put'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "reportid" : reportid,
          "unitid" : unitid
        })
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
}