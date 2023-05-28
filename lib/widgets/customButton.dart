import 'package:cleanup_worker/appTheme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({this.onTap, this.text, this.color});

  final VoidCallback onTap;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color != null ? color : AppTheme.getTheme().primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              blurRadius: 8,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: onTap,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 27,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
