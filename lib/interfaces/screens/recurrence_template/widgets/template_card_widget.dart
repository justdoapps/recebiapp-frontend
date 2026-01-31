import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/dialog_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../domain/dtos/template_upsert_dto.dart';
import '../../../../domain/enum/frequency_enum.dart';
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
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: .spaceBetween,
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
            Text(template.name, style: context.textTheme.largeBold),
            TextButton(
              style: TextButton.styleFrom(
                padding: .zero,
                backgroundColor: (template.active ? context.theme.colorScheme.primary : context.theme.colorScheme.error)
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
              crossAxisAlignment: .start,
              spacing: 10,
              children: [
                const Divider(),

                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.timer_outlined, size: 18),
                        Text(template.frequency.name, style: context.textTheme.verySmall),
                      ],
                    ),
                    if (template.frequency == Frequency.INTERVAL)
                      Text(template.intervalDays.toString(), style: context.textTheme.verySmall),
                    if (template.frequency == Frequency.MONTHLY)
                      Text(template.dayOfMonth.toString(), style: context.textTheme.verySmall),
                    if (template.frequency == Frequency.WEEKLY)
                      Text(template.dayOfWeek.toString(), style: context.textTheme.verySmall),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
