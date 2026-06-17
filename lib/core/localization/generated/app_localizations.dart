import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SanadLocalizations
/// returned by `SanadLocalizations.of(context)`.
///
/// Applications need to include `SanadLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SanadLocalizations.localizationsDelegates,
///   supportedLocales: SanadLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the SanadLocalizations.supportedLocales
/// property.
abstract class SanadLocalizations {
  SanadLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SanadLocalizations? of(BuildContext context) {
    return Localizations.of<SanadLocalizations>(context, SanadLocalizations);
  }

  static const LocalizationsDelegate<SanadLocalizations> delegate =
      _SanadLocalizationsDelegate();

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
    Locale('ar'),
    Locale('bn'),
    Locale('en'),
    Locale('fa'),
    Locale('fr'),
    Locale('id'),
    Locale('tr'),
    Locale('ur'),
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Sanad'**
  String get app_name;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @my_stats.
  ///
  /// In en, this message translates to:
  /// **'My Statistics'**
  String get my_stats;

  /// No description provided for @badges_and_medals.
  ///
  /// In en, this message translates to:
  /// **'Badges & Medals'**
  String get badges_and_medals;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @system_mode.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get system_mode;

  /// No description provided for @choose_theme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get choose_theme;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @fonts.
  ///
  /// In en, this message translates to:
  /// **'Fonts'**
  String get fonts;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get choose_language;

  /// No description provided for @choose_font.
  ///
  /// In en, this message translates to:
  /// **'Choose Font'**
  String get choose_font;

  /// No description provided for @font_preview.
  ///
  /// In en, this message translates to:
  /// **'Live Preview'**
  String get font_preview;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @persian.
  ///
  /// In en, this message translates to:
  /// **'Persian (Farsi)'**
  String get persian;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get urdu;

  /// No description provided for @bengali.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get bengali;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about_app;

  /// No description provided for @about_sanad.
  ///
  /// In en, this message translates to:
  /// **'About Sanad App'**
  String get about_sanad;

  /// No description provided for @share_app.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get share_app;

  /// No description provided for @rate_us.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rate_us;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @logout_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout_confirm_title;

  /// No description provided for @logout_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logout_confirm_message;

  /// No description provided for @delete_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_confirm_title;

  /// No description provided for @delete_warning.
  ///
  /// In en, this message translates to:
  /// **'Warning: All your data and statistics will be permanently deleted. This action cannot be undone. Are you sure?'**
  String get delete_warning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirm_delete;

  /// No description provided for @confirm_logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get confirm_logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @recitation_days.
  ///
  /// In en, this message translates to:
  /// **'Recitation Days'**
  String get recitation_days;

  /// No description provided for @azkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkar;

  /// No description provided for @khatmat.
  ///
  /// In en, this message translates to:
  /// **'Khatmat'**
  String get khatmat;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening (hrs)'**
  String get listening;

  /// No description provided for @level_student.
  ///
  /// In en, this message translates to:
  /// **'Level: Student'**
  String get level_student;

  /// No description provided for @points_to_next_level.
  ///
  /// In en, this message translates to:
  /// **'20 points to \"Hafidh\" level'**
  String get points_to_next_level;

  /// No description provided for @notification_settings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notification_settings;

  /// No description provided for @prayer_times_notif.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayer_times_notif;

  /// No description provided for @prayer_times_desc.
  ///
  /// In en, this message translates to:
  /// **'Prayer time reminders'**
  String get prayer_times_desc;

  /// No description provided for @morning_azkar.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get morning_azkar;

  /// No description provided for @morning_azkar_desc.
  ///
  /// In en, this message translates to:
  /// **'Daily morning azkar'**
  String get morning_azkar_desc;

  /// No description provided for @evening_azkar.
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get evening_azkar;

  /// No description provided for @evening_azkar_desc.
  ///
  /// In en, this message translates to:
  /// **'Daily evening azkar'**
  String get evening_azkar_desc;

  /// No description provided for @daily_reminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get daily_reminder;

  /// No description provided for @daily_reminder_desc.
  ///
  /// In en, this message translates to:
  /// **'General daily reminder'**
  String get daily_reminder_desc;

  /// No description provided for @quran_reminder.
  ///
  /// In en, this message translates to:
  /// **'Quran Reminder'**
  String get quran_reminder;

  /// No description provided for @quran_reminder_desc.
  ///
  /// In en, this message translates to:
  /// **'Quran reading reminder'**
  String get quran_reminder_desc;

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'About Sanad'**
  String get about_title;

  /// No description provided for @app_description.
  ///
  /// In en, this message translates to:
  /// **'A comprehensive Islamic app providing trusted religious content and daily tools for Muslims including azkar, Quran, and prayer times.'**
  String get app_description;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_of_service;

