import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/dialog_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../domain/dtos/recurrence_upsert_dto.dart';
import '../../../../domain/enum/frequency_enum.dart';
import '../../../../domain/enum/transaction_enum.dart';
import '../../../../domain/models/recurrence_model.dart';
import '../../customer/lang/customer_localization_ext.dart';
import '../components/update_recurrence_component.dart';
import '../recurrence_view_model.dart';

class RecurrenceCardWidget extends StatelessWidget {
  final RecurrenceModel recurrence;
  final RecurrenceViewModel vm;

  const RecurrenceCardWidget({super.key, required this.recurrence, required this.vm});

  @override
  Widget build(BuildContext context) {
    final colorType = recurrence.type == TransactionType.INCOME ? Colors.green : Colors.orange;
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
                            child: UpdateRecurrenceComponent(recurrence: recurrence),
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
                  recurrence.description,
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
                          (recurrence.isActive ? context.theme.colorScheme.primary : context.theme.colorScheme.error)
                              .withValues(alpha: 0.1),
                      shape: const RoundedRectangleBorder(
                        borderRadius: .all(.circular(10)),
                      ),
                      side: .none,
                    ),
                    onPressed: () async {
                      final confirm = await context.showConfirmationDialog(
                        title: Text(recurrence.description, style: context.textTheme.largeBold, textAlign: .center),
                        content: Text(
                          recurrence.isActive ? context.words.deactivate : context.words.activate,
                          style: context.textTheme.mediumBold,
                        ),
                      );
                      if (confirm ?? false) {
                        vm.update.execute(RecurrenceUpdateDto(id: recurrence.id, isActive: !recurrence.isActive));
                      }
                    },
                    child: Text(
                      recurrence.isActive ? context.words.active : context.words.inactive,
                      style: TextStyle(
                        fontWeight: .bold,
                        color: recurrence.isActive
                            ? context.theme.colorScheme.primary
                            : context.theme.colorScheme.error,
                      ),
                    ),
                  ),
                  Text(
                    recurrence.type.getTypeName(context),
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
                  title: Text(recurrence.description, style: context.textTheme.largeBold, textAlign: .center),
                  content: Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    spacing: 15,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            '${context.words.createdAt} ${recurrence.createdAt.toLocaleDateTime(context.locale)}',
                            style: context.textTheme.verySmall,
                          ),
                          Visibility(
                            visible: recurrence.updatedAt != recurrence.createdAt,
                            child: Text(
                              '${context.words.updatedAt} ${recurrence.updatedAt.toLocaleDateTime(context.locale)}',
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
                    padding: const .only(bottom: 6),
                    child: Divider(
                      color: colorType,
                    ),
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      const Icon(Icons.person_outline),
                      Text(recurrence.customer.name, style: context.textTheme.mediumBold),
                      const Spacer(),
                      if (recurrence.customer.phone != null) ...[
                        const Icon(Icons.phone_outlined),
                        Text(recurrence.customer.phone!, style: context.textTheme.mediumBold),
                      ],
                    ],
                  ),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          const Icon(Icons.timer_outlined),
                          Text(recurrence.frequency.getContextName(context), style: context.textTheme.smallBold),
                          if (recurrence.frequency == Frequency.INTERVAL)
                            Text(recurrence.intervalDays.toString(), style: context.textTheme.mediumBold),
                          if (recurrence.frequency == Frequency.MONTHLY)
                            Text(recurrence.dayOfMonth.toString(), style: context.textTheme.mediumBold),
                          if (recurrence.frequency == Frequency.WEEKLY)
                            Text(
                              FrequencyWeekly.fromInt(recurrence.dayOfWeek!).getContextName(context),
                              style: context.textTheme.mediumBold,
                            ),
                        ],
                      ),

                      Text(recurrence.amount.toCurrency(context.locale), style: context.textTheme.mediumBold),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${context.words.createdAt} ${recurrence.createdAt.toLocaleDateTime(context.locale)}',
                    style: context.textTheme.verySmall,
                  ),
                  Visibility(
                    visible: recurrence.updatedAt != recurrence.createdAt,
                    child: Text(
                      '${context.words.updatedAt} ${recurrence.updatedAt.toLocaleDateTime(context.locale)}',
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
