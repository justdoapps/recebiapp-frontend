import 'package:flutter/material.dart';

import '../../../core/extensions/dialog_extension.dart';
import '../../core/adaptive_date_picker.dart';
import '../../core/app_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const AppDrawer(),
      persistentFooterButtons: [
        TextButton(onPressed: () {}, child: const Text('Cancelar')),
        FilledButton(onPressed: () {}, child: const Text('Salvar')),
      ],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Data selecionada: $_selectedDate'),
            ElevatedButton(
              onPressed: () => context.showBottomSheet(
                child: AdaptiveDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  onDateChanged: (newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
              child: const Text('Selecione uma data'),
            ),
          ],
        ),
      ),
    );
  }
}
