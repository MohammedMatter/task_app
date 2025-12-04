import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFormFieldStyle extends StatelessWidget {
  TextEditingController? textEditingController;
  VoidCallback? method;
  String? hint;
  String? Function(String?)? validator;
  Widget? icon;
  TextInputType? textInputType;
  int? maxLines;
  int? minLines;

  TextFormFieldStyle({
    this.validator,
    this.minLines,
    this.textInputType,
    this.maxLines,
    this.method,
    this.textEditingController,
    required this.hint,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: SizedBox(
        width: width,
        child: TextFormField(
          validator: validator,
          onTap: method,
          minLines: minLines,
          keyboardType: textInputType,
          maxLines: maxLines,
          controller: textEditingController,
          decoration: InputDecoration(
            errorMaxLines: 2,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: width * 0.04,
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 14, 113, 179).withOpacity(0.15),
            prefixIcon: icon,
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(
              vertical: height * 0.01,
              horizontal: width * 0.03,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(width * 0.03)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(width * 0.03)),
            ),
          ),
        ),
      ),
    );
  }
}
