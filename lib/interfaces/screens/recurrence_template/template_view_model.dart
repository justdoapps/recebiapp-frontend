import 'package:flutter/material.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/recurrence_template/template_repository.dart';
import '../../../domain/dtos/template_upsert_dto.dart';
import '../../../domain/models/template_model.dart';
import '../../../domain/use_cases/template_list_use_case.dart';

class TemplateViewModel extends ChangeNotifier {
  final TemplateRepository _repository;
  final TemplateListUseCase _listUseCase;

  TemplateViewModel({required TemplateRepository repository, required TemplateListUseCase listUseCase})
    : _repository = repository,
      _listUseCase = listUseCase {
    list = Command0<void>(_list);
    create = Command1<void, TemplateCreateDto>(_create);
    update = Command1<void, TemplateUpdateDto>(_update);
    delete = Command1<void, TemplateModel>(_delete);
  }

  late Command0<void> list;
  late Command1<void, TemplateCreateDto> create;
  late Command1<void, TemplateUpdateDto> update;
  late Command1<void, TemplateModel> delete;

  List<TemplateModel> _templates = [];
  List<TemplateModel> get templates => _templates;

  Future<Result<void>> _list() async => (await _listUseCase.list()).fold(
    (error) => Result.error(error),
    (value) {
      _templates.clear();
      _templates = List<TemplateModel>.from(value);
      return const Result.ok(null);
    },
  );

  Future<Result<void>> _create(TemplateCreateDto template) async => (await _repository.create(template)).fold(
    (error) => Result.error(error),
    (value) {
      list.execute();
      return const Result.ok(null);
    },
  );

  Future<Result<void>> _update(TemplateUpdateDto template) async => (await _repository.update(template)).fold(
    (error) => Result.error(error),
    (value) {
      list.execute();
      return const Result.ok(null);
    },
  );

  Future<Result<void>> _delete(TemplateModel template) async => (await _repository.delete(template.id)).fold(
    (error) => Result.error(error),
    (value) {
      list.execute();
      notifyListeners();
      return const Result.ok(null);
    },
  );

  @override
  void dispose() {
    list.dispose();
    create.dispose();
    update.dispose();
    delete.dispose();
    super.dispose();
  }
}
