import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/core/common/entities/user.dart';
import 'package:blackbook/features/auth/domain/usecases/complete_registration.dart';
import 'package:blackbook/features/auth/domain/usecases/current_user.dart';
import 'package:blackbook/features/auth/domain/usecases/send_otp.dart';
import 'package:blackbook/features/auth/domain/usecases/user_log_in.dart';
import 'package:blackbook/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blackbook/features/auth/domain/usecases/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppUserCubit _appUserCubit;
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final CurrentUser _currentUser;
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;
  final CompleteRegistration _completeRegistration;

  AuthBloc({
    required AppUserCubit appUserCubit,
    required UserSignUp userSignUp,
    required UserLogIn userLogIn,
    required CurrentUser currentUser,
    required SendOtp sendOtp,
    required VerifyOtp verifyOtp,
    required CompleteRegistration completeRegistration,
  })  : _appUserCubit = appUserCubit,
        _userSignUp = userSignUp,
        _userLogIn = userLogIn,
        _currentUser = currentUser,
        _sendOtp = sendOtp,
        _verifyOtp = verifyOtp,
        _completeRegistration = completeRegistration,
        super(AuthInitial()) {
    on<AuthLogIn>(_onAuthLogIn);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSendOtp>(_onAuthSendOtp);
    on<AuthVerifyOtp>(_onAuthVerifyOtp);
    on<AuthCompleteRegistration>(_onAuthCompleteRegistration);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  void _onAuthLogIn(AuthLogIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userLogIn(UserLogInParams(
      email: event.email,
      password: event.password,
    ));
    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userSignUp(UserSignUpParams(
      email: event.email,
      password: event.password,
    ));
    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSendOtp(AuthSendOtp event, Emitter<AuthState> emit) async {
    final currentState = state;
    if (currentState is AuthSuccess) {
      emit(AuthLoading());
      final response = await _sendOtp(SendOtpParams(currentState.user.email));
      response.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (message) {
          event.onSuccess(message);
          emit(AuthSuccessUnverified(currentState.user));
        },
      );
    }
  }

  void _onAuthVerifyOtp(AuthVerifyOtp event, Emitter<AuthState> emit) async {
    final currentState = state;
    if (currentState is AuthSuccessUnverified) {
      emit(AuthLoading());
      final response = await _verifyOtp(
          VerifyOtpParams(email: currentState.user.email, otp: event.otp));
      response.fold(
        (failure) {
          event.onFailure(failure.message);
          emit(AuthSuccessUnverified(currentState.user));
        },
        (user) => _emitAuthSuccess(user, emit),
      );
    }
  }

  void _onAuthCompleteRegistration(
      AuthCompleteRegistration event, Emitter<AuthState> emit) async {
    final currentState = state;
    if (currentState is AuthSuccessVerified) {
      emit(AuthLoading());
      final response = await _completeRegistration(CompleteRegistrationParams(
        firstName: event.firstName,
        lastName: event.lastName,
        birthdate: event.birthdate,
        gender: event.gender,
        educationLevel: event.educationLevel,
        examsPreparing: event.examsPreparing,
      ));
      response.fold(
        (failure) {
          event.onFailure(failure.message);
          emit(AuthSuccessVerified(currentState.user));
        },
        (user) => _emitAuthSuccess(user, emit),
      );
    }
  }

  void _onAuthIsUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _currentUser(NoParams());
    response.fold(
      (failure) {
        emit(AuthInitial());
        _appUserCubit.updateUser(null);
      },
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    if (!user.emailVerified) {
      emit(AuthSuccessUnverified(user));
    } else {
      if (user is AuthUser) {
        emit(AuthSuccessComplete(user));
      } else {
        emit(AuthSuccessVerified(user));
      }
    }

    _appUserCubit.updateUser(state as AuthSuccess);
  }
}
