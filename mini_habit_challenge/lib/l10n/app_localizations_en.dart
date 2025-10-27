// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mini Habit Challenge';

  @override
  String get tabChallenges => 'Challenges';

  @override
  String get tabStatistics => 'Statistics';

  @override
  String get tabAbout => 'About';

  @override
  String get noHabits => 'No habits yet. Press ➕ to add one!';

  @override
  String get addHabit => 'Add new challenge';

  @override
  String get habitName => 'Habit Name';

  @override
  String get habitNameHint => 'E.g., Drink 2L of water';

  @override
  String get durationInDays => 'Duration (in days)';

  @override
  String get create => 'Create';

  @override
  String get day => 'Day';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get challengeComplete =>
      'You have successfully completed the challenge!';

  @override
  String get createNewChallenge => 'Create new challenge';

  @override
  String get aboutGroupInfo => 'Information about your development team...';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get welcomeMessage =>
      'Build great habits, one small day at a time. Let\'s start your first challenge!';

  @override
  String get getStarted => 'Get Started';
}
