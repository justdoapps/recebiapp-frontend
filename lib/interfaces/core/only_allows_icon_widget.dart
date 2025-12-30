import 'package:flutter/material.dart';

abstract class OnlyAllowsIconWidget implements Widget {}

class AllowIcon extends StatelessWidget implements OnlyAllowsIconWidget {
  final Icon icon;

  const AllowIcon(this.icon, {super.key});

  @override
  Widget build(BuildContext context) => icon;
}

class AllowIconButton extends StatelessWidget implements OnlyAllowsIconWidget {
  final IconButton button;

  const AllowIconButton(this.button, {super.key});

  @override
  Widget build(BuildContext context) => button;
}
