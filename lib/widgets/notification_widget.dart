import 'package:flutter/material.dart';

import '../themes/theme.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key});

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  // Liste de données de notifications
  List<String> notifications = [
    'Notification 1: Description de la notification 1',
    'Notification 2: Description de la notification 2',
    'Notification 3: Description de la notification 3',
  ];

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
                  color: lightColorScheme.primary
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
              // Supprimer la notification lorsque l'utilisateur appuie dessus
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
