abstract class StringValidator1 {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator1 {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators1 {
  final StringValidator1 emailValidator = NonEmptyStringValidator();
  final StringValidator1 passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';
}
