import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';

class LoginScreenModel {
  TextEditingController emailAddressTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  FocusNode emailAddressFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool passwordVisibility = false;
  String? Function(String?)? emailAddressTextControllerValidator;
  String? Function(String?)? passwordTextControllerValidator;
  LoginScreenModel() {
    // Initialize validators
    emailAddressTextControllerValidator = (String? value) {
      if (value == null || value.isEmpty) {
        return 'Email cannot be empty';
      }
      if (!RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      ).hasMatch(value)) {
        return 'Enter a valid email';
      }
      return null;
    };

    passwordTextControllerValidator = (String? value) {
      if (value == null || value.isEmpty) {
        return 'Password cannot be empty';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null;
    };
  }
  void dispose() {
    emailAddressTextController.dispose();
    passwordTextController.dispose();
    emailAddressFocusNode.dispose();
    passwordFocusNode.dispose();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.apiStore});
  final ApiStore apiStore;
  @override
  State<LoginPage> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPage> {
  late LoginScreenModel _model;
  final bool isAndroid = Platform.isAndroid;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _model = LoginScreenModel();
  }

  Future<void> _loginUser() async {
    if (_model.emailAddressTextControllerValidator!(
          _model.emailAddressTextController.text,
        ) !=
        null) {
      return;
    }
    if (_model.passwordTextControllerValidator!(
          _model.passwordTextController.text,
        ) !=
        null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await widget.apiStore.authService.login(
        email: _model.emailAddressTextController.text,
        password: _model.passwordTextController.text,
      );
      if (response == true) {
        Navigator.pushNamed(context, '/');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Login Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.of(context).secondaryBackground,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              JarvisTheme.of(context).secondaryBackground,
              JarvisTheme.of(context).secondary,
            ],
            stops: [0, 1],
            begin: AlignmentDirectional(0, -1),
            end: AlignmentDirectional(0, 1),
          ),
        ),
        alignment: AlignmentDirectional(0, -1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 32),
                child: Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'Jarvis.AI',
                    style: JarvisTheme.of(context).displaySmall.copyWith(
                      fontFamily: 'Poppins',
                      color: JarvisTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: JarvisTheme.of(context).secondaryText,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 570),
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: JarvisTheme.of(
                              context,
                            ).displaySmall.copyWith(
                              fontFamily: 'Inter Tight',
                              letterSpacing: 0.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              12,
                              0,
                              24,
                            ),
                            child: Text(
                              'Fill out the information below in order to access your account.',
                              textAlign: TextAlign.center,
                              style: JarvisTheme.of(
                                context,
                              ).labelMedium.copyWith(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              0,
                              0,
                              16,
                            ),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _model.emailAddressTextController,
                                focusNode: _model.emailAddressFocusNode,
                                autofocus: true,
                                autofillHints: [AutofillHints.email],
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: JarvisTheme.of(
                                    context,
                                  ).labelLarge.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          JarvisTheme.of(
                                            context,
                                          ).primaryBackground,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: JarvisTheme.of(context).primary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: JarvisTheme.of(context).alternate,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: JarvisTheme.of(context).alternate,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor:
                                      JarvisTheme.of(context).primaryBackground,
                                ),
                                style: JarvisTheme.of(
                                  context,
                                ).bodyLarge.copyWith(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator:
                                    _model.emailAddressTextControllerValidator,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              0,
                              0,
                              16,
                            ),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _model.passwordTextController,
                                focusNode: _model.passwordFocusNode,
                                autofocus: true,
                                autofillHints: [AutofillHints.password],
                                obscureText: !_model.passwordVisibility,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: JarvisTheme.of(
                                    context,
                                  ).labelLarge.copyWith(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          JarvisTheme.of(
                                            context,
                                          ).primaryBackground,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: JarvisTheme.of(context).primary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: JarvisTheme.of(context).alternate,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: JarvisTheme.of(context).alternate,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor:
                                      JarvisTheme.of(context).primaryBackground,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _model.passwordVisibility =
                                            !_model.passwordVisibility;
                                      });
                                    },
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _model.passwordVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color:
                                          JarvisTheme.of(context).secondaryText,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                style: JarvisTheme.of(
                                  context,
                                ).bodyLarge.copyWith(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                                validator:
                                    _model.passwordTextControllerValidator,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              0,
                              0,
                              16,
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _loginUser,
                              child: Text('Sign In'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    JarvisTheme.of(context).secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                minimumSize: Size(double.infinity, 48),
                                textStyle: JarvisTheme.of(
                                  context,
                                ).titleSmall.copyWith(
                                  fontFamily: 'Inter Tight',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              16,
                              0,
                              16,
                              24,
                            ),
                            child: Text(
                              'Or sign in with',
                              textAlign: TextAlign.center,
                              style: JarvisTheme.of(
                                context,
                              ).labelMedium.copyWith(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              0,
                              0,
                              16,
                            ),
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                // GoRouter.of(context).prepareAuthEvent();

                                // final user = await authManager.signInWithEmail(
                                //   context,
                                //   _model.emailAddressTextController.text,
                                //   _model.passwordTextController.text,
                                // );
                                // if (user == null) {
                                //   return;
                                // }

                                // context.goNamedAuth(
                                //   HomePageWidget.routeName,
                                //   context.mounted,
                                // );
                              },
                              label: Text("Continue with Google"),
                              icon: FaIcon(FontAwesomeIcons.google, size: 20),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 90,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          isAndroid
                              ? Container()
                              : Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  0,
                                  0,
                                  16,
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    // GoRouter.of(context).prepareAuthEvent();
                                    // final user = await authManager
                                    //     .signInWithApple(context);
                                    // if (user == null) {
                                    //   return;
                                    // }

                                    // context.goNamedAuth(
                                    //   HomePageWidget.routeName,
                                    //   context.mounted,
                                    // );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.apple,
                                    size: 20,
                                    color:
                                        JarvisTheme.of(
                                          context,
                                        ).primaryText, // Adjust icon color
                                  ),
                                  label: Text(
                                    'Continue with Apple',
                                    style: JarvisTheme.of(
                                      context,
                                    ).titleSmall.copyWith(
                                      fontFamily: 'Inter Tight',
                                      color:
                                          JarvisTheme.of(context).primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 44),
                                    backgroundColor:
                                        JarvisTheme.of(
                                          context,
                                        ).secondaryBackground,
                                    elevation: 0,
                                    side: BorderSide(
                                      color:
                                          JarvisTheme.of(
                                            context,
                                          ).primaryBackground,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),

                          // You will have to add an action on this rich text to go to your login page.
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              12,
                              0,
                              12,
                            ),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an account?  ',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: 'Sign Up here',
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                              context,
                                              '/signup',
                                            );
                                          },
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodyMedium.copyWith(
                                      fontFamily: 'Inter',
                                      color: JarvisTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                style: JarvisTheme.of(
                                  context,
                                ).bodyMedium.copyWith(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fade(duration: 500.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
