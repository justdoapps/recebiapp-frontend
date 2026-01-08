import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/message_extension.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../core/app_drawer.dart';
import 'lang/monetization_localization_ext.dart';
import 'monetization_view_model.dart';
import 'widgets/current_plan_widget.dart';
import 'widgets/plan_card_widget.dart';

class MonetizationView extends StatefulWidget {
  const MonetizationView({super.key});

  @override
  State<MonetizationView> createState() => _MonetizationViewState();
}

class _MonetizationViewState extends State<MonetizationView> with LoadingMixin {
  late final MonetizationViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<MonetizationViewModel>();
    _vm.getPlans.addListener(_getPlansCommand);
    _vm.createSubscription.addListener(_createSubscriptionCommand);
    _vm.createAnnualPlan.addListener(_createAnnualPlanCommand);
  }

  @override
  void dispose() {
    _vm.getPlans.removeListener(_getPlansCommand);
    _vm.createSubscription.removeListener(_createSubscriptionCommand);
    _vm.createAnnualPlan.removeListener(_createAnnualPlanCommand);
    super.dispose();
  }

  void _getPlansCommand() {
    _vm.getPlans.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.getPlans.error) {
      context.showMessage(
        title: context.words.getPlansFailed,
        actionLabel: context.words.tryAgain,
        onAction: () {
          _vm.getPlans.clearResult();
          _vm.getPlans.execute();
        },
      );
    }
  }

  void _paymentError({required String title, String? message}) {
    context.showMessage(
      title: title,
      message: message,
      cancelLabel: context.words.cancel,
      type: MessageType.error,
      onCancel: () {
        _vm.createSubscription.clearResult();
      },
    );
  }

  void _paymentSuccess() {
    context.showMessage(
      title: context.words.paymentSuccess,
      actionLabel: context.words.back,
      onAction: () {
        _vm.createSubscription.clearResult();
      },
    );
  }

  Future<void> _showPaymentSheet(MonetizationResultArgs args) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: args.clientSecret,
          customerEphemeralKeySecret: args.ephemeralKey,
          customerId: args.customerId,
          merchantDisplayName: 'RecebiApp',
          style: context.theme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      _paymentSuccess();
    } on StripeException catch (e) {
      // O usuário cancelou ou houve erro no processamento do cartão
      if (e.error.code == FailureCode.Canceled) {
        if (mounted) _paymentError(title: context.words.paymentCanceled);
      } else {
        if (mounted) _paymentError(title: context.words.paymentGenericError, message: e.error.localizedMessage);
      }
    } catch (e) {
      if (mounted) _paymentError(title: context.words.paymentGenericError, message: e.toString());
    }
  }

  Future<void> _createSubscriptionCommand() async {
    _vm.createSubscription.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.createSubscription.error) _paymentError(title: context.words.createPaymentFailed);

    if (_vm.createSubscription.completed) {
      final result = _vm.createSubscription.value;
      if (result != null) await _showPaymentSheet(result);
      _vm.createSubscription.clearResult();
    }
  }

  Future<void> _createAnnualPlanCommand() async {
    _vm.createAnnualPlan.running ? showGlobalLoader() : hideGlobalLoader();
    if (_vm.createAnnualPlan.error) _paymentError(title: context.words.createPaymentFailed);

    if (_vm.createAnnualPlan.completed) {
      final result = _vm.createAnnualPlan.value;
      if (result != null) await _showPaymentSheet(result);
      _vm.createAnnualPlan.clearResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MonetizationViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.words.plans),
      ),
      drawer: const AppDrawer(),
      body:
          _vm.currentPlan !=
              null //TODO ajustar o current plan para o id do plano
          ? CurrentPlanWidget(
              plan: _vm.plans.firstWhere(
                (plan) => plan.amountCents == (_vm.currentPlan! == 'PREMIUM_MENSAL' ? 1000 : 10000),
              ),
            )
          : SingleChildScrollView(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => PlanCardWidget(
                  plan: _vm.plans[index],
                  onTap: () {
                    if (_vm.plans[index].interval == 'ONE_TIME') {
                      _vm.createAnnualPlan.execute(_vm.plans[index].id);
                    } else {
                      _vm.createSubscription.execute(_vm.plans[index].id);
                    }
                  },
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemCount: _vm.plans.length,
              ),
            ),
    );
  }
}
