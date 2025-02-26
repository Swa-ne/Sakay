import 'package:sakay_app/data/sources/authentication/auth_repo_impl.dart';

mixin InputValidationMixin {
  static final _authRepo = AuthRepoImpl();

  String? validateEmail(String email) {
    final RegExp emailRegExp =
        RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$');
    if (email.isEmpty) {
      return 'This field can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a valid email address or phone number';
    }
    return null;
  }

  String? validateEmailOrPhoneNumber(String user_identifier) {
    if (user_identifier.isEmpty) {
      return 'This field can\'t be empty';
    } else if (validateEmail(user_identifier) != null &&
        validatePhoneNumber(user_identifier) != null) {
      return 'Enter a valid email address or phone number';
    }
    // DO THIS
    return null;
  }

  String? validatePhoneNumber(String number) {
    final RegExp numberRegExp = RegExp(r'^(09|9|\+639)\d{9}$');
    if (number.isEmpty) {
      return 'This field can\'t be empty';
    } else if (!numberRegExp.hasMatch(number)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validatePhoneNumberSignUp(String number) {
    final RegExp numberRegExp = RegExp(r'^(09|9)\d{9}$');
    if (number.isEmpty) {
      return null;
    } else if (!numberRegExp.hasMatch(number)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Future<String?> validateEmailInUse(String email) async {
    final emailFormatError = validateEmail(email);
    if (emailFormatError != null) {
      return emailFormatError;
    }

    bool isAvailable = await _authRepo.checkEmailAvalability(email);
    if (!isAvailable) {
      return 'This email is already in use';
    }
    return null;
  }

  String? validateName(String name) {
    if (name.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    } else if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateUsername(String username) {
    final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    if (username.isEmpty) {
      return 'Username can\'t be empty';
    } else if (!usernameRegExp.hasMatch(username)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<String?> validateUsernameInUse(String username) async {
    final usernameFormatError = validateUsername(username);
    if (usernameFormatError != null) {
      return usernameFormatError;
    }

    bool isAvailable = await _authRepo.checkUsernameAvalability(username);
    if (!isAvailable) {
      return 'This username is already in use';
    }
    return null;
  }

  String obfuscateEmail(String email) {
    List<String> emailParts = email.split('@');

    if (emailParts.length != 2) return email;

    String localPart = emailParts[0];
    String domainPart = emailParts[1];

    int visibleLength = 3;

    String obfuscatedLocalPart = '*' * (localPart.length - visibleLength) +
        localPart.substring(localPart.length - visibleLength);

    return "$obfuscatedLocalPart@$domainPart";
  }

  String? validateContent(String content) {
    int word_count = content.trim().split(RegExp(r'\s+')).length;
    if (content.isEmpty) {
      return 'Content is required';
    } else if (word_count >= 2 && word_count <= 250) {
      return null;
    }
    return 'The content must contain between 2 and 250 words.';
  }

  String? validateHeadline(String headline) {
    int word_count = headline.trim().split(RegExp(r'\s+')).length;
    if (headline.isEmpty) {
      return 'Headline is required';
    } else if (word_count >= 1 && word_count <= 15) {
      return null;
    }
    return 'The headline must contain between 1 and 15 words.';
  }
}
