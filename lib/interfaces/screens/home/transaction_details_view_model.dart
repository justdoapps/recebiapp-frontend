import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/result.dart';
import '../../../data/repositories/transaction/transaction_repository.dart';
import '../../../domain/models/transaction_model.dart';

class TransactionDetailsViewModel extends ChangeNotifier {
  final TransactionRepository _repository;

  TransactionDetailsViewModel({
    required TransactionRepository repository,
  }) : _repository = repository {
    downloadAttachment = Command1<void, TransactionModel>(_downloadAttachment);
    // deleteAttachment = Command1<void, TransactionModel>(_deleteAttachment);
  }

  late Command1<void, TransactionModel> downloadAttachment;
  // late Command1<void, TransactionModel> deleteAttachment;

  Future<Result<void>> _downloadAttachment(TransactionModel transaction) async =>
      (await _repository.downloadAttachment(
        idAttachment: transaction.attachmentId!,
        idTransaction: transaction.id,
        fileName: transaction.attachmentName!,
      )).fold(
        (error) => Result.error(error),
        (file) {
          final params = ShareParams(text: transaction.description, files: [XFile(file.path)]);
          SharePlus.instance.share(params);
          return const Result.ok(null);
        },
      );

  // Future<Result<void>> _deleteAttachment(TransactionModel transaction) async =>
  //     (await _repository.deleteAttachment(
  //       idAttachment: transaction.attachmentId!,
  //       idTransaction: transaction.id,
  //     )).fold(
  //       (error) => Result.error(error),
  //       (value) {

  //         return const Result.ok(null);

  //       },
  //     );

  @override
  void dispose() {
    downloadAttachment.dispose();
    // deleteAttachment.dispose();
    super.dispose();
  }
}
