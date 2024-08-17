import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

  static var _t = Translations("en_us") +
    {
      "en_us": "Settings",
      "fr": "Paramétres",
    }+
    {
      "en_us": "New Project",
      "fr": "Nouveau Projet",
    }+
    {
      "en_us": "Title",
      "fr": "Titre",
    }+
    {
      "en_us": "Description",
      "fr": "Description",
    }+
    {
      "en_us": "Start Date",
      "fr": "Date Début",
    }+
    {
      "en_us": "End Date",
      "fr": "Date Fin",
    }+
    {
      "en_us": "Status",
      "fr": "Statut",
    }+
    {
      "en_us": "Assign Resources",
      "fr": "Affecter Ressources",
    }+
    {
      "en_us": "Save",
      "fr": "Enregistrer",
    }+
    {
      "en_us": "Title should not be empty",
      "fr": "Le titre ne doit pas être vide",
    }+
    {
      "en_us": "Description should not be empty",
      "fr": "La description ne doit pas être vide",
    };

  String get i18n => localize(this, _t);
}