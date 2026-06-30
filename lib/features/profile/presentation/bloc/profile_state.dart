class ProfileState {
  final String name;
  final String email;
  final bool isEditing;
  final bool isLoading;

  ProfileState({
    this.name = 'Ehab Ahmed', 
    this.email = 'ehab@example.com',
    this.isEditing = false,
    this.isLoading = false,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    bool? isEditing,
    bool? isLoading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      isEditing: isEditing ?? this.isEditing,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