  /// No description provided for @rights_reserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved'**
  String get rights_reserved;

  /// No description provided for @share_text.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Sanad - A comprehensive Islamic app for azkar, Quran, and prayer times. Download now!'**
  String get share_text;

  /// No description provided for @change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Picture'**
  String get change_photo;

  /// No description provided for @from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get from_gallery;

  /// No description provided for @take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get take_photo;

  /// No description provided for @delete_photo.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get delete_photo;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @next_prayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get next_prayer;

  /// No description provided for @time_remaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get time_remaining;

  /// No description provided for @prayer_times.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayer_times;

  /// No description provided for @hijri_date.
  ///
  /// In en, this message translates to:
  /// **'Hijri Date'**
  String get hijri_date;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @monthly_view.
  ///
  /// In en, this message translates to:
  /// **'Monthly View'**
  String get monthly_view;

  /// No description provided for @monthly_prayer_times.
  ///
  /// In en, this message translates to:
  /// **'Monthly Prayer Times'**
  String get monthly_prayer_times;

  /// No description provided for @download_table.
  ///
  /// In en, this message translates to:
  /// **'Download Table'**
  String get download_table;

  /// No description provided for @add_to_calendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get add_to_calendar;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quran;

  /// No description provided for @quran_kareem.
  ///
  /// In en, this message translates to:
  /// **'The Holy Quran'**
  String get quran_kareem;

  /// No description provided for @juz.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get juz;

  /// No description provided for @hizb.
  ///
  /// In en, this message translates to:
  /// **'Hizb'**
  String get hizb;

  /// No description provided for @surah.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get surah;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @interpretation.
  ///
  /// In en, this message translates to:
  /// **'Interpretation'**
  String get interpretation;

  /// No description provided for @tafseer.
  ///
  /// In en, this message translates to:
  /// **'Tafseer'**
  String get tafseer;

  /// No description provided for @tafseer_muyassar.
  ///
  /// In en, this message translates to:
  /// **'Al-Muyassar Tafseer'**
  String get tafseer_muyassar;

  /// No description provided for @tafseer_jalalayn.
  ///
  /// In en, this message translates to:
  /// **'Tafseer Al-Jalalayn'**
  String get tafseer_jalalayn;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @search_quran.
  ///
  /// In en, this message translates to:
  /// **'Search Quran'**
  String get search_quran;

  /// No description provided for @settings_quran.
  ///
  /// In en, this message translates to:
  /// **'Quran Settings'**
  String get settings_quran;

  /// No description provided for @no_results.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results;

  /// No description provided for @search_hint_quran.
  ///
  /// In en, this message translates to:
  /// **'Search in the Holy Quran...'**
  String get search_hint_quran;

  /// No description provided for @search_hint_books.
  ///
  /// In en, this message translates to:
  /// **'Search for a book, author, or category...'**
  String get search_hint_books;

  /// No description provided for @search_hint_explore.
  ///
  /// In en, this message translates to:
  /// **'Search for verses, hadith, or supplications...'**
  String get search_hint_explore;

  /// No description provided for @meccan.
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get meccan;

  /// No description provided for @medinan.
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get medinan;

  /// No description provided for @font_size.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get font_size;

  /// No description provided for @slide_to_resize.
  ///
  /// In en, this message translates to:
  /// **'Slide to resize font'**
  String get slide_to_resize;

  /// No description provided for @background_color.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get background_color;

  /// No description provided for @ayah.
  ///
  /// In en, this message translates to:
  /// **'Ayah'**
  String get ayah;

  /// No description provided for @page_info.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page_info;

  /// No description provided for @copy_ayah.
  ///
  /// In en, this message translates to:
  /// **'Copy Ayah'**
  String get copy_ayah;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied ✓'**
  String get copied;

  /// No description provided for @tasbeeh.
  ///
  /// In en, this message translates to:
  /// **'Tasbeeh'**
  String get tasbeeh;

  /// No description provided for @tasbeeh_title.
  ///
  /// In en, this message translates to:
  /// **'Tasbeeh'**
  String get tasbeeh_title;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @reset_tasbeeh.
  ///
  /// In en, this message translates to:
  /// **'Reset Counter'**
  String get reset_tasbeeh;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @daily_goal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get daily_goal;

  /// No description provided for @weekly_goal.
  ///
  /// In en, this message translates to:
  /// **'Weekly Goal'**
  String get weekly_goal;

  /// No description provided for @weekly_achievement.
  ///
  /// In en, this message translates to:
  /// **'Weekly Achievement Record'**
  String get weekly_achievement;

