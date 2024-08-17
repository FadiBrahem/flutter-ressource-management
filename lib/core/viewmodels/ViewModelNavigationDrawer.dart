import 'package:naxxum_projectplanner_mobile_local/core/constants/routing_constants.dart';
import 'package:naxxum_projectplanner_mobile_local/core/services/NavigationService.dart';
import 'package:naxxum_projectplanner_mobile_local/core/viewmodels/BaseModel.dart';
import '../../locator.dart';

class ViewModelNavigationDrawer extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  void navigateToAddProject() {
    _navigationService.popUntilFirstRoute();
    _navigationService.navigateTo(ajouterProjetRoute);
  }

  void navigateToConsulterProjets() {
    _navigationService.popUntilFirstRoute();
    _navigationService.navigateTo(consulterProjetRoute);
  }

  void navigateToAddTache() {
    _navigationService.popUntilFirstRoute();
    _navigationService.navigateTo(ajouterTacheRoute);
  }

  void navigateToConsulterTaches() {
    _navigationService.popUntilFirstRoute();
    _navigationService.navigateTo(consulterTachesRoute);
  }

  void navigateToSettings() {
    _navigationService.popUntilFirstRoute();
    _navigationService.navigateTo(settingsRoute);
  }

  void navigateToReporting() {
    _navigationService.popUntilFirstRoute();
    _navigationService.navigateTo(reportingRoute);
  }
}
