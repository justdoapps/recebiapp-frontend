import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/dialog_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../domain/dtos/template_upsert_dto.dart';
import '../../../../domain/enum/frequency_enum.dart';
import '../../../../domain/enum/transaction_enum.dart';
import '../../../../domain/models/template_model.dart';
import '../../customer/lang/customer_localization_ext.dart';
import '../components/upsert_template_component.dart';
import '../template_view_model.dart';

class TemplateCardWidget extends StatelessWidget {
  const TemplateCardWidget({super.key, required this.template, required this.vm});

  final TemplateModel template;
  final TemplateViewModel vm;

  @override
  Widget build(BuildContext context) {
    final colorType = template.type == TransactionType.INCOME ? Colors.green : Colors.orange;
    return Card(
      color: context.theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(18)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(18),
          border: Border(
            left: BorderSide(color: colorType, width: 5),
            bottom: BorderSide(color: colorType, width: 2),
          ),
        ),

        child: ListTile(
          title: Row(
            mainAxisAlignment: .spaceBetween,
            spacing: 10,
            children: [
              Column(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: .zero,
                    ),
                    onPressed: () {
                      context.showBottomSheet(
                        child: Padding(
                          padding: .only(bottom: context.viewInsetsBottom),
                          child: ChangeNotifierProvider.value(
                            value: vm,
                            child: UpsertTemplateComponent(template: template),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 25,
                      color: context.theme.colorScheme.primary,
                      shadows: [
                        Shadow(
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 5.0,
                          color: context.theme.colorScheme.primary.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: .zero,
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.info,
                      size: 25,
                      color: context.theme.colorScheme.primary,
                      shadows: [
                        Shadow(
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 5.0,
                          color: context.theme.colorScheme.primary.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  template.name,
                  style: context.textTheme.medium,
                  textAlign: .center,
                ),
              ),
              Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: .zero,
                      backgroundColor:
                          (template.active ? context.theme.colorScheme.primary : context.theme.colorScheme.error)
                              .withValues(alpha: 0.1),
                      shape: const RoundedRectangleBorder(
                        borderRadius: .all(.circular(10)),
                      ),
                      side: .none,
                    ),
                    onPressed: () async {
                      final confirm = await context.showConfirmationDialog(
                        title: Text(template.name, style: context.textTheme.largeBold, textAlign: .center),
                        content: Text(
                          template.active ? context.words.deactivate : context.words.activate,
                          style: context.textTheme.mediumBold,
                        ),
                      );
                      if (confirm ?? false) {
                        vm.update.execute(TemplateUpdateDto(id: template.id, active: !template.active));
                      }
                    },
                    child: Text(
                      template.active ? context.words.active : context.words.inactive,
                      style: TextStyle(
                        fontWeight: .bold,
                        color: template.active ? context.theme.colorScheme.primary : context.theme.colorScheme.error,
                      ),
                    ),
                  ),
                  Text(
                    template.type.getTypeName(context),
                    style: context.textTheme.verySmall.copyWith(color: colorType),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Material(
            borderRadius: .circular(10),
            clipBehavior: .antiAlias,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.showInformationDialog(
                  title: Text(template.name, style: context.textTheme.largeBold, textAlign: .center),
                  content: Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    spacing: 15,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            '${context.words.createdAt} ${template.createdAt.toLocaleDateTime(context.locale)}',
                            style: context.textTheme.verySmall,
                          ),
                          Visibility(
                            visible: template.updatedAt != template.createdAt,
                            child: Text(
                              '${context.words.updatedAt} ${template.updatedAt.toLocaleDateTime(context.locale)}',
                              style: context.textTheme.verySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: .end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Divider(
                      color: colorType,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          const Icon(Icons.timer_outlined),
                          Text(template.frequency.getContextName(context), style: context.textTheme.smallBold),
                          if (template.frequency == Frequency.INTERVAL)
                            Text(template.intervalDays.toString(), style: context.textTheme.mediumBold),
                          if (template.frequency == Frequency.MONTHLY)
                            Text(template.dayOfMonth.toString(), style: context.textTheme.mediumBold),
                          if (template.frequency == Frequency.WEEKLY)
                            Text(
                              FrequencyWeekly.fromInt(template.dayOfWeek!).getContextName(context),
                              style: context.textTheme.mediumBold,
                            ),
                        ],
                      ),

                      Text(template.amount.toCurrency(context.locale), style: context.textTheme.mediumBold),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${context.words.createdAt} ${template.createdAt.toLocaleDateTime(context.locale)}',
                    style: context.textTheme.verySmall,
                  ),
                  Visibility(
                    visible: template.updatedAt != template.createdAt,
                    child: Text(
                      '${context.words.updatedAt} ${template.updatedAt.toLocaleDateTime(context.locale)}',
                      style: context.textTheme.verySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
