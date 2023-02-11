import 'package:Bootke/features/auth/application/providers/auth_failure_provider.dart';
import 'package:Bootke/features/auth/application/providers/show_sms_form_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/typedefs.dart';
import '../../application/providers/loginPhoneNumberProvider.dart';
import '../../application/state.dart';
import '../../domain/enums/auth_failure.dart';

/// {@template auth_body}
/// Body of the AuthPage.
///
/// Add what it does
/// {@endtemplate}
class AuthBody extends ConsumerWidget {
  /// {@macro auth_body}
  const AuthBody({super.key});

  bool isWeb() {
    bool isIos = defaultTargetPlatform == TargetPlatform.iOS;
    bool isAndroid = defaultTargetPlatform == TargetPlatform.android;

    return !isIos && !isAndroid;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PhoneNumber phoneNumber = ref.watch(loginPhoneNumberProvider);
    final bool showSms = ref.watch(showSmsFormProvider);
    ref.listen<AuthFailure>(authFailureProvider,
          (previous, next) {
        if (next == AuthFailure.none ) {
          return;
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(title: Text(authFailureToText(next))),
          );
        }
      },
    );
    if(showSms){
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("אימות מספר",
                    style: Theme.of(context).textTheme.headline4),
                SizedBox(
                  height: 10,
                ),
                Text("ברגעים אלו נשלחת למכשיר שלכם הודעה עם קוד בן 6 ספרות",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 40,
                ),
                 Text("הקוד נשלח למכשיר שלכם"),
                Container(
                  width: 300,
                  child: PinCodeTextField(
                    appContext: context,
                    keyboardType: TextInputType.number,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.blue[200],
                        inactiveColor: Colors.white),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.blue.shade50,
                    enableActiveFill: true,
                    // errorAnimationController: errorController,
                    onCompleted: (v) {
                      ref
                          .read(authStateProvider.notifier).verifySmsCodeNative();
                    },
                    onChanged: (value) {
                      ref
                          .read(authStateProvider.notifier).updateSmsCode(value);                   },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
                SizedBox(height: 20),

              ]),
        ),
      );
    }else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("ברוכים הבאים!",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "כאן תוכלו להזמין את האורחים שלכם לקיבוץ מראש בקלות וללא שיחה לשומר",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline6,
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 40,
                  ),
                  Text("לצורך זיהוי אנא הכניסו מספר פלאפון",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline6),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                        onPressed: () async {
                          final bool isValidated = await ref
                              .read(authStateProvider.notifier)
                              .validatePhoneNumber(phoneNumber);

                          if (isValidated) {
                            ref
                                .read(authStateProvider.notifier)
                                .signInWithPhoneNumberNative(
                                phoneNumber: phoneNumber);
                          }
                        },
                        child: Text("שליחה")),
                    SizedBox(width: 10),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Expanded(
                        flex: isWeb() ? 0 : 1,
                        child: Container(
                          width: 200,
                          child: TextField(
                            onChanged: (String input) {
                              ref.read(authStateProvider.notifier)
                                  .updatePhoneNumber(input);
                            },
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: InputDecoration(
                              icon: Icon(Icons.phone),
                              labelText: "מספר פלאפון",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ]),
          ),
        ),
      );
    }
  }
}
