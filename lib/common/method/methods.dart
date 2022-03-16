import 'package:flutter/foundation.dart';

logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}
