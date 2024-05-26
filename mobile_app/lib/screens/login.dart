import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../routes/routes.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_database_service.dart';
import '../services/local_storage_service.dart';
import '../style/colors.dart';
import '../style/icons.dart';
import '../style/text_styles.dart';
import '../util/failures/auth_failure.dart';
import '../widgets/fd_app_bar.dart';
import '../widgets/fd_button.dart';
import '../widgets/fd_rounded_box.dart';
import '../widgets/fd_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        localStorageService: LocalStorageService.instance,
        firebaseDatabaseService: FirebaseDatabaseService.instance,
        firebaseAuthService: FirebaseAuthService.instance,
        globalBloc: context.read<GlobalBloc>(),
      ),
      child: const _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: const FDAppBar(
          showLeading: true,
          secondaryColor: BVColors.dark,
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isLoginSuccessful == true) {
              Navigator.popUntil(
                  context, ModalRoute.withName(BVRoutes.preLogin));
              Navigator.pushReplacementNamed(context, BVRoutes.home);
            } else {
              if (state.routeToPush != null) {
                Navigator.pushNamed(context, state.routeToPush!);
              }
            }
          },
          builder: (context, state) {
            final LoginBloc bloc = BlocProvider.of<LoginBloc>(context);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translate('login.title'),
                        style: BVTextStyles.headingEnter,
                      ),
                      const SizedBox(height: 20),
                      FDTextField(
                        onChanged: (_) => bloc.onChanged(),
                        hintText: translate('login.email_message'),
                        suffixText: translate('login.email'),
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: bloc.emailEditingController,
                      ),
                      const SizedBox(height: 10),
                      FDTextField(
                        onChanged: (_) => bloc.onChanged(),
                        suffixText: translate('login.password'),
                        hintText: translate('login.password_message'),
                        obscureText: state.isPasswordToggled,
                        textInputType: TextInputType.visiblePassword,
                        controller: bloc.passwordEditingController,
                        focusedBorderColor: Colors.black,
                        suffixIcon: GestureDetector(
                          onTap: bloc.togglePassword,
                          child: SvgPicture.asset(
                            state.isPasswordToggled
                                ? BVIcons.showPassword
                                : BVIcons.hidePassword,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      if (state.failure != null) ...[
                        FDRoundedBox(
                          width: double.infinity,
                          color: BVColors.alertBackground,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                translate(
                                  state.failure is TimeoutFailure
                                      ? 'login.login_timeout_error'
                                      : 'login.login_error',
                                ),
                                style: BVTextStyles.textBold
                                    .copyWith(color: BVColors.alert),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                translate(
                                  state.failure is TimeoutFailure
                                      ? 'login.login_timeout_error_message'
                                      : 'login.login_auth_error',
                                ),
                                style: BVTextStyles.infoSmall
                                    .copyWith(color: BVColors.alert),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      FDPrimaryButton(
                        text: translate('login.primary_button_text'),
                        onPressed: () async => bloc.login(),
                      ),
                      const SizedBox(height: 10),
                      CupertinoButton(
                        onPressed: bloc.forgottenPassword,
                        child: Text(
                          translate('login.forgot_password'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: BVColors.text,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
