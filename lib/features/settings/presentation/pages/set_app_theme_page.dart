import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/common/cubits/theme/theme_cubit.dart';
import '../../../../core/common/widgets/app_button.dart';

class SetAppThemePage extends StatefulWidget {
  const SetAppThemePage({super.key});

  @override
  State<SetAppThemePage> createState() => _SetAppThemePageState();
}

class _SetAppThemePageState extends State<SetAppThemePage> {
  late ThemeMode selectedThemeMode;

  @override
  void initState() {
    super.initState();
    selectedThemeMode = context.read<ThemeCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('App Theme'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 12,
            children: [
              buildListTile(
                title: 'System Default',
                icon: Icons.settings_outlined,
                themeMode: ThemeMode.system,
              ),
              Divider(),
              buildListTile(
                title: 'Light Theme',
                icon: Icons.light_mode_outlined,
                themeMode: ThemeMode.light,
              ),
              buildListTile(
                title: 'Dark Theme',
                icon: Icons.dark_mode_outlined,
                themeMode: ThemeMode.dark,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
          child: AppButton(
            text: 'Apply Changes',
            trailing: Icon(Icons.check),
            onPressed: () {
              GetIt.instance<ThemeCubit>().setTheme(selectedThemeMode);
            },
          ),
        ),
      ),
    );
  }

  Widget buildListTile({
    required String title,
    required IconData icon,
    required ThemeMode themeMode,
  }) {
    final isSelected = selectedThemeMode == themeMode;
    return ListTile(
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.surface,
      leading: Icon(icon, size: 18),
      title: Text(title),
      trailing: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
          size: 20),
      onTap: () => setState(() {
        selectedThemeMode = themeMode;
      }),
    );
  }
}