  /// No description provided for @custom_daily_goal.
  ///
  /// In en, this message translates to:
  /// **'Customize Daily Goal'**
  String get custom_daily_goal;

  /// No description provided for @tap_anywhere.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to count'**
  String get tap_anywhere;

  /// No description provided for @completed_particles.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed_particles;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @qibla_title.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qibla_title;

  /// No description provided for @point_to_qibla.
  ///
  /// In en, this message translates to:
  /// **'Point your phone towards the Qibla direction shown.'**
  String get point_to_qibla;

  /// No description provided for @detecting_location.
  ///
  /// In en, this message translates to:
  /// **'Detecting location...'**
  String get detecting_location;

  /// No description provided for @location_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get location_disabled;

  /// No description provided for @location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied'**
  String get location_permission_denied;

  /// No description provided for @qibla_detected.
  ///
  /// In en, this message translates to:
  /// **'Qibla direction detected'**
  String get qibla_detected;

  /// No description provided for @direction_error.
  ///
  /// In en, this message translates to:
  /// **'Error determining direction'**
  String get direction_error;

  /// No description provided for @direction_degrees.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction_degrees;

  /// No description provided for @dua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get dua;

  /// No description provided for @dua_title.
  ///
  /// In en, this message translates to:
  /// **'Supplications'**
  String get dua_title;

  /// No description provided for @all_dua.
  ///
  /// In en, this message translates to:
  /// **'All Supplications'**
  String get all_dua;

  /// No description provided for @morning_dua.
  ///
  /// In en, this message translates to:
  /// **'Morning Supplications'**
  String get morning_dua;

  /// No description provided for @evening_dua.
  ///
  /// In en, this message translates to:
  /// **'Evening Supplications'**
  String get evening_dua;

  /// No description provided for @sleep_dua.
  ///
  /// In en, this message translates to:
  /// **'Sleep Supplications'**
  String get sleep_dua;

  /// No description provided for @leaving_home_dua.
  ///
  /// In en, this message translates to:
  /// **'Leaving Home Supplications'**
  String get leaving_home_dua;

  /// No description provided for @eating_dua.
  ///
  /// In en, this message translates to:
  /// **'Eating Supplications'**
  String get eating_dua;

  /// No description provided for @travel_dua.
  ///
  /// In en, this message translates to:
  /// **'Travel Supplications'**
  String get travel_dua;

  /// No description provided for @search_dua.
  ///
  /// In en, this message translates to:
  /// **'Search in supplications and remembrances...'**
  String get search_dua;

  /// No description provided for @no_dua_results.
  ///
  /// In en, this message translates to:
  /// **'No results for'**
  String get no_dua_results;

  /// No description provided for @seerah.
  ///
  /// In en, this message translates to:
  /// **'Seerah'**
  String get seerah;

  /// No description provided for @seerah_title.
  ///
  /// In en, this message translates to:
  /// **'Prophet\'s Biography'**
  String get seerah_title;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @read_seerah.
  ///
  /// In en, this message translates to:
  /// **'Read Seerah'**
  String get read_seerah;

  /// No description provided for @building_library.
  ///
  /// In en, this message translates to:
  /// **'Building library...'**
  String get building_library;

  /// No description provided for @hisn_muslim.
  ///
  /// In en, this message translates to:
  /// **'Hisn Muslim'**
  String get hisn_muslim;

  /// No description provided for @hisn_title.
  ///
  /// In en, this message translates to:
  /// **'Hisn Muslim'**
  String get hisn_title;

  /// No description provided for @hisn_subtitle.
  ///
  /// In en, this message translates to:
  /// **'From the remembrances of the Book and Sunnah'**
  String get hisn_subtitle;

  /// No description provided for @hisn_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories of Remembrances and Supplications'**
  String get hisn_categories;

  /// No description provided for @hisn_search.
  ///
  /// In en, this message translates to:
  /// **'Search for a remembrance or supplication...'**
  String get hisn_search;

  /// No description provided for @hisn_error.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get hisn_error;

  /// No description provided for @hisn_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading Hisn Muslim...'**
  String get hisn_loading;

  /// No description provided for @no_azkar_found.
  ///
  /// In en, this message translates to:
  /// **'No remembrances in this category'**
  String get no_azkar_found;

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @after_prayer.
  ///
  /// In en, this message translates to:
  /// **'After Prayer'**
  String get after_prayer;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @complete_message.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah! You completed'**
  String get complete_message;

  /// No description provided for @tap_to_count.
  ///
  /// In en, this message translates to:
  /// **'Tap on the remembrance to count. Tap ⓘ for its virtue.'**
  String get tap_to_count;

  /// No description provided for @required_count.
  ///
  /// In en, this message translates to:
  /// **'Required count'**
  String get required_count;

