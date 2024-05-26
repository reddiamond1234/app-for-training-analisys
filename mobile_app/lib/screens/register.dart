import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/register/register_bloc.dart';
import '../routes/routes.dart';
import '../services/firebase_auth_service.dart';
import '../style/colors.dart';
import '../style/icons.dart';
import '../util/failures/auth_failure.dart';
import '../widgets/fd_app_bar.dart';
import '../widgets/fd_button.dart';
import '../widgets/fd_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        globalBloc: context.read<GlobalBloc>(),
        firebaseAuthService: FirebaseAuthService.instance,
      ),
      child: const _RegisterScreen(),
    );
  }
}

class _RegisterScreen extends StatelessWidget {
  const _RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const FDAppBar(secondaryColor: BVColors.dark),
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.isRegistrationSuccessful == true) {
              Navigator.popUntil(
                context,
                ModalRoute.withName(BVRoutes.preLogin),
              );
              Navigator.pushReplacementNamed(context, BVRoutes.welcome);
            } else {
              if (state.routeToPush != null) {
                Navigator.pushReplacementNamed(context, state.routeToPush!);
              }
            }
          },
          builder: (context, state) {
            final RegisterBloc bloc = BlocProvider.of<RegisterBloc>(context);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              translate('register.title'),
                              style: const TextStyle(
                                fontSize: 30,
                                color: BVColors.dark,
                              ),
                            ),
                            const SizedBox(height: 20),
                            FDTextField(
                              onChanged: (_) => bloc.onChanged(),
                              hintText: translate('user.name'),
                              suffixText: translate('user.name'),
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              controller: bloc.nameEditingController,
                            ),
                            const SizedBox(height: 10),
                            FDTextField(
                              onChanged: (_) => bloc.onChanged(),
                              hintText: translate('user.email'),
                              suffixText: translate('user.email'),
                              textInputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              controller: bloc.emailEditingController,
                            ),
                            const SizedBox(height: 10),
                            FDTextField(
                              suffixText: translate('user.password'),
                              onChanged: (_) => bloc.onChanged(),
                              hintText: translate('user.password'),
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
                            const SizedBox(height: 20),
                            FDPrimaryButton(
                              text: translate('register.register_button'),
                              onPressed: bloc.registrationPressed,
                              enabled: bloc.shouldButtonBeEnabled(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              translate("register.terms"),
                              style: const TextStyle(
                                color: BVColors.text,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            if (state.failure != null) ...[
                              const SizedBox(height: 5),
                              Center(
                                child: Text(
                                  state.failure is EmailAlreadyInUseFailure
                                      ? translate(
                                          'register.email_already_registered',
                                        )
                                      : translate(
                                          'register.registration_error',
                                        ),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Text(
                          translate('register.already_registered'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: BVColors.text,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FDSecondaryButton(
                          text: translate('login.title'),
                          onPressed: bloc.loginPressed,
                          prefixIcon: null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 10)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
