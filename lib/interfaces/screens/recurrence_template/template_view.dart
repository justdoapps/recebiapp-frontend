import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/dialog_extension.dart';
import '../../../core/extensions/message_extension.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../core/drawer/app_drawer.dart';
import 'components/upsert_template_component.dart';
import 'lang/template_localization_ext.dart';
import 'template_view_model.dart';
import 'widgets/template_card_widget.dart';

class TemplateView extends StatefulWidget {
  const TemplateView({super.key});

  @override
  State<TemplateView> createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> with LoadingMixin {
  late final TemplateViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<TemplateViewModel>();
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
        title: context.words.errorGetTemplates,
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
    context.watch<TemplateViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text(context.words.templates)),
      drawer: const AppDrawer(),
      floatingActionButtonLocation: .centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.showBottomSheet(
            child: Padding(
              padding: .only(bottom: context.viewInsetsBottom),
              child: ChangeNotifierProvider.value(
                value: _vm,
                child: const UpsertTemplateComponent(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(context.words.newData),
      ),
      body: RefreshIndicator(
        onRefresh: _vm.list.execute,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: _vm.templates.isEmpty
              ? [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(context.words.noTemplatesFound, style: context.textTheme.large),
                    ),
                  ),
                ]
              : [
                  SliverList.separated(
                    itemBuilder: (context, index) {
                      return TemplateCardWidget(template: _vm.templates[index], vm: _vm);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: _vm.templates.length,
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
        ),
      ),
    );
  }
}