  /// No description provided for @my_azkar.
  ///
  /// In en, this message translates to:
  /// **'My Azkar'**
  String get my_azkar;

  /// No description provided for @all_azkar_loaded.
  ///
  /// In en, this message translates to:
  /// **'All azkar loaded'**
  String get all_azkar_loaded;

  /// No description provided for @from_quran.
  ///
  /// In en, this message translates to:
  /// **'From Quran'**
  String get from_quran;

  /// No description provided for @from_sunnah.
  ///
  /// In en, this message translates to:
  /// **'From Sunnah'**
  String get from_sunnah;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @all_categories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get all_categories;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @islamic_library.
  ///
  /// In en, this message translates to:
  /// **'Islamic Library'**
  String get islamic_library;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @book_details.
  ///
  /// In en, this message translates to:
  /// **'Book Details'**
  String get book_details;

  /// No description provided for @search_books.
  ///
  /// In en, this message translates to:
  /// **'Search books'**
  String get search_books;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @read_book.
  ///
  /// In en, this message translates to:
  /// **'Read Book'**
  String get read_book;

  /// No description provided for @save_book.
  ///
  /// In en, this message translates to:
  /// **'Save Book'**
  String get save_book;

  /// No description provided for @share_book.
  ///
  /// In en, this message translates to:
  /// **'Share Book'**
  String get share_book;

  /// No description provided for @no_books_found.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get no_books_found;

  /// No description provided for @try_different_search.
  ///
  /// In en, this message translates to:
  /// **'Try a different search'**
  String get try_different_search;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @language_arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get language_arabic;

  /// No description provided for @about_book.
  ///
  /// In en, this message translates to:
  /// **'About the Book'**
  String get about_book;

  /// No description provided for @keywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get keywords;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @no_books_category.
  ///
  /// In en, this message translates to:
  /// **'No books in this category'**
  String get no_books_category;

  /// No description provided for @books_count.
  ///
  /// In en, this message translates to:
  /// **'Books count'**
  String get books_count;

  /// No description provided for @zakat_calculator.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakat_calculator;

  /// No description provided for @zakat_title.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakat_title;

  /// No description provided for @zakat_rules.
  ///
  /// In en, this message translates to:
  /// **'Zakat Rulings'**
  String get zakat_rules;

  /// No description provided for @zakat_description.
  ///
  /// In en, this message translates to:
  /// **'Zakat becomes obligatory when wealth reaches the nisab and one lunar year passes. The rate is 2.5%.'**
  String get zakat_description;

  /// No description provided for @zakat_rule_nisab.
  ///
  /// In en, this message translates to:
  /// **'What is Nisab?'**
  String get zakat_rule_nisab;

  /// No description provided for @zakat_rule_nisab_desc.
  ///
  /// In en, this message translates to:
  /// **'Nisab is the minimum amount of wealth that makes Zakat obligatory. The Islamic nisab is 85 grams of gold.'**
  String get zakat_rule_nisab_desc;

  /// No description provided for @zakat_rule_hawl.
  ///
  /// In en, this message translates to:
  /// **'Meaning of One Lunar Year (Hawl)'**
  String get zakat_rule_hawl;

  /// No description provided for @zakat_rule_hawl_desc.
  ///
  /// In en, this message translates to:
  /// **'Hawl is a full lunar year (12 months) of possessing the nisab. Zakat is not due until a year passes.'**
  String get zakat_rule_hawl_desc;

  /// No description provided for @zakat_rule_assets.
  ///
  /// In en, this message translates to:
  /// **'Assets Subject to Zakat'**
  String get zakat_rule_assets;

  /// No description provided for @zakat_rule_assets_desc.
  ///
  /// In en, this message translates to:
  /// **'Cash and savings\nGold and silver\nTrade goods\nStocks and investments\nReceivables'**
  String get zakat_rule_assets_desc;

  /// No description provided for @zakat_rule_warning.
  ///
  /// In en, this message translates to:
  /// **'Important Notice'**
  String get zakat_rule_warning;

  /// No description provided for @zakat_rule_warning_desc.
  ///
  /// In en, this message translates to:
  /// **'This calculator is a helper tool only. Please consult scholars for accurate fatwa in complex cases.'**
  String get zakat_rule_warning_desc;

  /// No description provided for @nisaab.
  ///
  /// In en, this message translates to:
  /// **'Nisab'**
  String get nisaab;

  /// No description provided for @current_nisaab.
  ///
  /// In en, this message translates to:
  /// **'Current Nisab (85g Gold)'**
  String get current_nisaab;

  /// No description provided for @gold_price.
  ///
  /// In en, this message translates to:
  /// **'Gold Price'**
  String get gold_price;

