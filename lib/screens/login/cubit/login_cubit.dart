import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/models/models.dart';
import 'package:tictactoe/repositories/auth/auth_repository.dart';
import 'package:tictactoe/utils/session_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void logInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final credential = await _authRepository.signInByGoogle();
      SessionHelper.displayName = credential.user!.displayName;
      SessionHelper.email = credential.user!.email;
      SessionHelper.uid = FirebaseAuth.instance.currentUser!.uid;
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void sendOtpOnPhone({required String phone}) async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final isOtpSent = await _authRepository.sendOTP(phone: phone);
      SessionHelper.phone = phone;
      debugPrint("Send otp complete: $phone  $isOtpSent");
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void verifyOtp({required String otp}) async {
    try {
      final userCredential = await _authRepository.verifyOTP(otp: otp);
      debugPrint("UserCredentials:  $userCredential");
      debugPrint("User uid: ${userCredential.user?.uid}");
      debugPrint("Current User uid: ${FirebaseAuth.instance.currentUser!.uid}");
      SessionHelper.uid = userCredential.user?.uid;
      SessionHelper.phone = userCredential.user?.phoneNumber;
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }
}
