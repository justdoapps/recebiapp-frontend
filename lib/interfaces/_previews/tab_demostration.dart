import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../core/theme/app_theme.dart';

@Preview(name: 'Tab Demostration')
Widget tabDemostrationPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: const CustomerListScreen(),
  );
}

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplo de tipos. Na vida real, viriam do seu controller/enum
    final tabs = ['Todos', 'VIP', 'Devedores', 'Inativos'];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
          bottom: TabBar(
            isScrollable: true, // Importante se tiver muitos tipos ou telas pequenas
            tabs: tabs.map((type) => Tab(text: type)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((type) {
            // Passamos o tipo para filtrar a lista interna
            return _CustomerListView(filterType: type);
          }).toList(),
        ),
      ),
    );
  }
}

class _CustomerListView extends StatelessWidget {
  final String filterType;

  const _CustomerListView({required this.filterType});

  @override
  Widget build(BuildContext context) {
    // Simulação de dados
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text('Cliente $index ($filterType)'),
          subtitle: const Text('Última compra há 2 dias'),
        );
      },
    );
  }
}
