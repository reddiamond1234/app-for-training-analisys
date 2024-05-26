import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:training_app/routes/routes.dart';

import 'bloc/global/global_bloc.dart';
import 'firebase_options.dart';
import 'routes/router.dart';
import 'services/firebase_auth_service.dart';
import 'services/firebase_database_service.dart';
import 'services/local_storage_service.dart';
import 'style/colors.dart';
import 'util/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Logger logger = Logger();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseDatabaseService(logger: logger);

  FirebaseAuthService(firebaseAuth: FirebaseAuth.instance);
  LocalStorageService();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'sl',
    supportedLocales: ['sl'],
  );

  runApp(LocalizedApp(delegate, BVApp(navigatorKey: navigatorKey)));
}

class BVApp extends StatelessWidget {
  const BVApp({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalBloc(
        firebaseAuthService: FirebaseAuthService.instance,
        localStorageService: LocalStorageService.instance,
        navigatorKey: navigatorKey,
      ),
      child: BlocListener<GlobalBloc, GlobalState>(
        listenWhen: (previous, current) => previous.user != current.user,
        listener: (context, state) {
          if (state.user == null) {
            Navigator.popUntil(
              navigatorKey.currentContext!,
              ModalRoute.withName(BVRoutes.home),
            );
            Navigator.popAndPushNamed(
              navigatorKey.currentContext!,
              BVRoutes.preLogin,
            );
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Training App',
          theme: ThemeData(
            scaffoldBackgroundColor: BVColors.background,
            colorScheme: ColorScheme.fromSeed(seedColor: BVColors.red),
            useMaterial3: true,
            fontFamily: "OpenSans",
          ),
          localizationsDelegates: [
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate,
          ],
          navigatorKey: navigatorKey,
          initialRoute: BVRoutes.initial,
          onGenerateRoute: BVRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
