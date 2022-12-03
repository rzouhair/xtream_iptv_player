import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input(
      {this.placeholder = '',
      this.value = '',
      this.obscure = false,
      this.disabled = false,
      required this.onChanged,
      super.key});
  final String placeholder;
  final String value;
  final bool obscure;
  final bool disabled;
  final Function onChanged;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final TextEditingController? controller = TextEditingController();
  @override
  void initState() {
    controller?.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            style: const TextStyle(
              color: Colors.black,
            ),
            controller: controller,
            readOnly: widget.disabled,
            onChanged: (value) {
              widget.onChanged(value);
            },
            obscureText: widget.obscure,
            decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                hintText: widget.placeholder),
          ),
        ),
      ),
    );
  }
}
