// import 'package:Bootke/features/auth/auth.dart';
import 'package:Bootke/features/auth/application/providers/auth_user_provider.dart';
import 'package:Bootke/features/core/widgets/loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:Bootke/features_old/user/views/user_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/application/providers/logged_in_provider.dart';
import 'features/auth/presentation/auth_page.dart';
import 'features/core/providers/is_loading_provider.dart';
import 'firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      const ProviderScope(
        child: MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bootke',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xff0369a8),
              onPrimary: Colors.white,
              secondary: Color(0xff1c164e),
              onSecondary: Colors.white,
              error: Color(0xffe81e26),
              onError: Colors.white,
              background: Colors.white,
              onBackground: Color(0xff0369a8),
              surface: Colors.white,
              onSurface: Color(0xff0369a8))),



      home: Consumer(
        builder: (context, ref, child) {
ref.read(authUserProvider.notifier).authStateChanges();

          ref.listen<bool>(
            isLoadingProvider,
                (_, isLoading) {
              if (isLoading) {
LoadingOverlay.instance().show(context: context);
              } else {
LoadingOverlay.instance().hide();
              }
            },
          );
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const UserPage();
          } else {
            return const AuthPage();
          }
        },
      ),
     
    );
  }
}
