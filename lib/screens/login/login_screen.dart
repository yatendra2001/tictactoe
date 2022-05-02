import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tictactoe/screens/login/cubit/login_cubit.dart';
import 'package:tictactoe/screens/widgets/widgets.dart';
import 'package:tictactoe/utils/assets_constants.dart';
import 'package:tictactoe/utils/session_helper.dart';
import 'package:tictactoe/utils/theme_constants.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_button/timer_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    SmsAutoFill().listenForCode();
    super.initState();
  }

  String? mobileNumber;
  String? otp;
  void _otpBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: const Color(0xFF3A424D),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.submitting) {
                const Center(child: CircularProgressIndicator());
              }
            },
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: PinFieldAutoFill(
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const UnderlineDecoration(
                        textStyle: TextStyle(fontSize: 20, color: Colors.white),
                        colorBuilder: FixedColorBuilder(Colors.white),
                        lineStrokeCap: StrokeCap.square,
                      ),
                      currentCode: otp,
                      onCodeSubmitted: (code) {},
                      onCodeChanged: (code) {
                        if (code!.length == 6) {
                          otp = code;
                          BlocProvider.of<LoginCubit>(context)
                              .verifyOtp(otp: otp!);
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: TimerButton(
                      label: 'Resend',
                      onPressed: () {
                        BlocProvider.of<LoginCubit>(context)
                            .sendOtpOnPhone(phone: SessionHelper.phone!);
                      },
                      buttonType: ButtonType.RaisedButton,
                      timeOutInSeconds: 30,
                      activeTextStyle:
                          const TextStyle(color: Color(0xFF3A424D)),
                      disabledTextStyle: const TextStyle(color: kColorWhite),
                      color: kColorWhite,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
      if (state.status == LoginStatus.error) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(content: state.failure.message),
        );
      }
    }, builder: (context, state) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(loginScreenImage), fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                  Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: IntlPhoneField(
                          style: const TextStyle(color: Colors.black),
                          dropdownIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          initialCountryCode: 'IN',
                          disableLengthCheck: true,
                          onChanged: (value) {
                            if (value.number.length == 10) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                            setState(() {
                              mobileNumber = value.completeNumber;
                            });
                          },
                          validator: (val) {
                            if (val == null || val.number.length != 10) {
                              return "Invalid phone number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                              ),
                            ),
                            filled: true,
                            labelText: "Phone Number",
                            labelStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Or',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<LoginCubit>(context)
                              .logInWithGoogle();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: kColorWhite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 29,
                              width: 29,
                              margin: const EdgeInsets.only(right: 6),
                              child: Image.asset(googleIcon),
                            ),
                            const Text(
                              'Login with Google',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign in',
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.w700),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<LoginCubit>(context)
                                    .sendOtpOnPhone(phone: mobileNumber!);
                                _otpBottomSheet(context);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_forward,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
