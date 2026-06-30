import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  Future<void> loadUserProfile() async {
    emit(state.copyWith(isLoading: true));

    final prefs = await SharedPreferences.getInstance();

    String savedName = prefs.getString('user_name') ?? 'Ehab Ahmed';
    String savedEmail = prefs.getString('user_email') ?? 'ehab.saber@gmail.com';

    emit(state.copyWith(
      name: savedName,
      email: savedEmail,
      isLoading: false,
    ));
  }

  void toggleEdit() {
    emit(state.copyWith(isEditing: !state.isEditing));
  }
  Future<void> saveProfile(String newName, String newEmail) async {
    emit(state.copyWith(isLoading: true));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
    await prefs.setString('user_email', newEmail);

    emit(state.copyWith(
      name: newName,
      email: newEmail,
      isEditing: false,
      isLoading: false,
    ));
  }
}
