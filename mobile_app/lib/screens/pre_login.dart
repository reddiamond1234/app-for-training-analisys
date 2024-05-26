import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:training_app/style/images.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/pre_login/pre_login_bloc.dart';
import '../routes/routes.dart';
import '../services/firebase_auth_service.dart';
import '../services/local_storage_service.dart';
import '../style/colors.dart';
import '../style/icons.dart';
import '../widgets/fd_app_bar.dart';
import '../widgets/fd_button.dart';
import '../widgets/fd_loading_indicator.dart';

class PreLoginScreen extends StatelessWidget {
  const PreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PreLoginBloc(
        firebaseAuthService: FirebaseAuthService.instance,
        globalBloc: context.read<GlobalBloc>(),
        localStorageService: LocalStorageService.instance,
      ),
      child: const _PreLoginScreen(),
    );
  }
}

class _PreLoginScreen extends StatelessWidget {
  const _PreLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreLoginBloc, PreLoginState>(
      listener: (context, state) {
        if (state.isRegistrationPressed == true) {
          Navigator.pushNamed(context, BVRoutes.register);
        }

        if (state.routeToPush != null) {
          if (state.routeToPush == BVRoutes.login) {
            Navigator.pushNamed(context, state.routeToPush!);
          } else {
            Navigator.pushReplacementNamed(context, state.routeToPush!);
          }
        }
      },
      builder: (context, state) {
        final PreLoginBloc bloc = BlocProvider.of<PreLoginBloc>(context);

        return Stack(
          children: [
            Scaffold(
              appBar: const FDAppBar(showLeading: false),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(BVImages.logo, width: 150),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            translate('pre_login.title'),
                            style: const TextStyle(
                              fontSize: 30,
                              color: BVColors.dark,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FDSecondaryButton(
                            onPressed: bloc.emailPasswordPressed,
                            prefixIcon: BVIcons.mail,
                            text: translate('pre_login.email_password'),
                          ),
                          const SizedBox(height: 10),
                          /*FDSecondaryButton(
                            onPressed: bloc.signInWithGoogle,
                            prefixIcon: BVIcons.logoGoogleColored,
                            text: translate('pre_login.gmail_login'),
                          ),
                          const SizedBox(height: 15),
                          if (Platform.isIOS) ...[
                            FDSecondaryButton(
                              onPressed: bloc.signInWithApple,
                              prefixIcon: BVIcons.apple,
                              text: translate('pre_login.apple_login'),
                            ),
                            const SizedBox(height: 15),
                          ],*/
                          /*FDSecondaryButton(
                            enabled: false,
                            text: translate('pre_login.facebook_login'),
                            prefixIcon: BVIcons.facebook,
                            onPressed: bloc.facebookPressed,
                          ),*/
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          Text(
                            translate('pre_login.no_account'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: BVColors.text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          FDSecondaryButton(
                            text: translate('pre_login.registration'),
                            onPressed: () async => bloc.registrationPressed(),
                            prefixIcon: null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom)
                  ],
                ),
              ),
            ),
            if (state.isLoading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: BVColors.dark.withOpacity(0.7),
                child: const Center(
                  child: FDLoadingIndicator(
                    radius: 25,
                    dotRadius: 8,
                    color: BVColors.red,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
