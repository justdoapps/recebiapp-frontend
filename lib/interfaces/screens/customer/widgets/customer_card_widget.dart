import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/build_context_extension.dart';
import '../../../../core/extensions/dialog_extension.dart';
import '../../../../core/extensions/formatters_extension.dart';
import '../../../../domain/models/customer_model.dart';
import '../components/upsert_customer_component.dart';
import '../customer_view_model.dart';
import '../lang/customer_localization_ext.dart';

class CustomerCardWidget extends StatelessWidget {
  const CustomerCardWidget({super.key, required this.customer, required this.vm});

  final CustomerModel customer;
  final CustomerViewModel vm;

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
                      child: UpsertCustomerComponent(customer: customer),
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
            Column(
              children: [
                Text(customer.name, style: context.textTheme.largeBold),
                Text(customer.type.getCustomerTypeName(context), style: context.textTheme.verySmall),
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: .zero,
                backgroundColor: (customer.active ? context.theme.colorScheme.primary : context.theme.colorScheme.error)
                    .withValues(alpha: 0.1),
                shape: const RoundedRectangleBorder(
                  borderRadius: .all(.circular(10)),
                ),
                side: .none,
              ),
              onPressed: () async {
                final confirm = await context.showConfirmationDialog(
                  title: Text(customer.name, style: context.textTheme.largeBold, textAlign: .center),
                  content: Text(
                    customer.active ? context.words.deactivate : context.words.activate,
                    style: context.textTheme.mediumBold,
                  ),
                );
                if (confirm ?? false) {
                  vm.toggleStatus.execute(customer);
                }
              },
              child: Text(
                customer.active ? context.words.active : context.words.inactive,
                style: TextStyle(
                  fontWeight: .bold,
                  color: customer.active ? context.theme.colorScheme.primary : context.theme.colorScheme.error,
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
                title: Text(customer.name, style: context.textTheme.largeBold, textAlign: .center),
                content: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  spacing: 15,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          '${context.words.createdAt} ${customer.createdAt.toLocaleDateTime(context.locale)}',
                          style: context.textTheme.verySmall,
                        ),
                        Visibility(
                          visible: customer.updatedAt != customer.createdAt,
                          child: Text(
                            '${context.words.updatedAt} ${customer.updatedAt.toLocaleDateTime(context.locale)}',
                            style: context.textTheme.verySmall,
                          ),
                        ),
                      ],
                    ),

                    if (customer.phone?.isNotEmpty ?? false)
                      Row(
                        spacing: 20,
                        children: [
                          Icon(Icons.phone_iphone, color: context.theme.colorScheme.onSurface),
                          Text(customer.phone!, style: context.textTheme.mediumBold),
                        ],
                      ),
                    if (customer.document?.isNotEmpty ?? false)
                      Row(
                        spacing: 20,
                        children: [
                          Icon(Icons.badge, color: context.theme.colorScheme.onSurface),
                          Text(customer.document!, style: context.textTheme.mediumBold),
                        ],
                      ),
                    if (customer.observation?.isNotEmpty ?? false)
                      Text(
                        customer.observation!,
                        style: context.textTheme.medium,
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
                if ((customer.phone?.isNotEmpty ?? false) || (customer.document?.isNotEmpty ?? false))
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      if (customer.phone?.isNotEmpty ?? false)
                        Row(
                          spacing: 10,
                          children: [
                            const Icon(Icons.phone_iphone, size: 18),
                            Text(customer.phone!, style: context.textTheme.verySmall),
                          ],
                        ),
                      if (customer.document?.isNotEmpty ?? false)
                        Row(
                          spacing: 10,
                          children: [
                            const Icon(Icons.badge, size: 18),
                            Text(customer.document!, style: context.textTheme.verySmall),
                          ],
                        ),
                    ],
                  ),

                if (customer.observation?.isNotEmpty ?? false)
                  Row(
                    spacing: 10,
                    children: [
                      const Icon(Icons.info, size: 18),
                      Expanded(
                        child: Text(
                          customer.observation!,
                          style: context.textTheme.verySmall,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                        ),
                      ),
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
