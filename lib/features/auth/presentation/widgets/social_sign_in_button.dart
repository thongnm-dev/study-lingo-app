import 'package:flutter/material.dart';

/// Outlined full-width social provider button. Uses an icon glyph as a stand-in
/// for the brand logo — drop in the official Google/Facebook asset later.
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        textStyle: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
