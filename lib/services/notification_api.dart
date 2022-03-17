import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:user_auth/common/method/methods.dart';

Future sendNotification(String body, String title, String token) async {
  String baseUrl = 'https://fcm.googleapis.com/fcm/send';
  logs('Url --> $baseUrl');
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAABBObzys:APA91bEu5_rZfJdrUBg9ZVDOzFCCgnVYDDq5zQqhFKpaifJb5qZ8NALrcu5YZeg9xmyMM00YvK6SVqsPVP7L_aCZMWzftMvTJfuVq1GR4hGEDEDJGYp_iFxNctfcvtw7NNSgYxA_uQjZ',
    },
    body: jsonEncode({
      "notification": {
        "body": body,
        "title": title,
        "image":
            "https://images.idgesg.net/images/article/2017/08/lock_circuit_board_bullet_hole_computer_security_breach_thinkstock_473158924_3x2-100732430-large.jpg"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "open_val": "B",
        "image":
            "https://images.idgesg.net/images/article/2017/08/lock_circuit_board_bullet_hole_computer_security_breach_thinkstock_473158924_3x2-100732430-large.jpg"
      },
      "registration_ids": [token]
    }),
  );
  logs('Status code --> ${response.statusCode}');
  if (response.statusCode == 200 || response.statusCode == 201) {
    logs('Body --> ${response.body}');
    var message = jsonDecode(response.body);
    return message;
  } else {
    logs('Status code --> ${response.statusCode}');
    return null;
  }
}
