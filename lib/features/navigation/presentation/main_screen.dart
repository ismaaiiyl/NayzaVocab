import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/core/widgets/nayza_bottom_bar.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NayzaBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        onCentralTap: () => context.pushNamed('create-set'),
      ),
    );
  }
}
