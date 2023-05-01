import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;

  const AuthForm(this.submitFn, this.isLoading, {super.key});

  @override
  State<AuthForm> createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  File? _userImageFile;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void pickImage(File image) {
    _userImageFile = image;
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      SnackBar(content: Text('Please pick an image'));
      return;
    }


    if (isValid) {
      _formKey.currentState!.save();

      //send request to database
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
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
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (!_isLogin) UserImagePicker(pickImage),
              TextFormField(
                key: ValueKey('email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@'))
                    return 'Please enter a valid email address';
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email address'),
                onSaved: (value) {
                  _userEmail = value.toString();
                },
              ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('username'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4)
                      return 'Please enter at least 4 characters';
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'User name'),
                  onSaved: (value) {
                    _userName = value.toString();
                  },
                ),
              TextFormField(
                key: ValueKey('password'),
                validator: (value) {
                  if (value!.isEmpty || value.length < 7)
                    return 'Password must be at least 7 characters long';
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) {
                  _userPassword = value.toString();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'Login' : 'Signup'),
                ),
              if (!widget.isLoading)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? 'Create new account'
                      : 'I already have a account'),
                )
            ]),
          ),
        ),
      ),
    ));
  }
}
