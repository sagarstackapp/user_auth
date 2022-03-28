import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/widget/common_alert_dialog.dart';

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

Future<bool> bioMetricsVerification(BuildContext context) async {
  bool isBioAvailable = await localAuthentication.canCheckBiometrics;
  logs('Bio status --> $isBioAvailable');
  bool isDeviceAvailable = await localAuthentication.isDeviceSupported();
  logs('Device status --> $isDeviceAvailable');
  if (isBioAvailable && isDeviceAvailable) {
    List<BiometricType> availableBios =
        await localAuthentication.getAvailableBiometrics();
    logs('Available bios --> $availableBios');
    if (availableBios.isNotEmpty) {
      bool isFingerAvailable =
          availableBios.any((element) => element == BiometricType.fingerprint);
      logs('isFingerAvailable --> $isFingerAvailable');
      try {
        bool isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Verify your BioMetric to continue.!',
          stickyAuth: true,
          useErrorDialogs: false,
        );
        logs('Auth status --> $isAuthenticated');
        return isAuthenticated;
      } on PlatformException catch (e) {
        showMessage(context, e.message);
        return true;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
}

Future<bool> checkConnectionState(BuildContext context,
    {bool showToast = true}) async {
  ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();
  bool isConnect = getConnectionValue(connectivityResult);
  if (!isConnect && showToast) {
    showDialog(
      context: context,
      builder: (_) => const CustomAlertDialog(),
    );
  }
  return isConnect;
}

bool getConnectionValue(ConnectivityResult connectivityResult) {
  bool status = false;
  switch (connectivityResult) {
    case ConnectivityResult.mobile:
      status = true;
      break;
    case ConnectivityResult.wifi:
      status = true;
      break;
    case ConnectivityResult.bluetooth:
      status = true;
      break;
    case ConnectivityResult.ethernet:
      status = true;
      break;
    case ConnectivityResult.none:
      status = false;
      break;
    default:
      status = false;
      break;
  }
  return status;
}
