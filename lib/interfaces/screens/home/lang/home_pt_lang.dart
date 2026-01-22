import 'home_keys_lang.dart';

abstract class HomePtLang {
  static const words = <String, String>{
    HomeKeysLang.errorGetTransactions: 'Erro ao buscar transações',
    HomeKeysLang.noTransactionsFound: 'Nenhuma transação encontrada',
    HomeKeysLang.errorCreateTransaction: 'Erro ao criar transação',
    HomeKeysLang.transactionCreated: 'Transação criada',
    HomeKeysLang.errorUpdateTransaction: 'Erro ao atualizar transação',
    HomeKeysLang.transactionUpdated: 'Transação atualizada',
    HomeKeysLang.amount: 'Valor',
    HomeKeysLang.dueDate: 'Data de vencimento',
    HomeKeysLang.customerNote: 'Observação para o cliente',
    HomeKeysLang.internalNote: 'Observação somente interna',
    HomeKeysLang.paymentInfo: 'Informações de pagamento',
    HomeKeysLang.description: 'Descrição',
  };
}
