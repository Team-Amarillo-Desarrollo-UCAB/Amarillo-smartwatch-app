
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Users/domain/user_profile.dart';
import 'chatbot/prueba.dart';
import 'chatbot/prueba2.dart';
import 'common/presentation/startup_view.dart';
import 'login/presentation/welcome_view.dart';
// import 'package:firebase_core/firebase_core.dart';
//hola



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  final userProfile = await UserProfile.loadFromPreferences();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => userProfile),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoDely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WelcomeView(), 
    );
  }
}
