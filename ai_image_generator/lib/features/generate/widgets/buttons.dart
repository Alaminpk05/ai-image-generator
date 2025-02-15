import 'package:flutter/material.dart';

class SaveAndShareButtonWidget extends StatelessWidget {
  const SaveAndShareButtonWidget({
    super.key,
    required this.title,
    required this.onTap, required this.height, required this.width,
  });
  final String title;
  final VoidCallback onTap;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        fixedSize: Size(width, height),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white, fontSize: 19),
      ),
    );
  }
}