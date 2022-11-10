import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import './home_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer timer;
  bool canResendEmail = false;

  void _showErrorDialog(String errorMessage){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(errorMessage, style: TextStyle(color: Colors.red),),
        actions: [
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future sendVerificationEmail() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      final error = user.sendEmailVerification();
      if(error==null) return;
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    }on PlatformException catch (error) {
      print('hello');
      _showErrorDialog(error.message);
    } catch (e) {
      // print(e);
      // _showErrorDialog(e);
    }
  }

  Future checkEmailVerified() async {
    try{
      final user = await FirebaseAuth.instance.currentUser();
      user.reload();
      setState(() {
        isEmailVerified = user.isEmailVerified;
      });
      if (isEmailVerified) timer.cancel();
    }on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials';
      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      print(message);
    }catch(e){
      // print(e);
    }
  }

  Future getVerify() async {
    // isEmailVerified = await FirebaseAuth.instance.currentUser();
    try{
      final user = await FirebaseAuth.instance.currentUser();
      user.reload();
      setState(() {
        isEmailVerified = user.isEmailVerified;
      });

      if (!isEmailVerified) {
        sendVerificationEmail();
        timer = Timer.periodic(
          Duration(seconds: 3),
              (_) => checkEmailVerified(),
        );
      }
    }on PlatformException catch (error) {
      print(error.message);
    }catch(e){
      // print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getVerify();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? HomePage()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify Email'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'A verification email has been sent to your email',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.email, size: 32),
                    label: const Text(
                      'Resent Email',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                  )
                ],
              ),
            ),
          );
  }
}
