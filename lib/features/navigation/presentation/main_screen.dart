import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/core/widgets/nayza_bottom_bar.dart';
import 'package:nayza_vocab/core/services/notification_service.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Senior: Request permissions as soon as UI is ready
    NotificationService().requestPermissions();
    
    // Senior: Check if we opened the app from a notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNotificationPayload();
    });
  }

  void _checkNotificationPayload() {
    final payload = NotificationService.lastPayload;
    if (payload != null) {
      NotificationService.lastPayload = null; // Clear it
      if (payload == 'difficult-words') {
        widget.navigationShell.goBranch(2);
      }
    }
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NayzaBottomBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onTap,
        onCentralTap: () => context.goNamed('online-library'),
      ),
    );
  }
}
