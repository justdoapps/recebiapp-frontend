StripeADD: Theme.MaterialComponents (android-app-main-res-values)
-arquivo proguard em android/app/proguard-rules.pro

Campo,Valor
Número do Cartão,4242 4242 4242 4242
Validade (MM/AA),Qualquer data futura (ex: 12/30)
CVC / CVV,Qualquer número de 3 dígitos (ex: 123)
CEP / Zip Code,Qualquer valor (ex: 12345 ou 22021001)

Pagamento recusado por motivo genérico: 4000 0000 0000 0002
Pagamento recusado por fundos insuficientes: 4000 0000 0000 9995
Pagamento recusado por cartão vencido: 4000 0000 0000 0069
Pagamento recusado por CVC incorreto: 4000 0000 0000 0127

//TODO verificar tradução dos dados que vem do stripe nome e descrição do plano e a questão do valor se tem como cadastrar vários preços prom mesmo plano por exemplo 10 reais / 2 dolares...
//TODO implementar pagamentos pelas lojas google e apple pay
