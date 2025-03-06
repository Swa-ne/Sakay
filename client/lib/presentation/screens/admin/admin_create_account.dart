import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/authentication/auth_event.dart';
import 'package:sakay_app/bloc/authentication/auth_state.dart';
import 'package:sakay_app/common/mixins/input_validation.dart';
import 'package:sakay_app/core/configs/theme/app_colors.dart';
import 'package:sakay_app/data/models/sign_up.dart';

class AdminCreateDriverAccountPage extends StatefulWidget {
  const AdminCreateDriverAccountPage({super.key});

  @override
  _AdminCreateDriverAccountPageState createState() =>
      _AdminCreateDriverAccountPageState();
}

class _AdminCreateDriverAccountPageState
    extends State<AdminCreateDriverAccountPage> with InputValidationMixin {
  late AuthBloc _authBloc;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileNumberController;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAccepted = false;
  DateTime? _birthday;

  Timer? _debounceEmail;
  Timer? _debounceConfirmPassword;
  Timer? _debounceFirstName;
  Timer? _debounceLastName;
  Timer? _debounceMobileNumber;

  final Duration debounceDuration = const Duration(milliseconds: 1250);

  String? emailError;
  String? confirmPasswordError;
  String? firstNameError;
  String? lastNameError;
  String? phoneNumberError;
  String? birthdayError;

  bool _hasLowerCase = false;
  bool _hasUpperCase = false;
  bool _hasDigit = false;
  bool _isLongEnough = false;
  bool _hasSpecialCharacter = false;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _mobileNumberController = TextEditingController();
  }

  void _validatePassword(String password) {
    setState(() {
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasDigit = password.contains(RegExp(r'\d'));
      _hasSpecialCharacter =
          password.contains(RegExp(r'.*[!@#$%^&*(),.?":{}|<>].*'));
      _isLongEnough = password.length >= 8;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
        birthdayError = null;
      });
    } else {
      if (_birthday == null) {
        setState(() {
          birthdayError = "Please choose your birthday";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          context.pop();
        } else if (state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is SignUpConnectionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Driver Account"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Driver Account",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "Fill in the details to create a driver account.",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _emailController,
                  onChanged: (text) {
                    if (_debounceEmail?.isActive ?? false)
                      _debounceEmail?.cancel();
                    _debounceEmail = Timer(debounceDuration, () async {
                      String? validationError = await validateEmailInUse(text);
                      setState(() {
                        emailError = validationError;
                      });
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: emailError,
                    prefixIcon:
                        const Icon(Icons.email, color: Color(0xFF00A2FF)),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  onChanged: (text) {
                    _validatePassword(text);
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFF00A2FF)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFF00A2FF),
                      ),
                      onPressed: () {
                        _validatePassword(_passwordController.text);
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPasswordCriteria('Lowercase letter', _hasLowerCase),
                    _buildPasswordCriteria('Uppercase letter', _hasUpperCase),
                    _buildPasswordCriteria('Digit', _hasDigit),
                    _buildPasswordCriteria(
                        'Special character', _hasSpecialCharacter),
                    _buildPasswordCriteria(
                        'At least 8 characters', _isLongEnough),
                  ],
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _confirmPasswordController,
                  onChanged: (text) {
                    if (_debounceConfirmPassword?.isActive ?? false)
                      _debounceConfirmPassword?.cancel();
                    _debounceConfirmPassword = Timer(debounceDuration, () {
                      String? validationError = validateConfirmPassword(
                          _passwordController.text, text);
                      setState(() {
                        confirmPasswordError = validationError;
                      });
                    });
                  },
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: confirmPasswordError,
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFF00A2FF)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFF00A2FF),
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _firstNameController,
                  onChanged: (text) {
                    if (_debounceFirstName?.isActive ?? false)
                      _debounceFirstName?.cancel();
                    _debounceFirstName = Timer(debounceDuration, () {
                      String? validationError = validateName(text);
                      setState(() {
                        firstNameError = validationError;
                      });
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    errorText: firstNameError,
                    prefixIcon:
                        const Icon(Icons.person, color: Color(0xFF00A2FF)),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _middleNameController,
                  decoration: const InputDecoration(
                    labelText: 'Middle Name',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF00A2FF)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _lastNameController,
                  onChanged: (text) {
                    if (_debounceLastName?.isActive ?? false)
                      _debounceLastName?.cancel();
                    _debounceLastName = Timer(debounceDuration, () {
                      String? validationError = validateName(text);
                      setState(() {
                        lastNameError = validationError;
                      });
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    errorText: lastNameError,
                    prefixIcon:
                        const Icon(Icons.person, color: Color(0xFF00A2FF)),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/phflag.png',
                              height: 15.0,
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              "+63",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          controller: _mobileNumberController,
                          onChanged: (text) {
                            if (_debounceMobileNumber?.isActive ?? false)
                              _debounceMobileNumber?.cancel();
                            _debounceMobileNumber = Timer(debounceDuration, () {
                              String? validationError =
                                  validatePhoneNumberSignUp(text);
                              setState(() {
                                phoneNumberError = validationError;
                              });
                            });
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter mobile number',
                            errorText: phoneNumberError,
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.normal),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: _birthday != null ? "Birthdate" : null,
                      filled: true,
                      fillColor: AppColors.blueTextColor,
                      errorText: birthdayError,
                      prefixIcon: const Icon(Icons.calendar_month_rounded,
                          color: Color(0xFF00A2FF)),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                      ),
                    ),
                    child: Text(
                      _birthday == null
                          ? 'Select birthdate'
                          : DateFormat.yMMMd().format(_birthday!),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.formTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isTermsAccepted,
                      activeColor: const Color(0xFF00A2FF),
                      onChanged: (bool? value) {
                        setState(() {
                          _isTermsAccepted = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: null,
                        child: const Text.rich(
                          TextSpan(
                            text:
                                "By Proceeding, I agree that Sakay can collect, use and disclose the information provided by me in accordance with the ",
                            children: [
                              TextSpan(
                                text: "Privacy Notice",
                                style: TextStyle(
                                    fontSize: 14.0, color: Color(0xFF00A2FF)),
                              ),
                              TextSpan(
                                text: " and I fully comply with ",
                              ),
                              TextSpan(
                                text: "Terms & Conditions",
                                style: TextStyle(
                                    fontSize: 14.0, color: Color(0xFF00A2FF)),
                              ),
                              TextSpan(
                                text: " which I have read and understand.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: _isTermsAccepted
                      ? () async {
                          String? isValidEmail =
                              validateEmail(_emailController.text);
                          if (isValidEmail != null) {
                            setState(() {
                              emailError = isValidEmail;
                            });
                            return;
                          }
                          if (_confirmPasswordController.text.isEmpty) {
                            setState(() {
                              confirmPasswordError =
                                  "This field can't be empty";
                            });
                            return;
                          }
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            setState(() {
                              confirmPasswordError = "Doesn't match password";
                            });
                            return;
                          }
                          String? isValidFirstName =
                              validateName(_firstNameController.text);
                          if (isValidFirstName != null) {
                            setState(() {
                              firstNameError = isValidFirstName;
                            });
                            return;
                          }
                          String? isValidLastName =
                              validateName(_lastNameController.text);
                          if (isValidLastName != null) {
                            setState(() {
                              lastNameError = isValidLastName;
                            });
                            return;
                          }
                          String? isPhoneNumberValid =
                              validatePhoneNumberSignUp(
                                  _mobileNumberController.text);
                          if (isPhoneNumberValid != null) {
                            setState(() {
                              phoneNumberError = isPhoneNumberValid;
                            });
                            return;
                          }
                          if (_birthday == null) {
                            setState(() {
                              birthdayError = "Please choose your birthday";
                            });
                            return;
                          }
                          final signupData = SignUpUserModel(
                            email_address: _emailController.text,
                            password_hash: _passwordController.text,
                            confirmation_password:
                                _confirmPasswordController.text,
                            first_name: _firstNameController.text,
                            middle_name: _middleNameController.text,
                            last_name: _lastNameController.text,
                            phone_number: _mobileNumberController.text,
                            birthday: _birthday.toString(),
                            user_type: "DRIVER",
                          );
                          _authBloc.add(SignUpEvent(signupData, false));
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A2FF),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Create Driver Account',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCriteria(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check : Icons.close,
          color: isMet ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            decoration:
                isMet ? TextDecoration.none : TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}
