import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'Thử Thách Mini'**
  String get appName;

  /// No description provided for @tabChallenges.
  ///
  /// In vi, this message translates to:
  /// **'Thử thách'**
  String get tabChallenges;

  /// No description provided for @tabStatistics.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get tabStatistics;

  /// No description provided for @tabAbout.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin'**
  String get tabAbout;

  /// No description provided for @noHabits.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thử thách nào. Nhấn ➕ để thêm!'**
  String get noHabits;

  /// No description provided for @addHabit.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thử thách mới'**
  String get addHabit;

  /// No description provided for @habitName.
  ///
  /// In vi, this message translates to:
  /// **'Tên thói quen'**
  String get habitName;

  /// No description provided for @habitNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Uống 2 lít nước'**
  String get habitNameHint;

  /// No description provided for @durationInDays.
  ///
  /// In vi, this message translates to:
  /// **'Số ngày thử thách'**
  String get durationInDays;

  /// No description provided for @create.
  ///
  /// In vi, this message translates to:
  /// **'Tạo'**
  String get create;

  /// No description provided for @day.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get day;

  /// No description provided for @congratulations.
  ///
  /// In vi, this message translates to:
  /// **'Chúc mừng!'**
  String get congratulations;

  /// No description provided for @challengeComplete.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã hoàn thành xuất sắc thử thách!'**
  String get challengeComplete;

  /// No description provided for @createNewChallenge.
  ///
  /// In vi, this message translates to:
  /// **'Tạo thử thách mới'**
  String get createNewChallenge;

  /// No description provided for @aboutGroupInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin về nhóm phát triển của bạn...'**
  String get aboutGroupInfo;

  /// No description provided for @welcomeTo.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bạn đến với'**
  String get welcomeTo;

  /// No description provided for @welcomeMessage.
  ///
  /// In vi, this message translates to:
  /// **'Xây dựng những thói quen tốt, mỗi ngày một chút. Hãy bắt đầu thử thách đầu tiên của bạn!'**
  String get welcomeMessage;

  /// No description provided for @getStarted.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu ngay'**
  String get getStarted;

  /// No description provided for @deleteHabit.
  ///
  /// In vi, this message translates to:
  /// **'Xóa Thói quen'**
  String get deleteHabit;

  /// No description provided for @deleteHabitConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn xóa thói quen này? Mọi tiến độ sẽ bị mất.'**
  String get deleteHabitConfirm;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @currentStreak.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi hiện tại'**
  String get currentStreak;

  /// No description provided for @reminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở'**
  String get reminder;

  /// No description provided for @noReminderSet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đặt nhắc nhở'**
  String get noReminderSet;

  /// No description provided for @startDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày bắt đầu'**
  String get startDate;

  /// No description provided for @progress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get progress;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get english;

  /// No description provided for @appearance.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get appearance;

  /// No description provided for @themeMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ'**
  String get themeMode;

  /// No description provided for @light.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống'**
  String get system;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
