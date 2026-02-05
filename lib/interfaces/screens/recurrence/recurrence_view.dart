import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/dialog_extension.dart';
import '../../../core/extensions/message_extension.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../core/drawer/app_drawer.dart';
import '../recurrence_template/components/upsert_template_component.dart';
import 'components/update_recurrence_component.dart';
import 'lang/recurrence_localization_ext.dart';
import 'recurrence_view_model.dart';
import 'widgets/recurrence_card_widget.dart';

class RecurrenceView extends StatefulWidget {
  const RecurrenceView({super.key});

  @override
  State<RecurrenceView> createState() => _RecurrenceViewState();
}

class _RecurrenceViewState extends State<RecurrenceView> with LoadingMixin {
  late final RecurrenceViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<RecurrenceViewModel>();
    _vm.list.addListener(_listenerCommandList);
    _vm.list.execute();
  }

  @override
  void dispose() {
    _vm.list.removeListener(_listenerCommandList);
    super.dispose();
  }

  void _listenerCommandList() {
    _vm.list.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.list.error) {
      context.showMessage(
        title: context.words.errorGetRecurrences,
        actionLabel: context.words.tryAgain,
        onAction: () {
          _vm.list.clearResult();
          _vm.list.execute();
        },
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<RecurrenceViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text(context.words.recurrences)),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _vm.list.execute,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: _vm.recurrences.isEmpty
              ? [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(context.words.noRecurrencesFound, style: context.textTheme.large),
                    ),
                  ),
                ]
              : [
                  SliverList.separated(
                    itemBuilder: (context, index) {
                      return RecurrenceCardWidget(recurrence: _vm.recurrences[index], vm: _vm);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: _vm.recurrences.length,
                  ),
                ],
        ),
      ),
    );
  }
}
