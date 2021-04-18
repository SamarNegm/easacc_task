import 'package:easacc_task/data/repo/services/auth.dart';
import 'package:easacc_task/presentation/screens/SignUp_screen.dart';
import 'package:easacc_task/presentation/screens/login_screen.dart';
import 'package:easacc_task/presentation/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Flutter firebase Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          backgroundColor: Color(0xff82E6B2),
          textTheme: TextTheme(headline1: TextStyle(color: Colors.white)),
          accentColor: Color(0xff82E6B2),
          primaryColor: Color(0xff707070),
          accentColorBrightness: Brightness.dark,
          inputDecorationTheme: InputDecorationTheme(
            // filled: true,
            // fillColor: Color(0xff707070),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              // borderSide: BorderSide(color: Colors.grey[200]),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              // borderSide: BorderSide(color: Colors.grey[200]),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              // borderSide: BorderSide(color: Colors.grey[200]),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              //    borderSide: BorderSide(color: Colors.grey[200]),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              //  borderSide: BorderSide(color: Colors.grey[200]),
            ),
          ),
        ),
        home: StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                print('hasData....');
                return Home();
              }
              return Login.create(ctx);
            }),
        routes: {
          SignUp.routeName: (ctx) => SignUp.create(ctx),
          settings.routeName: (ctx) => settings(),
          Home.routeName: (ctx) => Home(),
          Login.routeName: (ctx) => Login.create(ctx),
        },
      ),
    );
  }
}
