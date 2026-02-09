import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../../core/extensions/formatters_extension.dart';
import '../../domain/enum/transaction_enum.dart';
import '../../domain/models/transaction_model.dart';

class NotificationService {
  NotificationService() {
    _initNotification();
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _initNotification() async {
    // Inicializa fusos horários para agendamentos
    tz.initializeTimeZones();

    // Configurações específicas para Android (ícone deve estar em res/drawable)
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Configurações para iOS (solicita permissões ao inicializar se desejar)
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // _notificationsPlugin.resolvePlatformSpecificImplementation<
    // AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotification,
    );
  }

  void _onDidReceiveNotification(NotificationResponse response) {
    // Lógica para quando o usuário clica na notificação (ex: navegar via GoRouter)
    final String? payload = response.payload;
    if (payload != null) {
      print('Notification payload: $payload');
    }
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel', // ID do canal
        'Main Notifications', // Nome do canal
        channelDescription: 'Canal principal de notificações do app',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// Agenda uma notificação para uma data e hora específicas
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // 1. Validar se a data não é no passado
    if (scheduledDate.isBefore(DateTime.now())) {
      throw Exception("A data agendada deve ser no futuro.");
    }

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      // 2. Converte DateTime local para o fuso horário do dispositivo
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, // Garante entrega mesmo em modo de economia
    );
  }

  /// Cancela uma notificação específica por ID
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  /// Cancela todas as notificações agendadas
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  int _fastHash(String transactionId) {
    return transactionId.hashCode.abs();
  }

  Future<void> scheduleNotifications(List<TransactionModel> transactions) async {
    for (var transaction in transactions) {
      // 1. Pular se já estiver paga ou vencida
      if (transaction.status != TransactionStatus.PENDING || transaction.dueDate.isBefore(DateTime.now())) {
        // Opcional: Cancelar caso o usuário tenha marcado como paga agora
        await cancelNotification(_fastHash(transaction.id));
        continue;
      }

      // 2. Agendar (ou atualizar se o ID for o mesmo)
      await scheduleNotification(
        id: _fastHash(transaction.id),
        title: 'Vencimento hoje!',
        body: 'A conta "${transaction.description}" vence hoje.',
        scheduledDate: _parseToMorning(transaction.dueDate),
        payload: transaction.id,
      );
    }
  }

  // Boa prática: Notificar pela manhã (ex: 08:00) do dia do vencimento
  DateTime _parseToMorning(DateTime date) {
    return DateTime(date.year, date.month, date.day, 9);
  }

  Future<List<PendingNotificationRequest>> listPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    return _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(),
      payload: payload,
    );
  }
}
