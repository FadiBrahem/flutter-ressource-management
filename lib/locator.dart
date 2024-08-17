import 'package:get_it/get_it.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/DialogService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/ResourceService.dart';
import 'core/services/NavigationService.dart';
import 'core/services/ProjectService.dart';
import 'core/services/TachesService.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<ProjectService>(() => ProjectService());
  locator.registerLazySingleton<TachesService>(() => TachesService());
  locator.registerLazySingleton<ResourceService>(()=>ResourceService());
}
