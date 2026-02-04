import 'package:flutter/material.dart';

import '../../../data/repositories/recurrence/recurrence_repository.dart';

class RecurrenceViewModel extends ChangeNotifier {
  final RecurrenceRepository _repository;

  RecurrenceViewModel({
    required RecurrenceRepository repository,
  }) : _repository = repository;
}
