import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Classe abstrata para forçar a implementação das duas versões
abstract class PlatformWidget<M extends Widget, C extends Widget> extends StatelessWidget {
  const PlatformWidget({super.key});

  M buildMaterialWidget(BuildContext context);
  C buildCupertinoWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return buildCupertinoWidget(context);
    }
    return buildMaterialWidget(context);
  }
}
