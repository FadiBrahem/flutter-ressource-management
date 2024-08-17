import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/core/managers/dialog_manager.dart';
import 'package:naxxum_projectplanner_mobile_local/core/managers/life_cycle_manager.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/DialogService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/NavigationService.dart';
import 'package:naxxum_projectplanner_mobile_local/locator.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/router.dart' as router;
import 'core/constants/routing_constants.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: I18n(
        initialLocale: const Locale('en','US'),
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', "US"),
            const Locale('fr'),
          ],
          debugShowCheckedModeBanner: false,
          title: 'Ressource Management',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          builder: (context, child) => Navigator(
            key: locator<DialogService>().dialogNavigationKey,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => DialogManager(
                      child: child,
                    )),
          ),
          onGenerateRoute: router.generateRoute,
          initialRoute: homeRoute,
          navigatorKey: locator<NavigationService>().navigationKey,
        ),
      ),
    );
  }
}
