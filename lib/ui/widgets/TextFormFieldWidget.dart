import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String labelText;
  final Color labelTextColor;
  final Color counterColor;
  final Color prefixColorIcon;
  final Color suffixColorIcon;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final int maxLines;
  final InputBorder inputBorder;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final FontWeight labelTextFontWeight;
  final ValueChanged<String> onChanged;
  final FocusNode fieldFocusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final TextInputFormatter formatter;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final VoidCallback onEditingComplete;
  final bool isEnabled;
  final TextAlign textAlign;
  final Function onPressedSuffixIcon;

  TextFormFieldWidget(
      {@required this.textEditingController,
      this.onSaved,
      this.onChanged,
      this.onEditingComplete,
      this.textInputAction,
      this.formatter,
      this.validator,
      this.suffixColorIcon,
      this.suffixIcon,
      this.fieldFocusNode,
      this.nextFocusNode,
      this.labelText,
      this.maxLines,
      this.textInputType,
      this.labelTextColor,
      this.labelTextFontWeight,
      this.counterColor,
      this.prefixIcon,
      this.isEnabled,
      this.textAlign,
      this.prefixColorIcon,
      this.onPressedSuffixIcon,
      this.inputBorder});

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: widget.labelTextColor,
            fontWeight: widget.labelTextFontWeight,
          ),
          counterStyle: TextStyle(
            color: widget.counterColor,
          ),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: widget.prefixColorIcon,
          ),
          border: widget.inputBorder),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      enabled: widget.isEnabled,
      controller: widget.textEditingController,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      focusNode: widget.fieldFocusNode,
      inputFormatters: widget.formatter != null ? [widget.formatter] : null,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      onEditingComplete: widget.onEditingComplete,
      /*onEditingComplete: () {
        if (widget.enterPressed != null) {
          FocusScope.of(context).requestFocus(FocusNode());
          widget.enterPressed();
        }
      },*/
      onFieldSubmitted: (value) {
        if (widget.nextFocusNode != null) {
          widget.fieldFocusNode.unfocus();
          widget.nextFocusNode.requestFocus(widget.nextFocusNode);
        } else {
          widget.fieldFocusNode.unfocus();
        }
      },
      validator: widget.validator,
    );
  }
}
