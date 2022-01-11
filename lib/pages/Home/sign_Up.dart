// ignore_for_file: file_names

import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:resturante_de_tante/pages/Home/landing_page.dart';
import 'package:resturante_de_tante/widget/custom_containerfortextfield.dart';
import 'package:resturante_de_tante/widget/custom_showmetoast.dart';
import 'package:resturante_de_tante/widget/custom_textformfiled.dart';

//objects ..
FirebaseAuth user = FirebaseAuth.instance;
FirebaseFirestore data = FirebaseFirestore.instance;

//responsible for user typing Failures
final _formkeyme = GlobalKey<FormState>();

TextEditingController name = TextEditingController();
TextEditingController mobileNumber = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController rePassword = TextEditingController();
dynamic birthday;

//get the foto from camera
final ImagePicker _picker = ImagePicker();

// here will e the foto saved in this variable
dynamic _pickedImagephoto;

//chef or waitr
dynamic dropdownValue;

class SignMeUp extends StatefulWidget {
  const SignMeUp({Key? key}) : super(key: key);

  @override
  _SignMeUpState createState() => _SignMeUpState();
}

class _SignMeUpState extends State<SignMeUp> {
  //savedphoto from user in picked Imagephoto
  //Methode to allow the user to open the camera and pick the phooto
  void _pickedImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Chooose image surce'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      ),
    )
        //save the picked Imagephoto inside thse variabel
        .then((value) async {
      if (value != null) {
        final pickedFile = await _picker.pickImage(source: value);
        setState(() {
          //filepath
          _pickedImagephoto = File(pickedFile!.path);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkeyme,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 60,
              width: double.infinity,
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  //Profile Picture
                  Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Stack(
                          // clipBehavior: Clip.antiAliasWithSaveLayer,
                          fit: StackFit.expand,
                          children: [
                            Container(
                              height: 46,
                              width: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: _pickedImagephoto == null
                                  ? const Icon(
                                      Icons.camera,
                                      color: Colors.white,
                                    )
                                  : Center(
                                      child: ClipOval(
                                        child: Image.file(
                                          _pickedImagephoto,
                                        ),
                                        //The methode will be written at the end
                                        clipper: MyClip(),
                                      ),
                                    ),
                              alignment: Alignment.center,
                            ),
                            //to locate the icon
                            Positioned(
                                left: 40,
                                bottom: 0,
                                child: SizedBox(
                                    height: 30,
                                    width: 50,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () {
                                            _pickedImage();
                                          },
                                        ))))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Profile picutre',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  // InkWell(
                  //   onTap: _pickedImage,
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.grey,
                  //     radius: 40.0,
                  //     child: CircleAvatar(
                  //       radius: 39,
                  //       child: ClipOval(
                  //         child: (_pickedImagephoto != null)
                  //             ? Image.file(
                  //                 _pickedImagephoto,
                  //                 fit: BoxFit.fill,
                  //               )
                  //             : Image.asset('assets/images/bgHeader.png'),
                  //       ),
                  //       backgroundColor: Colors.white,
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(
                    height: 40,
                  ),

                  //Email
                  CostumContainerTextField(
                    height: 30,
                    cutomTextFeildChild: CustomTextFiledWidget(
                      controller: email,
                      validator: (emailErr) {
                        if (emailErr!.isEmpty) {
                          return 'Please Enter your Email';
                        }
                      },
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //password
                  CostumContainerTextField(
                    height: 40,
                    cutomTextFeildChild: CustomTextFiledWidget(
                      obscureText: true,
                      controller: password,
                      hintText: 'Password',
                      validator: (pass) {
                        if (pass!.length < 6) {
                          return "passowrd must be +12";
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //RePassword
                  CostumContainerTextField(
                    height: 40,
                    cutomTextFeildChild: CustomTextFiledWidget(
                      obscureText: true,
                      controller: rePassword,
                      hintText: 'Re-enter your Password',
                      validator: (e) {
                        // if (e != password) {
                        //   return "passowrd don\'t match";
                        // }
                      },
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //Name
                  CostumContainerTextField(
                    height: 35,
                    cutomTextFeildChild: CustomTextFiledWidget(
                      obscureText: false,
                      controller: name,
                      hintText: 'Enter your full name',
                      validator: (nameErr) {
                        // if (nameErr!.length < 5) {
                        //   return "Name must be +6 Charechters";
                        // }
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //MobileNumber
                  CostumContainerTextField(
                    height: 35,
                    cutomTextFeildChild: CustomTextFiledWidget(
                      obscureText: false,
                      controller: mobileNumber,
                      hintText: 'Enter your MobileNumber',
                      validator: (mobNo) {
                        if (mobNo!.length < 8) {
                          return "Name must be +6 Charechters";
                        }
                      },
                      keyboardType: TextInputType.phone,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //Role
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(left: 40, right: 40),

                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),

                    // dropdown list Role
                    child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        underline: const SizedBox(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        hint: const Text("    Please select your role",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey)),
                        items: <String>['Chef', 'waiter']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: value == null
                                ? Text(
                                    'Please select your Role',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(value),
                          );
                        }).toList()),

                    height: 40,
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  //Birthday
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: MaterialButton(
                        color: Colors.white60,
                        child: birthday == null
                            ? Row(
                                children: const [
                                  Text(
                                    'Select Your Birthday',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            : Text(DateFormat.yMMMMEEEEd().format(birthday)),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 50),
                                  lastDate: DateTime(DateTime.now().year + 5))
                              .then((value) {
                            setState(() {
                              birthday = value;
                            });
                          });
                        }),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //sIGNuP Button
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formkeyme.currentState!.validate()) {
                          return;
                        } else if (_pickedImagephoto == null) {
                          return tosat('Please choose your Profile Photo!');
                        }
                        _formkeyme.currentState!.save();

                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );

                          //create file on Firebase Storag to save the user photo
                          Reference storageReference = FirebaseStorage.instance
                              .ref()
                              .child(
                                  "Image/'${user.currentUser!.email}/Posts/");
                          //upload selected foto
                          final UploadTask uploadTask =
                              storageReference.putFile(_pickedImagephoto);
                          //here the photo will be saved in URl
                          final TaskSnapshot downloadUrl = (await uploadTask);
                          final String url =
                              //get the URl
                              await downloadUrl.ref.getDownloadURL();

                          data
                              .collection('Users')
                              .doc(user.currentUser!.uid)
                              .set({
                            'name': name.text,
                            'mobileNumber': mobileNumber.text,
                            'birthday': birthday,
                            'Role': dropdownValue,
                            'email': email.text,
                            'password': password.text,
                            //upload the picture in FirebaseDatabase
                            'profilePhoto': url.toString(),
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LandingPage()));
                          tosat('Sign up Successful');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            tosat('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            //With show toaster
                            tosat('The account already exists for that email.');
                          }
                        } catch (e) {
                          tosat(e.toString());
                        }
                      },
                      //Style
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Sign Up',
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
                    height: 3,
                  ),

                  //Already have an account ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const LoginPage(),
                          //     ));
                          Navigator.pop(context);
                          // to reset ????
                          email.text = '';
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Methode for the Clipper
class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 200, 100);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}
