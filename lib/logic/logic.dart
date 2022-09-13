import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:subscription_app/home.dart';
import 'package:subscription_app/logic/prefs.dart';

import '../toast.dart';
import '../user_model.dart';

class LogicRepo {
  Future<void> createWithEmailAndPwd(
    String userSignUpEmail,
    String userSignUpPassword,
    BuildContext context,
    String name,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userSignUpEmail, password: userSignUpPassword);
      await userCredential.user!.sendEmailVerification();
      await FirebaseFirestore.instance
          .collection("UserData")
          .doc(userCredential.user!.uid)
          .set({
        "userId": userCredential.user!.uid,
        "name": name,
        "email": userSignUpEmail,
        "password": userSignUpPassword,
        "registrationTime": DateTime.now(),
        "points": 0,
      }).then((value) async {
        await UserPreferences.setProfileData(
          name,
          userSignUpEmail,
          userSignUpPassword,
          0,
        );
        cToast(
            msg: "Yay! Signed up Successfully",
            color: Colors.green,
            context: context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Homescreen()));
      });
    } catch (e) {
      print(e.toString());
      cToast(msg: e.toString(), color: Colors.red, context: context);
    }
  }

  Future<void> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        QuerySnapshot userSnapShots =
            await FirebaseFirestore.instance.collection("UserData").get();
        userSnapShots.docs.map((element) {
          if (FirebaseAuth.instance.currentUser!.uid == element.get("userId")) {
            UserModel? userModel = UserModel(
              name: element.get("name") ?? "",
              email: element.get("email") ?? "",
              point: element.get("points") ?? "",
              password: element.get("password") ?? "",
            );

            UserPreferences.setProfileData(
              userModel.name,
              userModel.email,
              userModel.password,
              userModel.point,
            );
          }
        }).toList();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => const Homescreen()),
            (route) => false);
        return value;
      });
    } catch (e) {
      print(e.toString());
      cToast(msg: e.toString(), color: Colors.red, context: context);
    }
  }

  //Point Increment
  addTouserPoint() async {
    try {
      FirebaseFirestore.instance
          .collection('UserData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'points': FieldValue.increment(30)});
    } catch (e) {
      print(e.toString());
    }
  }

  //Get Point Balance

}
