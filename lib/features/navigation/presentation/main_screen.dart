import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/core/widgets/nayza_bottom_bar.dart';
import 'package:nayza_vocab/core/services/notification_service.dart';
import 'package:nayza_vocab/core/services/app_update_service.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/app_update_dialog.dart';

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
      _checkForAppUpdate();
    });
  }

  Future<void> _checkForAppUpdate() async {
    try {
      final updateInfo = await AppUpdateService().checkForUpdate();
      if (!mounted || updateInfo == null || !updateInfo.hasUpdate) return;
      AppUpdateDialog.show(context, updateInfo);
    } catch (e, stack) {
      debugPrint('Avtomatik yangilanish tekshiruvida xatolik: $e\n$stack');
    }
  }

  void _checkNotificationPayload() {
    final payload = NotificationService.lastPayload;
    if (payload != null) {
      NotificationService.lastPayload = null;
      if (payload == 'difficult-words' && mounted) {
        context.pushNamed('difficult-words');
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
        onCentralTap: () => context.pushNamed('online-library'),
      ),
    );
  }
}
