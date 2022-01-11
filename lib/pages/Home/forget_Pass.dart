// ignore_for_file: file_names

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

TextEditingController _emailforget = TextEditingController();
final _formkey = GlobalKey<FormState>();
FirebaseAuth user = FirebaseAuth.instance;

class ForgerPass extends StatelessWidget {
  const ForgerPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset("assets/images/forgot.png"),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child: const Text(
                    'Dont worry, Rapidito will help you to get your account back quickly',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                //must be edited with the CustomWidgit
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                    controller: _emailforget,
                    validator: (email) {
                      if (email!.isEmpty) {
                        return 'Please Enter your Email';
                      }
                    },
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "Enter your Email",
                      hintStyle: TextStyle(color: Colors.black26),
                      filled: true,
                      fillColor: Color(0x0000000c),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formkey.currentState!.validate()) {
                          return;
                        }
                        _formkey.currentState!.save();
                        print(_emailforget.text.toString());
                        try {
                          await user.sendPasswordResetEmail(
                              email: _emailforget.text);
                          
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          //to bring the error from the DB and to convert it to string
                          print(e.code.toString());
                        } catch (e) {
                          toast(e);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent),
                        minimumSize:
                            MaterialStateProperty.all(const Size(90, 40)),
                      ),
                      child: const Text(
                        'ask for help',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'after you sent your request please check your email inbox',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void toast(Object e) {}
}
