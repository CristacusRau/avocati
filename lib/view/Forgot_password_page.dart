import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avocati/utils/utils.dart';

class ForgotPasswordPage extends StatefulWidget {

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Reset Password'),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const Text(
              'Receive an email to \n Reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20,), 
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Email adress'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => 
                email != null && !EmailValidator.validate(email)
                ? 'Enter a valid email'
                : null,
            ), 
            const SizedBox(height: 20,), 
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50)
                ),
              icon: const Icon(Icons.email_outlined,),
              label: const Text(
                'Reset Password',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: resetPassword,
            ),
          ],
        ),
      ),
    ),
  );
  
  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator())
    );

    try{
      await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
    
      Utils.showSnackBar('Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (error) {
      print(error);

      Utils.showSnackBar(error.message);
      Navigator.of(context).pop();
    } 
  }
}