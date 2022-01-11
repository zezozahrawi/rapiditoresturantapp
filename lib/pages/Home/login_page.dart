import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/continent_name.dart';
import 'package:resturante_de_tante/pages/Home/sign_Up.dart';
import 'package:resturante_de_tante/pages/Home/forget_Pass.dart';
import 'package:resturante_de_tante/widget/custom_containerfortextfield.dart';
import 'package:resturante_de_tante/widget/custom_showmetoast.dart';
import 'package:resturante_de_tante/widget/custom_textformfiled.dart';

FirebaseAuth user = FirebaseAuth.instance;
final _formkey = GlobalKey<FormState>();

//controller for the Forms
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

/// var dynamic user
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //backgrond fixed on the top to stop the overlapping No AppBar Blank
        Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(children: <Widget>[
          //Email, Password, StartButton..
          Form(
            // watch the user input
            key: _formkey,

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // const Text(
                  //   "Welcome!",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 60,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),

                  //Animated Logo
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.asset(
                      "assets/images/rapidito.gif",
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //Text
                  const Text(
                    "Time to work, let's go!",
                    style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //Email TextBox
                  CostumContainerTextField(
                    cutomTextFeildChild: CustomTextFiledWidget(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your Email';
                        }
                      },
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                    ),
                    height: 50,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //Password Textbox
                  CostumContainerTextField(
                    height: 50,
                    cutomTextFeildChild: CustomTextFiledWidget(
                      obscureText: true,
                      controller: password,
                      hintText: 'Password',
                      validator: (pass) {
                        if (pass!.length < 5) {
                          return "passowrd is weak";
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  //Forget password
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgerPass(),
                            )),
                        child: const Text(
                          "forget password ?",
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //sTART bUTTON
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    child: ElevatedButton(
                      //On Pressed !!
                      onPressed: () async {
                        if (!_formkey.currentState!.validate()) {
                          return;
                        }
                        _formkey.currentState!.save();

                        try {
                          await user.signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );

                          //Toast for welcome the guest
                          tosat("Welcome \n" + email.text);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            //use method toast
                            tosat('user not found');
                          } else if (e.code == 'wrong-password') {
                            tosat('wrong-password');
                          }
                        } catch (e) {
                          tosat(e.toString());
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const ListViewMenu()));
                      },

                      //button Style
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),

                      // ElevatedButton Child
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // Divider
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 40,
                    endIndent: 40,
                  ),

                  // Links SignUp and Forget pass
                  //SignUp
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignMeUp(),
                          ));
                    },
                    child: const Text(
                      'Sign Up Now',
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
