import 'package:authentication/display_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:authentication/security/phone_verification.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final color = Colors.black45;
  var code = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  Future verifyCode(context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: PhoneVerification.verify, smsCode: code);
      await auth.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Display();
      }), (route) => false);
    } on FirebaseAuthException catch (e) {
      // Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/verification.jpg'),
                const SizedBox(height: 40),
                Text('Verification',
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )),
                const SizedBox(height: 10),
                Text(
                  'Enter the code sent to the number',
                  style: GoogleFonts.lexend(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Pinput(
                  length: 6,
                  showCursor: false,
                  onChanged: (value) {
                    code = value;
                  },
                  focusedPinTheme: PinTheme(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: color),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => verifyCode(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  child: Text(
                    "Verify Phone Number",
                    style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return const PhoneVerification();
                      }), (route) => false);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: Text(
                      "Edit Phone Number?",
                      style: GoogleFonts.lexend(
                          color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
