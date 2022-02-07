import 'package:flutter/material.dart';
import 'dart:io';

import '../widgets/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  Function submitForm;
  bool isLoading;

  AuthForm({required this.submitForm, required this.isLoading});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoggedIn = true;

  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';
  File? _userImage;

  void _pickedImage(File image) {
    _userImage = image;
  }

  void _submit() {
    bool isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (_userImage == null && !_isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid && _userImage!.path.isNotEmpty) {
      _formKey.currentState!.save();

      widget.submitForm(
        _userEmail,
        _userName,
        _userPassword,
        _isLoggedIn,
        _userImage,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLoggedIn)
                    UserImagePicker(
                      imagePickerHandler: _pickedImage,
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter valid adress';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLoggedIn)
                    TextFormField(
                      key: const ValueKey('userName'),
                      decoration: const InputDecoration(
                        labelText: 'User name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Please enter valid password with min 6 char';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLoggedIn ? 'Login' : 'Sign up'),
                    ),
                  if (widget.isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoggedIn = !_isLoggedIn;
                        });
                      },
                      child: Text(_isLoggedIn
                          ? 'Create new account'
                          : 'I already have account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
