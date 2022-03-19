import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:user_auth/common/constant/color_res.dart';

LocalAuthentication localAuthentication = LocalAuthentication();

logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}

showMessage(BuildContext context, String message,
    {Color textColor = ColorResource.white}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

Future<bool> signInWithBio() async {
  bool isBioAvailable = await localAuthentication.canCheckBiometrics;
  logs('Bio status -->$isBioAvailable');
  if (isBioAvailable) {
    List<BiometricType> availableBios =
        await localAuthentication.getAvailableBiometrics();
    logs('Available bios --> $availableBios');
    if (availableBios.isNotEmpty) {
      bool isFingerAvailable =
          availableBios.any((element) => element == BiometricType.fingerprint);
      logs('isFingerAvailable --> $isFingerAvailable');
      bool isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Verify your BioMetric to continue.!',
        stickyAuth: true,
      );
      logs('Auth status --> $isAuthenticated');
      return isAuthenticated;
    } else {
      return true;
    }
  } else {
    return true;
  }
}
