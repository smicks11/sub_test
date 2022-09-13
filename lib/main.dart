import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'logic/prefs.dart';
import 'sign_up_screen.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
   await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sub Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignUp(),
    );
  }
}

