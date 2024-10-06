import 'package:commentapp/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_view.dart';
import 'controllers/auth_controller.dart';
import 'views/comments_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Set Poppins as the default font
      ),
      home: StreamBuilder<User?>(
        stream: _authController.userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return CommentsView();
          } else {
            return LoginView();
          }
        },
      ),

      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/comment': (context) => CommentsView()
      },    );



  }
}
