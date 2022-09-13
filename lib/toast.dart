import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart'; 

cToast(
    {required String msg,
    required Color color,
    required BuildContext context}) {
  showTopSnackBar(
    context,
    CustomSnackBar.success(
      iconPositionLeft: 8,
      textStyle: TextStyle(fontSize: 13, color: Colors.white),
      message: msg,
      backgroundColor: color,
      icon: const Icon(Icons.info, color: Colors.white),
    ),
  );
}