import 'package:flutter/material.dart';
import 'package:subscription_app/logic/logic.dart';
import 'package:subscription_app/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

bool obserText = true;

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();

  final _logic = LogicRepo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameCtrl,
              autofocus: true,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                labelText: "Name",
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailCtrl,
              autofocus: true,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                labelText: "Email",
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _pwdCtrl,
              autofocus: true,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 12),
              obscureText: obserText,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                labelText: "Password",
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obserText = !obserText;
                    });
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(
                    obserText == true ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                ),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Future.value(_logic
                    ..createWithEmailAndPwd(_emailCtrl.text, _pwdCtrl.text,
                        context, _nameCtrl.text));
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: _isLoading == true
                    ? Text(
                        'Signing up...',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        'Sign up',
                        style: TextStyle(color: Colors.black),
                      )),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Have an account?",
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Text(
                      "Sign in",
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
