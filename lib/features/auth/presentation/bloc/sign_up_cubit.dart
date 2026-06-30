import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_state.dart';
import 'login_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpState());

  void onNameChanged(String value) {
    emit(state.copyWith(
      name: value,
      nameError: value.trim().isEmpty ? 'الاسم لا يمكن أن يكون فارغاً' : null,
    ));
  }

  void onEmailChanged(String value) {
    String? error;
    if (value.isEmpty) {
      error = 'البريد الإلكتروني لا يمكن أن يكون فارغاً';
    } else if (!value.contains('@') || !value.contains('.')) {
      error = 'صيغة البريد الإلكتروني غير صحيحة';
    }
    emit(state.copyWith(email: value, emailError: error));
  }

  void onPasswordChanged(String value) {
    String? error;
    if (value.isEmpty) {
      error = 'كلمة المرور لا يمكن أن تكون فارغة';
    } else if (value.length < 6) {
      error = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    emit(state.copyWith(password: value, passwordError: error));
  }

  Future<void> signUp() async {
    if (state.name.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty ||
        state.nameError != null ||
        state.emailError != null ||
        state.passwordError != null) {
      emit(state.copyWith(errorMessage: 'يرجى استكمال البيانات بشكل صحيح'));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error, errorMessage: 'فشل إنشاء الحساب'));
    }
  }
}
