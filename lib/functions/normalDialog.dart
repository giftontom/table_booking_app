import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String displayText, bool showError) async {
  return AwesomeDialog(
    context: context,
    dialogType: showError ? DialogType.ERROR : DialogType.SUCCES,
    borderSide: BorderSide(color: Colors.green, width: 2),
    width: MediaQuery.of(context).size.width,
    buttonsBorderRadius: BorderRadius.all(Radius.circular(4)),
    headerAnimationLoop: false,
    animType: AnimType.BOTTOMSLIDE,
    title: showError ? 'Oops!' : 'Hurray!',
    desc: displayText,
    showCloseIcon: true,
    btnOkOnPress: () {},
    btnOkIcon: Icons.check_circle,
  )..show();
}