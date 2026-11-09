import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tools_app/app/controllers/app_shell_controller.dart';
import 'package:tools_app/app/data/tool_catalog.dart';
import 'package:tools_app/app/navigation/navigation_panel.dart';
import 'package:tools_app/app/navigation/topbar.dart';
import 'package:tools_app/app/screens/home_screen.dart';
import 'package:tools_app/app/screens/tool_screen.dart';
import 'package:tools_app/app/screens/tool_screen_factory.dart';
import 'package:tools_app/core/theme/app_colors.dart';


class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AppShellController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AppShellController());
  }

  @override
  void dispose() {
    Get.delete<AppShellController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;

    return Obx(() {
      final selected = controller.selectedIndex.value;

      final pages = <Widget>[
        HomeScreen(onOpenTool: controller.selectPage),
        ...List<Widget>.generate(toolCatalog.length, (index) {
          return ToolScreen(
            key: ValueKey('tool-$index'),
            toolIndex: index,
            onHome: controller.goHome,
            contentBuilder: (toolController) =>
                buildToolScreen(index, toolController),
          );
        }),
      ];

      return Scaffold(
        key: _scaffoldKey,
        drawer: wide
            ? null
            : Drawer(
                backgroundColor: AppColors.panel,
                child: SafeArea(
                  child: NavigationPanel(
                    selected: selected,
                    onSelect: (index) {
                      controller.selectPage(index);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
        body: SafeArea(
          child: Row(
            children: [
              if (wide)
                SizedBox(
                  width: 250,
                  child: NavigationPanel(
                    selected: selected,
                    onSelect: controller.selectPage,
                  ),
                ),
              if (wide) const VerticalDivider(width: 1, color: AppColors.line),
              Expanded(
                child: Column(
                  children: [
                    AppTopBar(
                      showMenu: !wide,
                      onHome: controller.goHome,
                      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    Expanded(
                      child: IndexedStack(index: selected, children: pages),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: wide
            ? null
            : NavigationBar(
                selectedIndex: selected == 0 ? 0 : 1,
                onDestinationSelected: (index) {
                  if (index == 0) {
                    controller.goHome();
                  } else {
                    _scaffoldKey.currentState?.openDrawer();
                  }
                },
                backgroundColor: AppColors.panel,
                indicatorColor: AppColors.lime.withValues(alpha: .15),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.grid_view_rounded),
                    selectedIcon: Icon(
                      Icons.grid_view_rounded,
                      color: AppColors.lime,
                    ),
                    label: 'Overview',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.widgets_outlined),
                    label: 'All tools',
                  ),
                ],
              ),
      );
    });
  }
}