  /// No description provided for @cash_savings.
  ///
  /// In en, this message translates to:
  /// **'Cash & Savings'**
  String get cash_savings;

  /// No description provided for @gold_grams.
  ///
  /// In en, this message translates to:
  /// **'Gold (grams)'**
  String get gold_grams;

  /// No description provided for @silver_grams.
  ///
  /// In en, this message translates to:
  /// **'Silver (grams)'**
  String get silver_grams;

  /// No description provided for @investments.
  ///
  /// In en, this message translates to:
  /// **'Stocks & Investments'**
  String get investments;

  /// No description provided for @business_assets.
  ///
  /// In en, this message translates to:
  /// **'Business Assets'**
  String get business_assets;

  /// No description provided for @receivables.
  ///
  /// In en, this message translates to:
  /// **'Receivables'**
  String get receivables;

  /// No description provided for @debts.
  ///
  /// In en, this message translates to:
  /// **'Debts Owed'**
  String get debts;

  /// No description provided for @calculate_zakat.
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat'**
  String get calculate_zakat;

  /// No description provided for @total_wealth.
  ///
  /// In en, this message translates to:
  /// **'Total Zakatable Wealth'**
  String get total_wealth;

  /// No description provided for @zakat_amount.
  ///
  /// In en, this message translates to:
  /// **'Zakat Due'**
  String get zakat_amount;

  /// No description provided for @zakat_not_due.
  ///
  /// In en, this message translates to:
  /// **'No Zakat Due'**
  String get zakat_not_due;

  /// No description provided for @meets_nisaab.
  ///
  /// In en, this message translates to:
  /// **'Meets Nisab'**
  String get meets_nisaab;

  /// No description provided for @does_not_meet_nisaab.
  ///
  /// In en, this message translates to:
  /// **'Below Nisab'**
  String get does_not_meet_nisaab;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @refresh_price.
  ///
  /// In en, this message translates to:
  /// **'Refresh Price'**
  String get refresh_price;

  /// No description provided for @breakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get breakdown;

  /// No description provided for @hide_details.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get hide_details;

  /// No description provided for @how_calculated.
  ///
  /// In en, this message translates to:
  /// **'How was it calculated?'**
  String get how_calculated;

  /// No description provided for @loading_gold_price.
  ///
  /// In en, this message translates to:
  /// **'Loading gold price...'**
  String get loading_gold_price;

  /// No description provided for @price_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch gold price'**
  String get price_error;

  /// No description provided for @fallback_price_warning.
  ///
  /// In en, this message translates to:
  /// **'Approximate value - offline'**
  String get fallback_price_warning;

  /// No description provided for @zakat_rate.
  ///
  /// In en, this message translates to:
  /// **'Zakat Rate'**
  String get zakat_rate;

  /// No description provided for @zakat_result_total.
  ///
  /// In en, this message translates to:
  /// **'Total Zakatable Wealth'**
  String get zakat_result_total;

  /// No description provided for @gross_wealth.
  ///
  /// In en, this message translates to:
  /// **'Gross Wealth'**
  String get gross_wealth;

  /// No description provided for @net_wealth.
  ///
  /// In en, this message translates to:
  /// **'Net Zakatable Wealth'**
  String get net_wealth;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @daily_challenges.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenges'**
  String get daily_challenges;

  /// No description provided for @weekly_challenges.
  ///
  /// In en, this message translates to:
  /// **'Weekly Challenges'**
  String get weekly_challenges;

  /// No description provided for @monthly_goals.
  ///
  /// In en, this message translates to:
  /// **'Monthly Goals'**
  String get monthly_goals;

  /// No description provided for @spiritual_paths.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Paths'**
  String get spiritual_paths;

  /// No description provided for @seasonal_activities.
  ///
  /// In en, this message translates to:
  /// **'Seasonal Activities'**
  String get seasonal_activities;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @prayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get prayer;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed ✓'**
  String get completed;

  /// No description provided for @no_challenges.
  ///
  /// In en, this message translates to:
  /// **'No challenges today'**
  String get no_challenges;

  /// No description provided for @my_activities.
  ///
  /// In en, this message translates to:
  /// **'My Activities'**
  String get my_activities;

  /// No description provided for @live_stats.
  ///
  /// In en, this message translates to:
  /// **'Live Statistics'**
  String get live_stats;

  /// No description provided for @stats_progress.
  ///
  /// In en, this message translates to:
  /// **'completed out of today activities'**
  String get stats_progress;

  /// No description provided for @start_first_activity.
  ///
  /// In en, this message translates to:
  /// **'Start your first activity today!'**
  String get start_first_activity;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @streak_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get streak_days;

  /// No description provided for @ramadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Mubarak'**
  String get ramadan;

