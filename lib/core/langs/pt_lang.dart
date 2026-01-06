import '../../interfaces/screens/auth/lang/auth_pt_lang.dart';
import 'keys_lang.dart';

abstract class PtLang {
  static final words = <String, String>{
    KeysLang.tryAgain: 'Tentar novamente',
    KeysLang.appName: 'RecebiApp',
    KeysLang.home: 'Inicio',
    KeysLang.logout: 'Sair',
    KeysLang.appDescription: 'Melhor app para gerenciar pagamentos!',
    KeysLang.email: 'Email',
    KeysLang.password: 'Senha',
    KeysLang.back: 'Voltar',
    KeysLang.confirmPassword: 'Confirmar senha',
    KeysLang.name: 'Nome',
    KeysLang.requiredField: 'Campo obrigatório',
    KeysLang.invalidEmail: 'Email inválido',
    KeysLang.minLength: 'Minimo de {min} caracteres',
    KeysLang.passwordsDontMatch: 'Senhas não coincidem',
    KeysLang.or: 'ou',
    KeysLang.cancel: 'Cancelar',
    KeysLang.confirm: 'Confirmar',
    KeysLang.themeMode: 'Aparência',
    KeysLang.darkMode: 'Modo Escuro',
    KeysLang.lightMode: 'Modo Claro',
    KeysLang.free: 'Plano gratuito',
    KeysLang.freeTrial: 'Plano premium teste',
    KeysLang.premiumMensal: 'Plano premium mensal',
    KeysLang.premiumManual: 'Plano premium anual',
    KeysLang.monetizationPage: 'Assinatura do app',
  };

  static const wordsAuth = AuthPtLang;
}
