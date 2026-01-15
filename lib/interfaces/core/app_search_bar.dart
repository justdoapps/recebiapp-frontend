import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extension.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
    required this.controller,
  });

  final String hintText;
  final void Function(String query) onChanged;
  final VoidCallback onClear;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      backgroundColor: WidgetStatePropertyAll(context.theme.colorScheme.secondaryContainer),
      hintStyle: WidgetStatePropertyAll(context.textTheme.medium),
      controller: controller,
      onChanged: onChanged,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.search,
          color: context.theme.colorScheme.onSecondaryContainer,
          size: 18,
        ),
      ),
      hintText: hintText,
      trailing: [
        IconButton(
          onPressed: onClear,
          icon: Icon(Icons.clear, color: context.theme.colorScheme.onSecondaryContainer, size: 28),
        ),
      ],
    );
  }
}
