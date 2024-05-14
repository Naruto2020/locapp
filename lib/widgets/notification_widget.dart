import 'package:flutter/material.dart';
import '../services/notification_services.dart';
import '../themes/theme.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  // Liste  de notifications initialisée vide
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      List<String> fetchedNotifications = await NotificationService.fetchNotifications();
      setState(() {
        notifications = fetchedNotifications;
      });
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length + 1, // Ajout  élément à l'en-tête
      itemBuilder: (context, index) {
        if (index == 0) {
          // Afficher l'en-tête au premier index
          return ListTile(
            title: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w900,
                color: lightColorScheme.primary,
              ),
            ),
          );
        } else {
          // Afficher notifications à partir de l'index 2
          final notificationIndex = index - 1;
          return ListTile(
            title: Text('Notification ${notificationIndex + 1}'),
            subtitle: Text(notifications[notificationIndex]),
            onTap: () {
              // Supprimer la notification
              setState(() {
                notifications.removeAt(notificationIndex);
              });
            },
          );
        }
      },
    );
  }
}