  /// No description provided for @eid_fitr.
  ///
  /// In en, this message translates to:
  /// **'Eid Al-Fitr'**
  String get eid_fitr;

  /// No description provided for @eid_adha.
  ///
  /// In en, this message translates to:
  /// **'Eid Al-Adha'**
  String get eid_adha;

  /// No description provided for @day_of_arafah.
  ///
  /// In en, this message translates to:
  /// **'Day of Arafah'**
  String get day_of_arafah;

  /// No description provided for @dhul_hijjah_ten.
  ///
  /// In en, this message translates to:
  /// **'First Ten of Dhul Hijjah'**
  String get dhul_hijjah_ten;

  /// No description provided for @ashura.
  ///
  /// In en, this message translates to:
  /// **'Ashura'**
  String get ashura;

  /// No description provided for @next_stage.
  ///
  /// In en, this message translates to:
  /// **'Next:'**
  String get next_stage;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @xp_points.
  ///
  /// In en, this message translates to:
  /// **'XP Points'**
  String get xp_points;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @explore_new_content.
  ///
  /// In en, this message translates to:
  /// **'Discover New Content'**
  String get explore_new_content;

  /// No description provided for @did_you_know.
  ///
  /// In en, this message translates to:
  /// **'Did You Know?'**
  String get did_you_know;

  /// No description provided for @islamic_personalities.
  ///
  /// In en, this message translates to:
  /// **'Islamic Personalities'**
  String get islamic_personalities;

  /// No description provided for @seerah_history.
  ///
  /// In en, this message translates to:
  /// **'Seerah & History'**
  String get seerah_history;

  /// No description provided for @islamic_topics.
  ///
  /// In en, this message translates to:
  /// **'Islamic Topics'**
  String get islamic_topics;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons Learned'**
  String get lessons;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @save_content.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_content;

  /// No description provided for @share_content.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share_content;

  /// No description provided for @copied_snackbar.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied_snackbar;

  /// No description provided for @start_calculator.
  ///
  /// In en, this message translates to:
  /// **'Start Calculation'**
  String get start_calculator;

  /// No description provided for @browse_library.
  ///
  /// In en, this message translates to:
  /// **'Browse Library'**
  String get browse_library;

  /// No description provided for @explore_library_desc.
  ///
  /// In en, this message translates to:
  /// **'Explore hundreds of books on Tafseer, Hadith, Fiqh, Aqeedah and Seerah'**
  String get explore_library_desc;

  /// No description provided for @explore_zakat_desc.
  ///
  /// In en, this message translates to:
  /// **'Calculate your Zakat accurately according to the legal nisab (85g gold)'**
  String get explore_zakat_desc;

  /// No description provided for @hashtag_sabr.
  ///
  /// In en, this message translates to:
  /// **'#Patience'**
  String get hashtag_sabr;

  /// No description provided for @hashtag_jannah.
  ///
  /// In en, this message translates to:
  /// **'#Paradise'**
  String get hashtag_jannah;

  /// No description provided for @hashtag_parents.
  ///
  /// In en, this message translates to:
  /// **'#Honoring_Parents'**
  String get hashtag_parents;

  /// No description provided for @hashtag_fajr.
  ///
  /// In en, this message translates to:
  /// **'#Fajr'**
  String get hashtag_fajr;

  /// No description provided for @hashtag_rizq.
  ///
  /// In en, this message translates to:
  /// **'#Sustenance'**
  String get hashtag_rizq;

  /// No description provided for @good_morning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get good_morning;

  /// No description provided for @good_evening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get good_evening;

  /// No description provided for @good_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get good_afternoon;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @computing_time.
  ///
  /// In en, this message translates to:
  /// **'Computing time...'**
  String get computing_time;

  /// No description provided for @continue_reading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continue_reading;

  /// No description provided for @reading_progress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Reading Goal'**
  String get reading_progress;

  /// No description provided for @hadith_of_day.
  ///
  /// In en, this message translates to:
  /// **'Hadith of the Day'**
  String get hadith_of_day;

  /// No description provided for @daily_portion.
  ///
  /// In en, this message translates to:
  /// **'Daily Portion'**
  String get daily_portion;

  /// No description provided for @achievements_today.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Achievements'**
  String get achievements_today;

  /// No description provided for @quick_access.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quick_access;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @copy_hadith.
  ///
  /// In en, this message translates to:
  /// **'Copy Hadith'**
  String get copy_hadith;

  /// No description provided for @copy_hadith_share.
  ///
  /// In en, this message translates to:
  /// **'Copy Hadith to share'**
  String get copy_hadith_share;

