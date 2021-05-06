import 'package:attendance_system_app/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail;
  String _userPassword;
  bool isLoading = false;

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false)
            .login(_userEmail, _userPassword);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json.decode(error.response.toString())['message']),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          'assets/logo.png',
          width: 120,
          height: 120,
        ),
        Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 36,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      _userEmail = value;
                    },
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);

                      if (value.isEmpty) {
                        return 'Please Enter your Email ID';
                      }
                      if (!regex.hasMatch(value)) {
                        return 'Enter a valid Email ID.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      _userPassword = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.vpn_key),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 36.0,
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Login'),
                          ),
                          onPressed: _trySubmit,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
