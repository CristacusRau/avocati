import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avocati/main.dart';
import 'package:avocati/utils/utils.dart';
import 'package:flutter/gestures.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn; 

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60,),
          const FlutterLogo(size: 120,),
          const SizedBox(height: 20,), 
          const Text(
            'Hey There, \n Welcome back',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40,), 
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Email adress'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) => 
              email != null && !EmailValidator.validate(email)
              ? 'Enter a valid email'
              : null,
          ), 
          const SizedBox(height: 4,),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => 
              value != null && value.length < 6
              ? 'Enter min. 6 characters'
              : null,
          ),
          const SizedBox(height: 20,), 
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50)
              ),
            icon: const Icon(Icons.lock_open, size: 32,),
            label: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signUp,
          ),
          const SizedBox(height: 24), 
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 20),
              text: 'Already have an account? ',
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignIn,
                  text: 'Log In', 
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
              ],
            )
          )
        ],
      ),
    )
  );
  
  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;
     
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => Center(child: CircularProgressIndicator(),)
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      ); 
    } on FirebaseAuthException catch (error) {
      print(error);

      Utils.showSnackBar(error.message);
    }

    //Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}