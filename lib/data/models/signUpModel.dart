class SignUpModel {
  final bool isLoading;
  final bool access;

  SignUpModel({this.isLoading = false, this.access = false});
  SignUpModel copyWith({
    bool isLoading,
    bool access,
  }) {
    return SignUpModel(
      isLoading: isLoading ?? this.isLoading,
      access: access ?? this.access,
    );
  }
  //bool isSubmitted;
}
