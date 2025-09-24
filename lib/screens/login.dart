import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.trim().isNotEmpty &&
              _passwordController.text.trim().isNotEmpty;
    });
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    final Uri url = Uri.parse(
        'https://hrm.qbit-tech.com/api/emp-login?user_email=$email&password=$password');

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('token', responseData['data']['token']);
          await prefs.setString('user_name', responseData['data']['user']['name']);
          await prefs.setString('user_email', responseData['data']['user']['email']);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful"), backgroundColor: Color(0xFF0062CA),),
          );

          if (_rememberMe) {
            await prefs.setString('saved_email', email);
            await prefs.setString('saved_password', password);
          } else {
            await prefs.remove('saved_email');
            await prefs.remove('saved_password');
          }

          if (mounted) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        } else {
          _showError(responseData['message'] ?? 'Invalid credentials.');
        }
      } else {
        _showError('Invalid email or password');
      }
    } catch (e) {
      _showError('Network error. Check your connection.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(height: height * 0.15),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/Qbit_Logo_White.png',
                          height: height * 0.15,
                          width: width * 0.7,
                          fit: BoxFit.contain,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                        SizedBox(height: height * 0.035),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Sign in now to get access to your account',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF308DCC),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08, vertical: height * 0.025),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _emailController,
                          hintText: "Email Address",
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: height * 0.015),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: "Password",
                          icon: Icons.key,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              side: const BorderSide(color: Colors.white),
                              fillColor: const MaterialStatePropertyAll<Color>(
                                  Colors.transparent),
                              checkColor: Colors.white,
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                  color: Color(0xFF308DCC), fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.015),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed:
                          _isButtonEnabled ? _login : null, // Disabled if empty
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonEnabled
                                ? const Color(0xFF0062CA)
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            minimumSize:
                            Size(double.infinity, height * 0.05),
                          ),
                          child: const Text('Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: height * 0.015),
                        TextButton(
                          onPressed: () {},
                          child: Column(
                            children: [
                              const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Color(0xFF308DCC), fontSize: 15),
                              ),
                              Container(
                                  height: 1.5, width: 130, color: Colors.white24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 8.0),
          child: Icon(icon, color: Colors.black, size: 18),
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white24, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
