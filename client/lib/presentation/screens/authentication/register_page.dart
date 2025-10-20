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
import 'package:flutter/gestures.dart';

class RegisterPage extends StatefulWidget {
  final SignUpUserModel signupData;
  const RegisterPage({super.key, required this.signupData});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with InputValidationMixin {
  late AuthBloc _authBloc;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileNumberController;
  DateTime? _birthday;
  bool _isTermsAccepted = false;

  Timer? _debounceFirstName;
  Timer? _debounceLastName;
  Timer? _debounceMobileNumber;

  final Duration debounceDurationFirstName = const Duration(milliseconds: 1250);
  final Duration debounceDurationMiddleName =
      const Duration(milliseconds: 1250);
  final Duration debounceDurationLastName = const Duration(milliseconds: 1250);
  final Duration debounceDurationMobileNumber =
      const Duration(milliseconds: 1250);

  String? firstNameError;
  String? lastNameError;
  String? mobileNumberError;
  String? phoneNumberError;
  String? birthdayError;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _mobileNumberController = TextEditingController();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ??
          DateTime(
            now.year,
            now.month,
            now.day,
          ),
      firstDate: DateTime(1900),
      lastDate: DateTime(
        now.year - 12,
        now.month,
        now.day,
      ),
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

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('📄 Terms & Conditions'),
          content: const SingleChildScrollView(
            child: Text(
              '''Terms and Conditions

By agreeing to these Terms and Conditions, you acknowledge and accept the following:

1. Usage of Sakay
Sakay is a free public transportation companion app that provides real-time vehicle tracking, ETA notifications, and route optimization for commuters and drivers along the Lingayen-Dagupan route. The app is intended for UPang students, daily commuters, PWDs, and registered drivers.

2. Account & Access
Users are required to create an account using a valid email address and password. Drivers and commuters have separate access and features based on their account type.

3. Data Collection
By using Sakay, you consent to the collection and secure storage of your email address and password for account authentication and communication purposes. We do not sell or share your information with third parties.

4. Announcements & Communication
Admins may post important announcements which are visible to users through the app. These may include service updates, route adjustments, or general notices relevant to the Sakay system.

5. Service Availability
While we aim to provide real-time, accurate vehicle data, Sakay does not guarantee uninterrupted access or flawless performance. GPS or internet issues may affect real-time tracking at times.

6. Acceptable Use
Users must not attempt to disrupt the service, misuse data, or impersonate others. Abuse or suspicious activity may result in account restriction.

7. Changes to Terms
We may update these Terms and Conditions as the service evolves. Users will be notified of significant changes through the app.

8. Contact & Support
For questions, feedback, or issues, please reach out through our admin portal or the official Sakay website.''',
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('🔒 Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              '''1. Information We Collect
We collect information you directly provide when:
• Creating an account
• Using the app's features
• Contacting support

2. How We Use Your Information
Your data is used to:
• Provide and improve the Sakay app
• Process logins and activity
• Send important service or support messages
• Communicate updates and relevant information

3. Information Sharing
We do not sell, trade, or share your personal data with third parties without your consent, except as required by law.

4. Data Security
We implement appropriate security practices to protect your data from unauthorized access, alteration, or misuse.

5. Data Retention
Your information is retained as long as your account is active or as needed for app functionality and safety.

6. Your Rights
You have the right to:
• View your personal data
• Request corrections
• Delete your account
• Withdraw consent for data use

7. Cookies & Analytics
We may use cookies and similar technologies to enhance your experience and track usage patterns for analytics.

8. Changes to Policy
This Privacy Policy may be updated as necessary. Users will be notified of changes via in-app alerts or on this page.''',
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          context.go("/email_verification", extra: {
            "email_address": obfuscateEmail(widget.signupData.email_address!),
            "token": state.token,
          });
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "New User Registration ",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "Tell us about yourself",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _firstNameController,
                  onChanged: (text) {
                    if (_debounceFirstName?.isActive ?? false)
                      _debounceFirstName?.cancel();
                    _debounceFirstName =
                        Timer(debounceDurationFirstName, () async {
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
                    _debounceLastName =
                        Timer(debounceDurationLastName, () async {
                      String? validationError = validateName(text);
                      setState(() {
                        lastNameError = validationError;
                      });
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    errorText: lastNameError,
                    prefixIcon: Icon(Icons.person, color: Color(0xFF00A2FF)),
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
                            _debounceMobileNumber =
                                Timer(debounceDurationMobileNumber, () async {
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 11.0, color: Colors.black),
                          children: [
                            const TextSpan(
                              text:
                                  "By proceeding, I agree that Sakay can collect, use and disclose the information provided by me in accordance with the ",
                            ),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: Color(0xFF00A2FF),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showTermsDialog,
                            ),
                            const TextSpan(
                              text: " and I fully comply with ",
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: Color(0xFF00A2FF),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showPrivacyDialog,
                            ),
                            const TextSpan(
                              text: " which I have read and understand.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
                ElevatedButton(
                  onPressed: _isTermsAccepted
                      ? () async {
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
                          final signupData = widget.signupData.copyWith(
                            first_name: _firstNameController.text,
                            middle_name: _middleNameController.text,
                            last_name: _lastNameController.text,
                            phone_number: _mobileNumberController.text,
                            birthday: _birthday.toString(),
                            user_type: "COMMUTER",
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
                      'Next',
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
}
