import '../../../../core/langs/app_localization.dart';
import 'template_keys_lang.dart';

extension TemplateLocalization on AppLocalization {
  String get errorGetTemplates => getWord(TemplateKeysLang.errorGetTemplates);
  String get noTemplatesFound => getWord(TemplateKeysLang.noTemplatesFound);
  String get templates => getWord(TemplateKeysLang.templates);
  String get frequency => getWord(TemplateKeysLang.frequency);
  String get errorCreateTemplate => getWord(TemplateKeysLang.errorCreateTemplate);
  String get errorUpdateTemplate => getWord(TemplateKeysLang.errorUpdateTemplate);
  String get templateCreated => getWord(TemplateKeysLang.templateCreated);
  String get templateUpdated => getWord(TemplateKeysLang.templateUpdated);
}
