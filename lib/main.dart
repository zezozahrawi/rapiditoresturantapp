import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resturante_de_tante/pages/Home/landing_page.dart';
import 'package:resturante_de_tante/provider/provider.dart';

User? userIsSigned;

void main() async {
  //responsble for creating the connections
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rapidito',
        theme: ThemeData(
          //Custom AppBar Klische
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.white,
            actionsIconTheme: IconThemeData(
              color: Colors.redAccent,
            ),
            elevation: 2,
            titleTextStyle: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            foregroundColor: Colors.redAccent,
          ),
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const LandingPage(),
    
      ),
    );
  }
}