  /// No description provided for @saved_hadith.
  ///
  /// In en, this message translates to:
  /// **'Saved Hadith to favorites'**
  String get saved_hadith;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login_title;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get no_account;

  /// No description provided for @have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get have_account;

  /// No description provided for @fill_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fill_all_fields;

  /// No description provided for @invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect'**
  String get invalid_credentials;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again'**
  String get error_occurred;

  /// No description provided for @password_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_length;

  /// No description provided for @email_exists.
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get email_exists;

  /// No description provided for @account_created.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get account_created;

  /// No description provided for @app_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Comprehensive Islamic App'**
  String get app_subtitle;

  /// No description provided for @subhanallah.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah'**
  String get subhanallah;

  /// No description provided for @alhamdulillah.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah'**
  String get alhamdulillah;

  /// No description provided for @allahuakbar.
  ///
  /// In en, this message translates to:
  /// **'Allahu Akbar'**
  String get allahuakbar;

  /// No description provided for @la_ilaha_illallah.
  ///
  /// In en, this message translates to:
  /// **'La ilaha illallah'**
  String get la_ilaha_illallah;

  /// No description provided for @astaghfirullah.
  ///
  /// In en, this message translates to:
  /// **'Astaghfirullah'**
  String get astaghfirullah;

  /// No description provided for @allahumma_salli.
  ///
  /// In en, this message translates to:
  /// **'Allahumma salli \'ala Muhammad'**
  String get allahumma_salli;

  /// No description provided for @la_hawla.
  ///
  /// In en, this message translates to:
  /// **'La hawla wa la quwwata illa billah'**
  String get la_hawla;

  /// No description provided for @subhanallah_wabihamdih.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah wa bihamdih'**
  String get subhanallah_wabihamdih;

  /// No description provided for @subhanallah_al_azeem.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah al-Azeem'**
  String get subhanallah_al_azeem;

  /// No description provided for @astaghfirullah_al_azeem.
  ///
  /// In en, this message translates to:
  /// **'Astaghfirullah al-Azeem wa atubu ilayh'**
  String get astaghfirullah_al_azeem;

  /// No description provided for @allahumma_salli_wasallim.
  ///
  /// In en, this message translates to:
  /// **'Allahumma salli wa sallim \'ala nabiyyina Muhammad'**
  String get allahumma_salli_wasallim;

  /// No description provided for @hasbiyallah.
  ///
  /// In en, this message translates to:
  /// **'HasbiyAllahu wa ni\'mal wakeel'**
  String get hasbiyallah;

  /// No description provided for @la_ilaha_illa_anta.
  ///
  /// In en, this message translates to:
  /// **'La ilaha illa anta subhanaka inni kuntu min al-thalimeen'**
  String get la_ilaha_illa_anta;

  /// No description provided for @four_tasbeeh.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah walhamdulillah wa la ilaha illallah wallahu akbar'**
  String get four_tasbeeh;

  /// No description provided for @tahlil.
  ///
  /// In en, this message translates to:
  /// **'La ilaha illallahu wahdahu la sharika lah...'**
  String get tahlil;

  /// No description provided for @ya_hayyu_ya_qayyum.
  ///
  /// In en, this message translates to:
  /// **'Ya Hayyu ya Qayyum birahmatika astagheeth'**
  String get ya_hayyu_ya_qayyum;

  /// No description provided for @rabbi_ghfir.
  ///
  /// In en, this message translates to:
  /// **'Rabbi ighfir li wa liwalidayya'**
  String get rabbi_ghfir;

  /// No description provided for @rabbi_irham.
  ///
  /// In en, this message translates to:
  /// **'Rabbi ighfir warham wa anta khayru al-rahimeen'**
  String get rabbi_irham;

  /// No description provided for @allahumma_innaka_afuwwun.
  ///
  /// In en, this message translates to:
  /// **'Allahumma innaka \'afuwwun tuhibbul \'afwa fa\'fu \'anni'**
  String get allahumma_innaka_afuwwun;

  /// No description provided for @raditu_billah.
  ///
  /// In en, this message translates to:
  /// **'Raditu billahi rabban wa bil islami dinan wa bi Muhammadin nabiyyan wa rasula'**
  String get raditu_billah;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @my_groups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get my_groups;

  /// No description provided for @groups_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore Groups'**
  String get groups_explore;

  /// No description provided for @spiritual_collaboration.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Collaboration'**
  String get spiritual_collaboration;

  /// No description provided for @spiritual_bubbles.
  ///
  /// In en, this message translates to:
  /// **'Status Bubbles & Mutual Advice'**
  String get spiritual_bubbles;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon... Join millions of Muslims worldwide!'**
  String get coming_soon;

