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
    HomeKeysLang.dueDate: 'Vencimento',
    HomeKeysLang.paidAt: 'Pagamento',
    HomeKeysLang.customerNote: 'Observação para o cliente',
    HomeKeysLang.internalNote: 'Observação somente interna',
    HomeKeysLang.paymentInfo: 'Informações de pagamento',
    HomeKeysLang.description: 'Descrição',
    HomeKeysLang.confirmDelete: 'Deseja excluir a transação?',
    HomeKeysLang.confirmDeleteWarning:
        'Essa operação não tem volta, os dados realmente serão excluidos da sua conta. Cancelar gera o mesmo efeito mantendo os dados da transação.',
    HomeKeysLang.confirmClearFiles: 'Deseja remover todos os arquivos?',
    HomeKeysLang.clearAll: 'Limpar todos',
    HomeKeysLang.addFiles: 'Adicionar arquivos',
    HomeKeysLang.confirmRemoveFile: 'Deseja remover o arquivo {{fileName}}?',
    HomeKeysLang.selectDatePayment: 'Selecione a data do pagamento',
    HomeKeysLang.confirmCancelPayment: 'Deseja cancelar o pagamento e reabrir a transação?',
    HomeKeysLang.cancelAll: 'Cancelar selecionados',
    HomeKeysLang.payAll: 'Pagar selecionados',
    HomeKeysLang.confirmCancelAll: 'Deseja cancelar todos os {{quantity}} selecionados?',
  };
}
