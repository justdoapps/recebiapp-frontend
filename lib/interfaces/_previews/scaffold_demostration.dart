import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../core/theme/app_theme.dart';

@Preview(name: 'Scaffold Demostration')
Widget colorsInspectorPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: const ScaffoldDemostration(),
  );
}

class ScaffoldDemostration extends StatelessWidget {
  const ScaffoldDemostration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hierarquia do Scaffold')),

      // 1. O Corpo (ocupa o espaço restante)
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (c, i) => ListTile(title: Text('Item da Lista $i')),
      ),

      // 2. A Folha Persistente (Overlay sobre a lista)
      bottomSheet: Container(
        height: 80,
        width: double.infinity, // Ocupa largura toda
        color: Colors.amber.withValues(alpha: 0.9), // Transparente para ver a lista atrás
        alignment: Alignment.center,
        child: const Text('Bottom Sheet (Persistente - Player de Música)'),
      ),

      // 3. Botões de Rodapé (Ações fixas)
      persistentFooterButtons: [
        OutlinedButton(onPressed: () {}, child: const Text('Voltar')),
        FilledButton(onPressed: () {}, child: const Text('Confirmar')),
      ],

      // 4. Navegação (Base absoluta)
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),

      // Bônus: O FAB flutua acima do BottomSheet por padrão
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
