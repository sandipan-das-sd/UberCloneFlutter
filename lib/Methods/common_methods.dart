import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart' ;

class CommonMethods {
  Future<void> checkConnectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();
    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      displaySnackBar(
        "Your Internet  is Not Working. Check Your Connection and Try Again",
        context,
      );

    }
  }

  void displaySnackBar(String messageText, BuildContext context) {
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
