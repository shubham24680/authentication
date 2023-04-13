import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final color = Colors.black45;
  bool obscure = true;

  Future signUp(context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: color),
          );
        });

    if (_passwordController.text == _newPasswordController.text) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password don't match!")));
    }

    Navigator.pop(context);
  }

  field(id) {
    Map<int, TextEditingController> control = {
      1: _emailController,
      2: _passwordController,
      3: _newPasswordController
    };
    return TextField(
      controller: control[id],
      obscureText: (id == 1)
          ? false
          : (id == 2)
              ? true
              : obscure,
      decoration: InputDecoration(
        suffixIcon: (id == 3)
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
        hintText: (id == 1)
            ? "Email"
            : (id == 2)
                ? "Password"
                : "Confirm Password",
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

  textbutton(context) {
    return TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }), (route) => false);
      },
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      child: Text(
        "Login now",
        style: GoogleFonts.lexend(color: color, fontWeight: FontWeight.bold),
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
    return ElevatedButton(
      onPressed: () {},
      // onPressed: () => AuthServices().signInWithGoogle(),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/app.png',
                  height: 300,
                ),
                Text(
                  "You are just one step closer to us!",
                  style: GoogleFonts.lexend(fontSize: 18),
                ),
                const SizedBox(height: 10),
                field(1),
                const SizedBox(height: 10),
                field(2),
                const SizedBox(height: 10),
                field(3),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => signUp(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  child: Text(
                    "Sign Up",
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
                    ),
                    textbutton(context),
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
