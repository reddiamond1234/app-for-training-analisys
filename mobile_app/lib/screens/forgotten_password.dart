import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../bloc/forgotten_password/forgotten_password_bloc.dart';
import '../routes/routes.dart';
import '../services/firebase_auth_service.dart';
import '../style/colors.dart';
import '../style/text_styles.dart';
import '../util/failures/auth_failure.dart';
import '../widgets/fd_app_bar.dart';
import '../widgets/fd_button.dart';
import '../widgets/fd_rounded_box.dart';
import '../widgets/fd_text_field.dart';
import '../widgets/native_dialog.dart';

class ForgottenPasswordScreen extends StatelessWidget {
  const ForgottenPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgottenPasswordBloc(
        firebaseAuthService: FirebaseAuthService.instance,
      ),
      child: const _ForgottenPasswordScreen(),
    );
  }
}

class _ForgottenPasswordScreen extends StatelessWidget {
  const _ForgottenPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const FDAppBar(color: BVColors.red),
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<ForgottenPasswordBloc, ForgottenPasswordState>(
          listener: (context, state) {
            if (state.isSubmitSuccessful == true) {
              Navigator.pop(context);
              showNativeDialogWithOk(
                context,
                translate("forgotten_password.success_title"),
                translate("forgotten_password.success_message"),
              );
            }
          },
          builder: (context, state) {
            final ForgottenPasswordBloc bloc =
                BlocProvider.of<ForgottenPasswordBloc>(context);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Text(
                    translate('forgotten_password.title'),
                    style: BVTextStyles.headingEnter,
                  ),
                  const SizedBox(height: 23),
                  FDTextField(
                    onChanged: (_) => bloc.onChanged(),
                    hintText: translate("forgotten_password.email_message"),
                    suffixText: translate("forgotten_password.email_message"),
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: bloc.emailEditingController,
                  ),
                  if (state.failure != null) ...[
                    const SizedBox(height: 24),
                    FDRoundedBox(
                      color: BVColors.alertBackground,
                      child: Text(
                        translate(
                          state.failure! is AuthFailure
                              ? "forgotten_password.error_not_found"
                              : "forgotten_password.error",
                        ),
                        style: BVTextStyles.textBold.copyWith(
                          color: BVColors.alert,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FDPrimaryButton(
                    text: translate("forgotten_password.send"),
                    onPressed: bloc.submitPressed,
                    enabled: state.isButtonEnabled,
                  ),
                  const Spacer(flex: 2),
                  Column(
                    children: [
                      Text(
                        translate('forgotten_password.no_account'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: BVColors.text,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FDSecondaryButton(
                        text: translate('forgotten_password.register'),
                        onPressed: () {
                          Navigator.popUntil(
                              context, ModalRoute.withName(BVRoutes.preLogin));
                          Navigator.pushNamed(context, BVRoutes.register);
                        },
                        prefixIcon: null,
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 50)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
