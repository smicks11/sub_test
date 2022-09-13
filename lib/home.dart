// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:subscription_app/logic/prefs.dart';
import 'package:subscription_app/login.dart';
import 'logic/logic.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final plugin = PaystackPlugin();
  int? pointBal;

  final _logic = LogicRepo();

  @override
  void initState() {
    plugin.initialize(
        publicKey: 'pk_test_b03a040efdc3c592cc1f62892f394f26cfec1b31');
    WidgetsBinding.instance?.addPostFrameCallback((_) => getPointBalance());
    super.initState();
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'SubscriptionFromSUBTEST${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  startPayment(context) async {
    String refNo = _getReference();
    String amount = '10000';
    Charge charge = Charge()
      ..amount = int.parse(amount)
      ..reference = refNo
      // ..plan = "PLN_871ytkftu1edi7f"
      //..accessCode = "hhdvjfbflf"
      ..email = UserPreferences.getEmail();

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    if (response.status == true) {
      print("this is response from paystack: $response");
      print("this is reference from paystack: ${response.reference}");

      await _logic.addTouserPoint();
      // setState(() {});
    }
  }

  Future<void> getPointBalance() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        setState(() {
          pointBal = value.get('points');
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Subscription'),
        actions: [
          InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(Icons.logout))
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ignore: prefer_const_constructors
                  Text(
                    'Point Balance',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    pointBal.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    startPayment(context);
                    // Navigator.push(context, MaterialPageRoute(builder: ((context) => const SubScreen())));
                  },
                  child: const Text('Subscribe Now')),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const Homescreen())));
                  },
                  child: const Text('Refresh point')),
            )
          ],
        ),
      ),
    );
  }
}
