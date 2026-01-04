import 'dart:convert';

import 'package:emee_admin/pages/token_api.dart';
import 'package:emee_admin/service/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

Stream getAssignedReports(int admin) async*{
  String? token;
  token = await _authService.getAccessToken();

  yield* Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    try {

      var url = await http.get(
        Uri.parse('http://10.0.2.2:5001/admin/$admin/report/get/assigned'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );

      if (url.statusCode != 200 || url.statusCode != 203) {
        // 🔁 TRY REFRESH
        final newToken = await refreshAccessToken();
        if (newToken == null) {
          throw Exception('Session expired');
        }

        url = await http.get(
          Uri.parse('http://10.0.2.2:5001/admin/$admin/report/get/assigned'),
          headers : {
            "Content-type" : "application/json",
            "Authorization" : "Bearer $token"
          }
        );
      }
      
      return jsonDecode(url.body);

    } catch (err) {
      throw Exception("error: $err");
    }
  });
}

Stream getUnassignedReports(int admin) async*{
  String? token;
  token = await _authService.getAccessToken();

  yield* Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    try {

      var url = await http.get(
        Uri.parse('http://10.0.2.2:5001/admin/$admin/report/get/unassigned'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );

      if (url.statusCode != 200 || url.statusCode != 203) {
        // 🔁 TRY REFRESH
        final newToken = await refreshAccessToken();
        if (newToken == null) {
          throw Exception('Session expired');
        }

        url = await http.get(
          Uri.parse('http://10.0.2.2:5001/admin/$admin/report/get/unassigned'),
          headers : {
            "Content-type" : "application/json",
            "Authorization" : "Bearer $token"
          }
        );
      }
      
      return jsonDecode(url.body);

    } catch (err) {
      throw Exception("error: $err");
    }
  });
}

Future getReportHistory(int service,String start, String end) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/admin/$service/history/report/get/$start/$end'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse('http://10.0.2.2:5001/admin/$service/history/report/get/$start/$end'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
  
}

Future getUnitReportHistory(int service, int unitid, String start, String end) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/admin/unit/$service/$unitid/history/report/get/$start/$end'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url =await http.get(
        Uri.parse('http://10.0.2.2:5001/admin/unit/$service/$unitid/history/report/get/$start/$end'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
  
}

Future getReportInformation(int reportid, int status, int serviceid) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/report/get/$serviceid/$reportid/$status'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse('http://10.0.2.2:5001/report/get/$serviceid/$reportid/$status'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
}

Future getAssesmentResult(int reportid) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/admin/assesment/get/$reportid'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse('http://10.0.2.2:5001/admin/assesment/get/$reportid'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
}

Future getMessageHistory(int report) async{
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/history/message/get/$report'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse('http://10.0.2.2:5001/history/message/get/$report'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
}
 
Stream getMessage(int report) async*{
  String? token;
  token = await _authService.getAccessToken();
  yield* Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    try {

      var url = await http.get(
        Uri.parse('http://10.0.2.2:5001/admin/message/get/$report'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
      
      if (url.statusCode != 200 || url.statusCode != 203) {
        // 🔁 TRY REFRESH
        final newToken = await refreshAccessToken();
        if (newToken == null) {
          throw Exception('Session expired');
        }

        url = await http.get(
          Uri.parse('http://10.0.2.2:5001/admin/message/get/$report'),
          headers : {
            "Content-type" : "application/json",
            "Authorization" : "Bearer $token"
          }
        );
      }
      
      return jsonDecode(url.body);
    } catch (err) {
      throw Exception("error: $err");
    }
  });
}

Future sendMessage(String message, int report) async{
  try {
    String? token;
    token = await _authService.getAccessToken();

    var url = await http.post(
      Uri.parse('http://10.0.2.2:5001/admin/message/send'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "message" : message,
        "report" : report
      })
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.post(
        Uri.parse('http://10.0.2.2:5001/admin/message/send'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "message" : message,
          "report" : report
        })
      );
    }

    return jsonDecode(url.body);

  } catch (err) {
    throw Exception("Network error: $err");
  }
}

Future postEndtime(int reportid, String endedat) async {
  try{
    String? token;
    token = await _authService.getAccessToken();

    var url = await http.post(
      Uri.parse('http://10.0.2.2:5001/admin/report/post/ended'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "report_id" : reportid,
        "ended_at" : endedat
      })
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.post(
        Uri.parse('http://10.0.2.2:5001/admin/report/post/ended'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "report_id" : reportid,
          "ended_at" : endedat
        })
      );
    }

    return url;
  } catch (err) {
    throw Exception("error: $err");
  }
}