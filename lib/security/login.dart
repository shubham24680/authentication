import 'package:authentication/security/forgot_password.dart';
import 'package:authentication/security/phone_verification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final color = Colors.black45;
  bool obscure = true;

  Future signIn(context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: color),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  field(id) {
    Map<int, TextEditingController> control = {
      1: _emailController,
      2: _passwordController
    };
    return TextField(
      controller: control[id],
      obscureText: (id == 1) ? false : obscure,
      decoration: InputDecoration(
        suffixIcon: (id != 1)
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                child: Icon(
                  (obscure)
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: color,
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        hintText: (id == 1) ? "Email" : "Password",
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  textbutton(id) {
    return Container(
      alignment: (id == 1) ? Alignment.centerRight : null,
      child: TextButton(
        onPressed: () {
          if (id == 1) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const ForgotPassword();
              },
            ));
          } else {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return const SignupScreen();
            }), (route) => false);
          }
        },
        style: TextButton.styleFrom(foregroundColor: Colors.white),
        child: Text(
          (id == 1) ? "forgot password?" : "Register now",
          style: GoogleFonts.lexend(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  divider() {
    return Expanded(
      child: Divider(
        thickness: 0.5,
        color: Colors.grey[400],
      ),
    );
  }

  squareTile(id) {
    const image = {
      1: 'images/phone.svg',
      2: 'images/google.svg',
      3: 'images/microsoft.svg'
    };

    Map verify = {
      1: const PhoneVerification(),
      2: const PhoneVerification(),
      3: const PhoneVerification()
    };
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return verify[id];
        }));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: SvgPicture.asset(
        "${image[id]}",
        height: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Image.asset(
                  'images/app.png',
                  height: 300,
                ),
                Text(
                  "Welcome back, you've been missed!",
                  style: GoogleFonts.lexend(fontSize: 18),
                ),
                const SizedBox(height: 10),
                field(1),
                const SizedBox(height: 10),
                field(2),
                textbutton(1),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => signIn(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  child: Text(
                    "Sign In",
                    style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or continue with",
                        style: GoogleFonts.lexend(color: color),
                      ),
                    ),
                    divider(),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    squareTile(1),
                    const SizedBox(width: 20),
                    squareTile(2),
                    const SizedBox(width: 20),
                    squareTile(3),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
                    ),
                    textbutton(2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
