import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  MyTextField(this._hintText, this._errorText, this._controller, {super.key});
  final TextEditingController _controller;
  final String _hintText;
  final String _errorText;
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._controller,
      decoration: InputDecoration(hintText: widget._hintText),
    );
  }
}