  /// No description provided for @shared_khatma.
  ///
  /// In en, this message translates to:
  /// **'Shared Khatma'**
  String get shared_khatma;

  /// No description provided for @prayer_on_prophet.
  ///
  /// In en, this message translates to:
  /// **'Prayer upon the Prophet ﷺ'**
  String get prayer_on_prophet;

  /// No description provided for @support_needy.
  ///
  /// In en, this message translates to:
  /// **'Support the Needy'**
  String get support_needy;

  /// No description provided for @prayed_for_you.
  ///
  /// In en, this message translates to:
  /// **'Prayed for you'**
  String get prayed_for_you;

  /// No description provided for @contribute_now.
  ///
  /// In en, this message translates to:
  /// **'Contribute Now'**
  String get contribute_now;

  /// No description provided for @share_wisdom.
  ///
  /// In en, this message translates to:
  /// **'shared today\'s wisdom'**
  String get share_wisdom;

  /// No description provided for @ameen.
  ///
  /// In en, this message translates to:
  /// **'Ameen'**
  String get ameen;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @fatawa.
  ///
  /// In en, this message translates to:
  /// **'Fatawa'**
  String get fatawa;

  /// No description provided for @hadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get hadith;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @font_setting_title.
  ///
  /// In en, this message translates to:
  /// **'Fonts'**
  String get font_setting_title;

  /// No description provided for @font_select_title.
  ///
  /// In en, this message translates to:
  /// **'Choose App Font'**
  String get font_select_title;

  /// No description provided for @font_select_desc.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred font for displaying content throughout the app'**
  String get font_select_desc;

  /// No description provided for @font_bismillah.
  ///
  /// In en, this message translates to:
  /// **'In the name of Allah, the Most Gracious, the Most Merciful'**
  String get font_bismillah;

  /// No description provided for @font_verse.
  ///
  /// In en, this message translates to:
  /// **'Indeed, this Quran guides to that which is most upright'**
  String get font_verse;

  /// No description provided for @font_hamd.
  ///
  /// In en, this message translates to:
  /// **'All praise is due to Allah, Lord of the worlds...'**
  String get font_hamd;

  /// No description provided for @font_salam.
  ///
  /// In en, this message translates to:
  /// **'Peace be upon you and the mercy of Allah and His blessings'**
  String get font_salam;

  /// No description provided for @auth_title.
  ///
  /// In en, this message translates to:
  /// **'The application is currently in development. Stay tuned!'**
  String get auth_title;

  /// No description provided for @loading_failed.
  ///
  /// In en, this message translates to:
  /// **'Loading failed'**
  String get loading_failed;

  /// No description provided for @retry_action.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry_action;

  /// No description provided for @no_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_connection;

  /// No description provided for @success_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get success_saved;

  /// No description provided for @delete_request_sent.
  ///
  /// In en, this message translates to:
  /// **'Delete request has been sent'**
  String get delete_request_sent;

  /// No description provided for @shared_success.
  ///
  /// In en, this message translates to:
  /// **'Shared successfully'**
  String get shared_success;

  /// No description provided for @rate_store_message.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to app store rating page'**
  String get rate_store_message;

  /// No description provided for @about_book_desc.
  ///
  /// In en, this message translates to:
  /// **'This book is one of the distinguished books in the Islamic library'**
  String get about_book_desc;

  /// No description provided for @eid_mubarak.
  ///
  /// In en, this message translates to:
  /// **'Eid Mubarak'**
  String get eid_mubarak;

  /// No description provided for @privacy_policy_soon.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy - Coming Soon'**
  String get privacy_policy_soon;

  /// No description provided for @terms_soon.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service - Coming Soon'**
  String get terms_soon;

  /// No description provided for @searched_for.
  ///
  /// In en, this message translates to:
  /// **'No results for'**
  String get searched_for;
}

class _SanadLocalizationsDelegate
    extends LocalizationsDelegate<SanadLocalizations> {
  const _SanadLocalizationsDelegate();

  @override
  Future<SanadLocalizations> load(Locale locale) {
    return SynchronousFuture<SanadLocalizations>(
      lookupSanadLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'en',
    'fa',
    'fr',
    'id',
    'tr',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_SanadLocalizationsDelegate old) => false;
}

SanadLocalizations lookupSanadLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SanadLocalizationsAr();
    case 'bn':
      return SanadLocalizationsBn();
    case 'en':
      return SanadLocalizationsEn();
    case 'fa':
      return SanadLocalizationsFa();
    case 'fr':
      return SanadLocalizationsFr();
    case 'id':
      return SanadLocalizationsId();
    case 'tr':
      return SanadLocalizationsTr();
    case 'ur':
      return SanadLocalizationsUr();
  }

  throw FlutterError(
    'SanadLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
