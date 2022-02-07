import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/chat_screen.dart';
import './screens/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Text('Something wrong');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Chat',
            theme: ThemeData(
              primaryColor: Colors.blueGrey,
              backgroundColor: Colors.indigoAccent,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  onPrimary: Colors.white,
                  textStyle: const TextStyle(fontSize: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              textTheme: const TextTheme(
                headline2: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            home: StreamBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return ChatScreen();
                } else {
                  return AuthScreen();
                }
              },
              stream: FirebaseAuth.instance.authStateChanges(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );

    // return FutureBuilder(
    //   builder: (context, appSnapshot) {
    //     if (appSnapshot.connectionState == ConnectionState.done) {
    // return MaterialApp(
    //   title: 'Flutter Chat',
    //   theme: ThemeData(
    //     primaryColor: Colors.blueGrey,
    //     backgroundColor: Colors.indigoAccent,
    //     elevatedButtonTheme: ElevatedButtonThemeData(
    //       style: ElevatedButton.styleFrom(
    //         primary: Colors.blueGrey,
    //         onPrimary: Colors.white,
    //         textStyle: const TextStyle(fontSize: 12),
    //         elevation: 4,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(15),
    //         ),
    //       ),
    //     ),
    //   ),
    //   home: StreamBuilder(
    //     builder: (ctx, snapshot) {
    //       if (snapshot.hasData) {
    //         return ChatScreen();
    //       } else {
    //         return AuthScreen();
    //       }
    //     },
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //   ),
    // );
    //     }
    //     return CircularProgressIndicator();
    //   },
    //   future: _initialization,
    // );
  }
}
