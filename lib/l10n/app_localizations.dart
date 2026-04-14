import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @welcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBackTitle;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressLabel;

  /// No description provided for @emailFieldHint.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get emailFieldHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordFieldHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @errorValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get errorValidEmail;

  /// No description provided for @errorEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get errorEnterPassword;

  /// No description provided for @errorUnknownNurseStatus.
  ///
  /// In en, this message translates to:
  /// **'Unknown nurse verification status: {status}'**
  String errorUnknownNurseStatus(String status);

  /// No description provided for @errorUnknownRole.
  ///
  /// In en, this message translates to:
  /// **'Unknown role: {role}'**
  String errorUnknownRole(String role);

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {message}'**
  String errorLoginFailed(String message);

  /// No description provided for @signupCreateNurseAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Nurse Account'**
  String get signupCreateNurseAccount;

  /// No description provided for @signupCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupCreateAccount;

  /// No description provided for @signupNurseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete nurse registration in two steps'**
  String get signupNurseSubtitle;

  /// No description provided for @signupPatientSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signupPatientSubtitle;

  /// No description provided for @signupStep1Of4.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 4'**
  String get signupStep1Of4;

  /// No description provided for @signupIAmA.
  ///
  /// In en, this message translates to:
  /// **'I am a:'**
  String get signupIAmA;

  /// No description provided for @rolePatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get rolePatient;

  /// No description provided for @roleNurse.
  ///
  /// In en, this message translates to:
  /// **'Nurse'**
  String get roleNurse;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @validationFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get validationFullNameRequired;

  /// No description provided for @signupEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get signupEmailLabel;

  /// No description provided for @signupEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get signupEmailHint;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter valid email'**
  String get validationEmailInvalid;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 0790000000'**
  String get phoneNumberHint;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validationPhoneInvalid;

  /// No description provided for @signupPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signupPasswordLabel;

  /// No description provided for @signupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get signupPasswordHint;

  /// No description provided for @validationPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get validationPasswordMin;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsMismatch;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signupFooterNurse.
  ///
  /// In en, this message translates to:
  /// **'You will complete verification in the next step.'**
  String get signupFooterNurse;

  /// No description provided for @signupFooterPatient.
  ///
  /// In en, this message translates to:
  /// **'Create your account to continue.'**
  String get signupFooterPatient;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @signUpErrorFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed: {message}'**
  String signUpErrorFailed(String message);

  /// No description provided for @patientNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get patientNavHome;

  /// No description provided for @patientNavNurses.
  ///
  /// In en, this message translates to:
  /// **'Nurses'**
  String get patientNavNurses;

  /// No description provided for @patientNavAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get patientNavAppointments;

  /// No description provided for @patientNavPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get patientNavPayments;

  /// No description provided for @patientNavMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get patientNavMore;

  /// No description provided for @patientWelcomeBackLine.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get patientWelcomeBackLine;

  /// No description provided for @patientSearchNursesHint.
  ///
  /// In en, this message translates to:
  /// **'Search nurses by name or specialty...'**
  String get patientSearchNursesHint;

  /// No description provided for @patientQuickServices.
  ///
  /// In en, this message translates to:
  /// **'Quick Services'**
  String get patientQuickServices;

  /// No description provided for @patientUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get patientUpcomingAppointments;

  /// No description provided for @patientViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get patientViewAll;

  /// No description provided for @patientTotalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get patientTotalBookings;

  /// No description provided for @patientActiveRequests.
  ///
  /// In en, this message translates to:
  /// **'Active Requests'**
  String get patientActiveRequests;

  /// No description provided for @patientAppointmentsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Appointments section stays as-is.'**
  String get patientAppointmentsPlaceholder;

  /// No description provided for @patientLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get patientLogout;

  /// No description provided for @patientServiceIvTherapy.
  ///
  /// In en, this message translates to:
  /// **'IV\nTherapy'**
  String get patientServiceIvTherapy;

  /// No description provided for @patientServiceWoundCare.
  ///
  /// In en, this message translates to:
  /// **'Wound\nCare'**
  String get patientServiceWoundCare;

  /// No description provided for @patientServicePostSurgery.
  ///
  /// In en, this message translates to:
  /// **'Post-\nSurgery'**
  String get patientServicePostSurgery;

  /// No description provided for @patientServiceMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get patientServiceMedication;

  /// No description provided for @patientRateExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get patientRateExperienceTitle;

  /// No description provided for @patientRateExperienceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help others by sharing your feedback\nabout {nurseName}'**
  String patientRateExperienceSubtitle(String nurseName);

  /// No description provided for @patientWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get patientWriteReview;

  /// No description provided for @patientReviewSubmittedThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks! Your review was submitted.'**
  String get patientReviewSubmittedThanks;

  /// No description provided for @patientLogoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed: {message}'**
  String patientLogoutFailed(String message);

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @patientRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get patientRetry;

  /// No description provided for @patientBrowseTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse Nurses'**
  String get patientBrowseTitle;

  /// No description provided for @patientBrowseSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or specialty...'**
  String get patientBrowseSearchHint;

  /// No description provided for @patientBrowseFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get patientBrowseFilters;

  /// No description provided for @patientBrowseFilterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Nurses'**
  String get patientBrowseFilterSheetTitle;

  /// No description provided for @patientBrowseReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get patientBrowseReset;

  /// No description provided for @patientBrowseServiceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get patientBrowseServiceType;

  /// No description provided for @patientBrowseChooseService.
  ///
  /// In en, this message translates to:
  /// **'Choose a service'**
  String get patientBrowseChooseService;

  /// No description provided for @patientBrowseAllServices.
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get patientBrowseAllServices;

  /// No description provided for @patientBrowseGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get patientBrowseGovernorate;

  /// No description provided for @patientBrowseAllLocations.
  ///
  /// In en, this message translates to:
  /// **'All Locations'**
  String get patientBrowseAllLocations;

  /// No description provided for @patientGovZarqa.
  ///
  /// In en, this message translates to:
  /// **'Zarqa'**
  String get patientGovZarqa;

  /// No description provided for @patientGovIrbid.
  ///
  /// In en, this message translates to:
  /// **'Irbid'**
  String get patientGovIrbid;

  /// No description provided for @patientGovAmman.
  ///
  /// In en, this message translates to:
  /// **'Amman'**
  String get patientGovAmman;

  /// No description provided for @patientGovTafilah.
  ///
  /// In en, this message translates to:
  /// **'Tafilah'**
  String get patientGovTafilah;

  /// No description provided for @patientGovKarak.
  ///
  /// In en, this message translates to:
  /// **'Karak'**
  String get patientGovKarak;

  /// No description provided for @patientGovMadaba.
  ///
  /// In en, this message translates to:
  /// **'Madaba'**
  String get patientGovMadaba;

  /// No description provided for @patientGovBalqa.
  ///
  /// In en, this message translates to:
  /// **'Balqa'**
  String get patientGovBalqa;

  /// No description provided for @patientGovAjloun.
  ///
  /// In en, this message translates to:
  /// **'Ajloun'**
  String get patientGovAjloun;

  /// No description provided for @patientGovJerash.
  ///
  /// In en, this message translates to:
  /// **'Jerash'**
  String get patientGovJerash;

  /// No description provided for @patientGovAqaba.
  ///
  /// In en, this message translates to:
  /// **'Aqaba'**
  String get patientGovAqaba;

  /// No description provided for @patientGovMaan.
  ///
  /// In en, this message translates to:
  /// **'Ma\'an'**
  String get patientGovMaan;

  /// No description provided for @patientGovMafraq.
  ///
  /// In en, this message translates to:
  /// **'Mafraq'**
  String get patientGovMafraq;

  /// No description provided for @patientBrowseApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get patientBrowseApplyFilters;

  /// No description provided for @patientBrowseClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get patientBrowseClearAll;

  /// No description provided for @patientBrowseFoundNurses.
  ///
  /// In en, this message translates to:
  /// **'Found {count} nurses'**
  String patientBrowseFoundNurses(int count);

  /// No description provided for @patientBrowsePageIndicator.
  ///
  /// In en, this message translates to:
  /// **'Page {current}/{total}'**
  String patientBrowsePageIndicator(int current, int total);

  /// No description provided for @patientBrowseNoResults.
  ///
  /// In en, this message translates to:
  /// **'No nurses match your filters.'**
  String get patientBrowseNoResults;

  /// No description provided for @patientBrowseViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get patientBrowseViewProfile;

  /// No description provided for @patientBrowseExperienceYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String patientBrowseExperienceYears(int years);

  /// No description provided for @patientBrowseCatalog1.
  ///
  /// In en, this message translates to:
  /// **'IV Therapy'**
  String get patientBrowseCatalog1;

  /// No description provided for @patientBrowseCatalog2.
  ///
  /// In en, this message translates to:
  /// **'Wound Care and Dressing'**
  String get patientBrowseCatalog2;

  /// No description provided for @patientBrowseCatalog3.
  ///
  /// In en, this message translates to:
  /// **'Injection or Medication Administration'**
  String get patientBrowseCatalog3;

  /// No description provided for @patientBrowseCatalog4.
  ///
  /// In en, this message translates to:
  /// **'Post-Surgery Care'**
  String get patientBrowseCatalog4;

  /// No description provided for @patientBrowseCatalog5.
  ///
  /// In en, this message translates to:
  /// **'Medication Management'**
  String get patientBrowseCatalog5;

  /// No description provided for @patientBrowseCatalog6.
  ///
  /// In en, this message translates to:
  /// **'Vital Signs Monitoring'**
  String get patientBrowseCatalog6;

  /// No description provided for @patientBrowseCatalog7.
  ///
  /// In en, this message translates to:
  /// **'Blood Draw or Lab Sample Collection'**
  String get patientBrowseCatalog7;

  /// No description provided for @patientBrowseCatalog8.
  ///
  /// In en, this message translates to:
  /// **'Catheter Care'**
  String get patientBrowseCatalog8;

  /// No description provided for @patientBrowseCatalog9.
  ///
  /// In en, this message translates to:
  /// **'Diabetes Monitoring and Insulin Injection'**
  String get patientBrowseCatalog9;

  /// No description provided for @patientBrowseCatalog10.
  ///
  /// In en, this message translates to:
  /// **'Elderly Home Care Visit'**
  String get patientBrowseCatalog10;

  /// No description provided for @patientBrowseCatalog11.
  ///
  /// In en, this message translates to:
  /// **'Oxygen Therapy Setup'**
  String get patientBrowseCatalog11;

  /// No description provided for @patientBrowseCatalog12.
  ///
  /// In en, this message translates to:
  /// **'Nebulizer Therapy Session'**
  String get patientBrowseCatalog12;

  /// No description provided for @patientBrowseCatalog13.
  ///
  /// In en, this message translates to:
  /// **'Stitches Removal'**
  String get patientBrowseCatalog13;

  /// No description provided for @patientBrowseCatalog14.
  ///
  /// In en, this message translates to:
  /// **'Pressure Ulcer Care'**
  String get patientBrowseCatalog14;

  /// No description provided for @patientBrowseCatalog15.
  ///
  /// In en, this message translates to:
  /// **'General Nursing Home Visit'**
  String get patientBrowseCatalog15;

  /// No description provided for @patientBrowseCatalog16.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure Check'**
  String get patientBrowseCatalog16;

  /// No description provided for @patientBrowseCatalog17.
  ///
  /// In en, this message translates to:
  /// **'Short Care Shift (4 hours)'**
  String get patientBrowseCatalog17;

  /// No description provided for @patientBrowseCatalog18.
  ///
  /// In en, this message translates to:
  /// **'Half-Day Home Care (6 hours)'**
  String get patientBrowseCatalog18;

  /// No description provided for @patientBrowseCatalog19.
  ///
  /// In en, this message translates to:
  /// **'Full-Day Home Care (12 hours)'**
  String get patientBrowseCatalog19;

  /// No description provided for @patientAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get patientAppointmentsTitle;

  /// No description provided for @patientAppointmentsUpcomingCount.
  ///
  /// In en, this message translates to:
  /// **'Upcoming ({count})'**
  String patientAppointmentsUpcomingCount(int count);

  /// No description provided for @patientAppointmentsPastCount.
  ///
  /// In en, this message translates to:
  /// **'Past ({count})'**
  String patientAppointmentsPastCount(int count);

  /// No description provided for @patientAppointmentsNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments.'**
  String get patientAppointmentsNoUpcoming;

  /// No description provided for @patientAppointmentsNoPast.
  ///
  /// In en, this message translates to:
  /// **'No past appointments.'**
  String get patientAppointmentsNoPast;

  /// No description provided for @patientAppointmentsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load appointments'**
  String get patientAppointmentsLoadFailed;

  /// No description provided for @patientAppointmentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get patientAppointmentTotal;

  /// No description provided for @patientAppointmentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get patientAppointmentStatusPending;

  /// No description provided for @patientAppointmentStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get patientAppointmentStatusConfirmed;

  /// No description provided for @patientAppointmentStatusActivePaid.
  ///
  /// In en, this message translates to:
  /// **'Active/Paid'**
  String get patientAppointmentStatusActivePaid;

  /// No description provided for @patientAppointmentStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get patientAppointmentStatusCompleted;

  /// No description provided for @patientAppointmentStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get patientAppointmentStatusCancelled;

  /// No description provided for @patientAppointmentStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get patientAppointmentStatusRejected;

  /// No description provided for @patientPayBannerTitlePayContinue.
  ///
  /// In en, this message translates to:
  /// **'Pay to continue'**
  String get patientPayBannerTitlePayContinue;

  /// No description provided for @patientPayBannerTitlePaymentRequired.
  ///
  /// In en, this message translates to:
  /// **'Payment required'**
  String get patientPayBannerTitlePaymentRequired;

  /// No description provided for @patientPayBannerBodyPayContinue.
  ///
  /// In en, this message translates to:
  /// **'Your nurse confirmed this appointment. Please complete payment to activate it and keep your booking.'**
  String get patientPayBannerBodyPayContinue;

  /// No description provided for @patientPayBannerBodyPaymentRequired.
  ///
  /// In en, this message translates to:
  /// **'Complete payment to confirm your appointment.'**
  String get patientPayBannerBodyPaymentRequired;

  /// No description provided for @patientPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get patientPaymentTitle;

  /// No description provided for @patientPaymentBookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get patientPaymentBookingSummary;

  /// No description provided for @patientPaymentLabelNurse.
  ///
  /// In en, this message translates to:
  /// **'Nurse'**
  String get patientPaymentLabelNurse;

  /// No description provided for @patientPaymentLabelService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get patientPaymentLabelService;

  /// No description provided for @patientPaymentLabelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get patientPaymentLabelDate;

  /// No description provided for @patientPaymentLabelTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get patientPaymentLabelTime;

  /// No description provided for @patientPaymentLabelAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get patientPaymentLabelAmount;

  /// No description provided for @patientPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get patientPaymentMethod;

  /// No description provided for @patientPaymentStripeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Card payments (Stripe) are turned off in this build for local development.'**
  String get patientPaymentStripeDisabled;

  /// No description provided for @patientPaymentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get patientPaymentConfirm;

  /// No description provided for @patientPaymentStripeDisabledSnack.
  ///
  /// In en, this message translates to:
  /// **'Stripe is disabled in this build. Re-enable flutter_stripe in pubspec and restore _confirmPayment below.'**
  String get patientPaymentStripeDisabledSnack;

  /// No description provided for @patientPaymentError.
  ///
  /// In en, this message translates to:
  /// **'Payment error: {message}'**
  String patientPaymentError(String message);

  /// No description provided for @patientMoreProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get patientMoreProfileTitle;

  /// No description provided for @patientMoreProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and edit your information'**
  String get patientMoreProfileSubtitle;

  /// No description provided for @patientPaymentsTabEmpty.
  ///
  /// In en, this message translates to:
  /// **'Payment history and receipts will appear here when available.'**
  String get patientPaymentsTabEmpty;

  /// No description provided for @patientReviewSetRatingFirstSnack.
  ///
  /// In en, this message translates to:
  /// **'Please set your overall rating first.'**
  String get patientReviewSetRatingFirstSnack;

  /// No description provided for @patientReviewOverallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get patientReviewOverallRating;

  /// No description provided for @patientReviewTapToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate'**
  String get patientReviewTapToRate;

  /// No description provided for @patientReviewRateSpecificAreas.
  ///
  /// In en, this message translates to:
  /// **'Rate Specific Areas'**
  String get patientReviewRateSpecificAreas;

  /// No description provided for @patientReviewProfessionalism.
  ///
  /// In en, this message translates to:
  /// **'Professionalism'**
  String get patientReviewProfessionalism;

  /// No description provided for @patientReviewPunctuality.
  ///
  /// In en, this message translates to:
  /// **'Punctuality'**
  String get patientReviewPunctuality;

  /// No description provided for @patientReviewCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get patientReviewCommunication;

  /// No description provided for @patientReviewServiceQuality.
  ///
  /// In en, this message translates to:
  /// **'Service Quality'**
  String get patientReviewServiceQuality;

  /// No description provided for @patientReviewTextOptional.
  ///
  /// In en, this message translates to:
  /// **'Review Text (Optional)'**
  String get patientReviewTextOptional;

  /// No description provided for @patientReviewTextHint.
  ///
  /// In en, this message translates to:
  /// **'Share details about your experience...'**
  String get patientReviewTextHint;

  /// No description provided for @patientReviewLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get patientReviewLater;

  /// No description provided for @patientReviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get patientReviewSubmit;

  /// No description provided for @patientReviewServiceShort.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get patientReviewServiceShort;

  /// No description provided for @patientReviewServiceLine.
  ///
  /// In en, this message translates to:
  /// **'Service: {name}'**
  String patientReviewServiceLine(String name);

  /// No description provided for @patientReviewNurseShort.
  ///
  /// In en, this message translates to:
  /// **'Nurse'**
  String get patientReviewNurseShort;

  /// No description provided for @patientReviewNurseLine.
  ///
  /// In en, this message translates to:
  /// **'Nurse: {name}'**
  String patientReviewNurseLine(String name);

  /// No description provided for @patientReviewCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get patientReviewCloseTooltip;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get personalInfo;

  /// No description provided for @profileAddressSection.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAddressSection;

  /// No description provided for @profileMedicalSection.
  ///
  /// In en, this message translates to:
  /// **'Medical info'**
  String get profileMedicalSection;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood type'**
  String get bloodType;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditProfile;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get profileSelectGender;

  /// No description provided for @profileSelectBloodType.
  ///
  /// In en, this message translates to:
  /// **'Select blood type'**
  String get profileSelectBloodType;

  /// No description provided for @profileSelectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Select governorate'**
  String get profileSelectGovernorate;

  /// No description provided for @profileSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get profileSelectDate;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get profileConditions;

  /// No description provided for @profileAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get profileAllergies;

  /// No description provided for @profileNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get profileNotes;

  /// No description provided for @profileNoneCombinationWarning.
  ///
  /// In en, this message translates to:
  /// **'None cannot be combined with other conditions.'**
  String get profileNoneCombinationWarning;

  /// No description provided for @profileOtherConditionOptional.
  ///
  /// In en, this message translates to:
  /// **'Other condition (optional)'**
  String get profileOtherConditionOptional;

  /// No description provided for @profileConditionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cancer, Kidney disease'**
  String get profileConditionHint;

  /// No description provided for @profileOtherAllergiesOptional.
  ///
  /// In en, this message translates to:
  /// **'Other allergies (optional)'**
  String get profileOtherAllergiesOptional;

  /// No description provided for @profileAllergiesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Seafood, Aspirin'**
  String get profileAllergiesHint;

  /// No description provided for @profileConditionDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get profileConditionDiabetes;

  /// No description provided for @profileConditionHypertension.
  ///
  /// In en, this message translates to:
  /// **'Hypertension'**
  String get profileConditionHypertension;

  /// No description provided for @profileConditionAsthma.
  ///
  /// In en, this message translates to:
  /// **'Asthma'**
  String get profileConditionAsthma;

  /// No description provided for @profileConditionHeartDisease.
  ///
  /// In en, this message translates to:
  /// **'Heart disease'**
  String get profileConditionHeartDisease;

  /// No description provided for @profileConditionArthritis.
  ///
  /// In en, this message translates to:
  /// **'Arthritis'**
  String get profileConditionArthritis;

  /// No description provided for @profileConditionNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get profileConditionNone;

  /// No description provided for @profileGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileGenderMale;

  /// No description provided for @profileGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileGenderFemale;

  /// No description provided for @profileAllergyPenicillin.
  ///
  /// In en, this message translates to:
  /// **'Penicillin'**
  String get profileAllergyPenicillin;

  /// No description provided for @profileAllergyDust.
  ///
  /// In en, this message translates to:
  /// **'Dust'**
  String get profileAllergyDust;

  /// No description provided for @profileAllergyFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get profileAllergyFood;

  /// No description provided for @profileAllergyLatex.
  ///
  /// In en, this message translates to:
  /// **'Latex'**
  String get profileAllergyLatex;

  /// No description provided for @profileAllergyPollen.
  ///
  /// In en, this message translates to:
  /// **'Pollen'**
  String get profileAllergyPollen;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Please log in first'**
  String get notLoggedIn;

  /// No description provided for @patientMoreLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get patientMoreLanguage;

  /// No description provided for @patientMoreLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get patientMoreLanguageEnglish;

  /// No description provided for @patientMoreLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get patientMoreLanguageArabic;

  /// No description provided for @languageSelectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get languageSelectorTitle;

  /// No description provided for @languageSelectorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get languageSelectorSubtitle;

  /// No description provided for @nurseHomeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get nurseHomeWelcomeBack;

  /// No description provided for @nurseHomeDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Nurse'**
  String get nurseHomeDefaultName;

  /// No description provided for @nurseHomeSummaryTodayAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Appointments'**
  String get nurseHomeSummaryTodayAppointments;

  /// No description provided for @nurseHomeSummaryPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get nurseHomeSummaryPendingRequests;

  /// No description provided for @nurseHomeSummaryJodToday.
  ///
  /// In en, this message translates to:
  /// **'JOD Today'**
  String get nurseHomeSummaryJodToday;

  /// No description provided for @nurseHomeWeekSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'This Week Summary'**
  String get nurseHomeWeekSummaryTitle;

  /// No description provided for @nurseHomeWeekCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get nurseHomeWeekCompleted;

  /// No description provided for @nurseHomeWeekCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get nurseHomeWeekCancelled;

  /// No description provided for @nurseHomeWeekJodEarned.
  ///
  /// In en, this message translates to:
  /// **'JOD Earned'**
  String get nurseHomeWeekJodEarned;

  /// No description provided for @nurseHomeQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get nurseHomeQuickActionsTitle;

  /// No description provided for @nurseHomeActionManageAvailabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Availability'**
  String get nurseHomeActionManageAvailabilityTitle;

  /// No description provided for @nurseHomeActionManageAvailabilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your working hours'**
  String get nurseHomeActionManageAvailabilitySubtitle;

  /// No description provided for @nurseHomeActionViewRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'View Requests'**
  String get nurseHomeActionViewRequestsTitle;

  /// No description provided for @nurseHomeActionViewRequestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pending and rejected requests'**
  String get nurseHomeActionViewRequestsSubtitle;

  /// No description provided for @nurseHomeActionAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get nurseHomeActionAppointmentsTitle;

  /// No description provided for @nurseHomeActionAppointmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your appointments'**
  String get nurseHomeActionAppointmentsSubtitle;

  /// No description provided for @nurseHomeTodayScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get nurseHomeTodayScheduleTitle;

  /// No description provided for @nurseHomeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get nurseHomeViewAll;

  /// No description provided for @nurseStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get nurseStatusAccepted;

  /// No description provided for @nurseStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get nurseStatusActive;

  /// No description provided for @nurseStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get nurseStatusCompleted;

  /// No description provided for @nurseStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get nurseStatusCancelled;

  /// No description provided for @nurseStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get nurseStatusRejected;

  /// No description provided for @nurseStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get nurseStatusPending;

  /// No description provided for @nurseHomePatientFallback.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get nurseHomePatientFallback;

  /// No description provided for @nurseHomeEarningsJod.
  ///
  /// In en, this message translates to:
  /// **'{amount} JOD'**
  String nurseHomeEarningsJod(String amount);

  /// No description provided for @nurseHomeNoAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'No appointments for today'**
  String get nurseHomeNoAppointmentsToday;

  /// No description provided for @nurseHomeNoAppointmentsTodayHint.
  ///
  /// In en, this message translates to:
  /// **'Today appointments will appear here.'**
  String get nurseHomeNoAppointmentsTodayHint;

  /// No description provided for @nurseHomeAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Available'**
  String get nurseHomeAvailableTitle;

  /// No description provided for @nurseHomeAvailableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can receive new service requests'**
  String get nurseHomeAvailableSubtitle;

  /// No description provided for @nurseNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nurseNavHome;

  /// No description provided for @nurseNavAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get nurseNavAvailability;

  /// No description provided for @nurseNavAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get nurseNavAppointments;

  /// No description provided for @nurseNavRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get nurseNavRequests;

  /// No description provided for @nurseNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nurseNavProfile;

  /// No description provided for @nurseRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Requests'**
  String get nurseRequestsTitle;

  /// No description provided for @nurseRequestsPendingCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} pending requests'**
  String nurseRequestsPendingCountSubtitle(int count);

  /// No description provided for @nurseRequestsRejectedCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} rejected requests'**
  String nurseRequestsRejectedCountSubtitle(int count);

  /// No description provided for @nurseRequestsTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending ({count})'**
  String nurseRequestsTabPending(int count);

  /// No description provided for @nurseRequestsTabRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected ({count})'**
  String nurseRequestsTabRejected(int count);

  /// No description provided for @nurseRequestsEmptyPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get nurseRequestsEmptyPendingTitle;

  /// No description provided for @nurseRequestsEmptyPendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New service requests will appear here.'**
  String get nurseRequestsEmptyPendingSubtitle;

  /// No description provided for @nurseRequestsEmptyRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'No rejected requests'**
  String get nurseRequestsEmptyRejectedTitle;

  /// No description provided for @nurseRequestsEmptyRejectedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rejected requests will appear here for reference.'**
  String get nurseRequestsEmptyRejectedSubtitle;

  /// No description provided for @nurseRequestsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load requests'**
  String get nurseRequestsLoadErrorTitle;

  /// No description provided for @nurseRequestsLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get nurseRequestsLoadErrorSubtitle;

  /// No description provided for @nurseRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get nurseRetry;

  /// No description provided for @nurseRequestsRejectDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get nurseRequestsRejectDialogTitle;

  /// No description provided for @nurseRequestsRejectDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this request?'**
  String get nurseRequestsRejectDialogMessage;

  /// No description provided for @nurseDialogNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get nurseDialogNo;

  /// No description provided for @nurseReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get nurseReject;

  /// No description provided for @nurseAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get nurseAccept;

  /// No description provided for @nurseRequestsAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request accepted successfully.'**
  String get nurseRequestsAcceptedSuccess;

  /// No description provided for @nurseRequestsRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request rejected successfully.'**
  String get nurseRequestsRejectedSuccess;

  /// No description provided for @nurseRequestsDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String nurseRequestsDurationMinutes(int minutes);

  /// No description provided for @nurseAvailEmbeddedTitle.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get nurseAvailEmbeddedTitle;

  /// No description provided for @nurseAvailManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Availability'**
  String get nurseAvailManageTitle;

  /// No description provided for @nurseAvailTapDateHint.
  ///
  /// In en, this message translates to:
  /// **'Tap any date to manage or block it'**
  String get nurseAvailTapDateHint;

  /// No description provided for @nurseAvailWeeklySchedule.
  ///
  /// In en, this message translates to:
  /// **'Weekly Schedule'**
  String get nurseAvailWeeklySchedule;

  /// No description provided for @nurseAvailAddTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Add Time Slot'**
  String get nurseAvailAddTimeSlot;

  /// No description provided for @nurseAvailNoScheduleYet.
  ///
  /// In en, this message translates to:
  /// **'No schedule set yet'**
  String get nurseAvailNoScheduleYet;

  /// No description provided for @nurseAvailNoScheduleHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Time Slot\" to set your working hours'**
  String get nurseAvailNoScheduleHint;

  /// No description provided for @nurseAvailSave.
  ///
  /// In en, this message translates to:
  /// **'Save Availability'**
  String get nurseAvailSave;

  /// No description provided for @nurseAvailSaveAutoMessage.
  ///
  /// In en, this message translates to:
  /// **'Changes are saved automatically after each action'**
  String get nurseAvailSaveAutoMessage;

  /// No description provided for @nurseAvailTimeSlotAdded.
  ///
  /// In en, this message translates to:
  /// **'Time slot added successfully'**
  String get nurseAvailTimeSlotAdded;

  /// No description provided for @nurseAvailDayBlocked.
  ///
  /// In en, this message translates to:
  /// **'Day blocked successfully'**
  String get nurseAvailDayBlocked;

  /// No description provided for @nurseAvailDayUnblocked.
  ///
  /// In en, this message translates to:
  /// **'Day unblocked successfully'**
  String get nurseAvailDayUnblocked;

  /// No description provided for @nurseAvailOverrideSuccess.
  ///
  /// In en, this message translates to:
  /// **'Working hours overridden: {start} - {end}'**
  String nurseAvailOverrideSuccess(String start, String end);

  /// No description provided for @nurseAvailSlotDeleted.
  ///
  /// In en, this message translates to:
  /// **'Slot deleted successfully'**
  String get nurseAvailSlotDeleted;

  /// No description provided for @nurseAvailSlotStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Slot status updated'**
  String get nurseAvailSlotStatusUpdated;

  /// No description provided for @nurseAvailManageDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Day'**
  String get nurseAvailManageDayTitle;

  /// No description provided for @nurseAvailWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get nurseAvailWorkingHours;

  /// No description provided for @nurseAvailNoHoursThisDay.
  ///
  /// In en, this message translates to:
  /// **'No scheduled hours for this day'**
  String get nurseAvailNoHoursThisDay;

  /// No description provided for @nurseAvailFromWeeklySchedule.
  ///
  /// In en, this message translates to:
  /// **'From your weekly schedule'**
  String get nurseAvailFromWeeklySchedule;

  /// No description provided for @nurseAvailDayBlockedShort.
  ///
  /// In en, this message translates to:
  /// **'This day is blocked'**
  String get nurseAvailDayBlockedShort;

  /// No description provided for @nurseAvailCustomOverrideApplied.
  ///
  /// In en, this message translates to:
  /// **'Custom override applied'**
  String get nurseAvailCustomOverrideApplied;

  /// No description provided for @nurseAvailOverrideHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Override Working Hours'**
  String get nurseAvailOverrideHoursTitle;

  /// No description provided for @nurseAvailOverrideHoursSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set custom hours for this date only'**
  String get nurseAvailOverrideHoursSubtitle;

  /// No description provided for @nurseAvailBlockDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Block This Day'**
  String get nurseAvailBlockDayTitle;

  /// No description provided for @nurseAvailUnblockDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Unblock This Day'**
  String get nurseAvailUnblockDayTitle;

  /// No description provided for @nurseAvailUnblockDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make this day available again'**
  String get nurseAvailUnblockDaySubtitle;

  /// No description provided for @nurseAvailBlockDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as unavailable (vacation, day off)'**
  String get nurseAvailBlockDaySubtitle;

  /// No description provided for @nurseAvailOverrideHoursForDate.
  ///
  /// In en, this message translates to:
  /// **'Set custom hours for {date}'**
  String nurseAvailOverrideHoursForDate(String date);

  /// No description provided for @nurseAvailStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get nurseAvailStartTime;

  /// No description provided for @nurseAvailEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get nurseAvailEndTime;

  /// No description provided for @nurseAvailCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get nurseAvailCancel;

  /// No description provided for @nurseAvailSaveOverride.
  ///
  /// In en, this message translates to:
  /// **'Save Override'**
  String get nurseAvailSaveOverride;

  /// No description provided for @nurseAvailBlockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Block this day?'**
  String get nurseAvailBlockConfirmTitle;

  /// No description provided for @nurseAvailBlockConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Patients will not be able to book appointments on this day.'**
  String get nurseAvailBlockConfirmMessage;

  /// No description provided for @nurseAvailBlockDay.
  ///
  /// In en, this message translates to:
  /// **'Block Day'**
  String get nurseAvailBlockDay;

  /// No description provided for @nurseAvailQuickSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Settings'**
  String get nurseAvailQuickSettingsTitle;

  /// No description provided for @nurseAvailQuickCopyWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Copy to All Weekdays'**
  String get nurseAvailQuickCopyWeekdays;

  /// No description provided for @nurseAvailQuickCopyWeekdaysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Apply Monday schedule to Tue–Fri'**
  String get nurseAvailQuickCopyWeekdaysSubtitle;

  /// No description provided for @nurseAvailQuickWeekend.
  ///
  /// In en, this message translates to:
  /// **'Set Weekend Availability'**
  String get nurseAvailQuickWeekend;

  /// No description provided for @nurseAvailQuickWeekendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure Saturday & Sunday hours'**
  String get nurseAvailQuickWeekendSubtitle;

  /// No description provided for @nurseAvailQuickBlockDays.
  ///
  /// In en, this message translates to:
  /// **'Block Specific Days'**
  String get nurseAvailQuickBlockDays;

  /// No description provided for @nurseAvailQuickBlockDaysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mark days when you\'re unavailable'**
  String get nurseAvailQuickBlockDaysSubtitle;

  /// No description provided for @nurseAvailQuickPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Quick settings are UI-only for now'**
  String get nurseAvailQuickPlaceholder;

  /// No description provided for @nurseAvailQuickBlockHint.
  ///
  /// In en, this message translates to:
  /// **'Use the calendar to block specific days'**
  String get nurseAvailQuickBlockHint;

  /// No description provided for @nurseAvailAddWorkingHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Working Hours'**
  String get nurseAvailAddWorkingHoursTitle;

  /// No description provided for @nurseAvailAddWorkingHoursSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your weekly schedule'**
  String get nurseAvailAddWorkingHoursSubtitle;

  /// No description provided for @nurseAvailSelectDay.
  ///
  /// In en, this message translates to:
  /// **'Select Day'**
  String get nurseAvailSelectDay;

  /// No description provided for @nurseAvailSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get nurseAvailSummary;

  /// No description provided for @nurseAvailSummaryDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get nurseAvailSummaryDay;

  /// No description provided for @nurseAvailSummaryHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get nurseAvailSummaryHours;

  /// No description provided for @nurseAvailSummaryDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get nurseAvailSummaryDuration;

  /// No description provided for @nurseAvailBookingNote.
  ///
  /// In en, this message translates to:
  /// **'Note: The system will automatically generate available booking slots based on your working hours and service durations.'**
  String get nurseAvailBookingNote;

  /// No description provided for @nurseAvailAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Working Hours'**
  String get nurseAvailAddButton;

  /// No description provided for @nurseAvailInvalidTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Invalid range'**
  String get nurseAvailInvalidTimeRange;

  /// No description provided for @nurseAvailEndAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get nurseAvailEndAfterStart;

  /// No description provided for @nurseAvailWeekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get nurseAvailWeekdayMonday;

  /// No description provided for @nurseAvailWeekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get nurseAvailWeekdayTuesday;

  /// No description provided for @nurseAvailWeekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get nurseAvailWeekdayWednesday;

  /// No description provided for @nurseAvailWeekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get nurseAvailWeekdayThursday;

  /// No description provided for @nurseAvailWeekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get nurseAvailWeekdayFriday;

  /// No description provided for @nurseAvailWeekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get nurseAvailWeekdaySaturday;

  /// No description provided for @nurseAvailWeekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get nurseAvailWeekdaySunday;

  /// No description provided for @nurseAvailSlotCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 slot} other{{count} slots}}'**
  String nurseAvailSlotCount(int count);

  /// No description provided for @nurseAvailDeactivateSlot.
  ///
  /// In en, this message translates to:
  /// **'Deactivate slot'**
  String get nurseAvailDeactivateSlot;

  /// No description provided for @nurseAvailActivateSlot.
  ///
  /// In en, this message translates to:
  /// **'Activate slot'**
  String get nurseAvailActivateSlot;

  /// No description provided for @nurseAvailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get nurseAvailDelete;

  /// No description provided for @nurseAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get nurseAppointmentsTitle;

  /// No description provided for @nurseAppointmentsTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today ({count})'**
  String nurseAppointmentsTabToday(int count);

  /// No description provided for @nurseAppointmentsTabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming ({count})'**
  String nurseAppointmentsTabUpcoming(int count);

  /// No description provided for @nurseAppointmentsTabPast.
  ///
  /// In en, this message translates to:
  /// **'Past ({count})'**
  String nurseAppointmentsTabPast(int count);

  /// No description provided for @nurseAppointmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No appointments right now'**
  String get nurseAppointmentsEmpty;

  /// No description provided for @nurseAppointmentsErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get nurseAppointmentsErrorGeneric;

  /// No description provided for @nurseLoginRequiredShort.
  ///
  /// In en, this message translates to:
  /// **'Please log in'**
  String get nurseLoginRequiredShort;

  /// No description provided for @nurseProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nurseProfileTitle;

  /// No description provided for @nurseProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account & preferences'**
  String get nurseProfileSubtitle;

  /// No description provided for @nurseProfilePersonalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get nurseProfilePersonalInfoTitle;

  /// No description provided for @nurseProfilePersonalInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile, services & professional details'**
  String get nurseProfilePersonalInfoSubtitle;

  /// No description provided for @nurseProfileRatingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get nurseProfileRatingsTitle;

  /// No description provided for @nurseProfileRatingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews from patients'**
  String get nurseProfileRatingsSubtitle;

  /// No description provided for @nurseProfileEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get nurseProfileEarningsTitle;

  /// No description provided for @nurseProfileEarningsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payouts and transaction history'**
  String get nurseProfileEarningsSubtitle;

  /// No description provided for @nurseProfileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get nurseProfileLogoutTitle;

  /// No description provided for @nurseProfileLogoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of this device'**
  String get nurseProfileLogoutSubtitle;

  /// No description provided for @nurseProfileLogoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get nurseProfileLogoutDialogTitle;

  /// No description provided for @nurseProfileLogoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your account.'**
  String get nurseProfileLogoutDialogMessage;

  /// No description provided for @nurseProfileLogoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed: {error}'**
  String nurseProfileLogoutFailed(String error);

  /// No description provided for @nursePersonalLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile: {error}'**
  String nursePersonalLoadFailed(String error);

  /// No description provided for @nursePersonalExperienceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Experience must be a valid number'**
  String get nursePersonalExperienceInvalid;

  /// No description provided for @nursePersonalUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get nursePersonalUpdatedSuccess;

  /// No description provided for @nursePersonalUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String nursePersonalUpdateFailed(String error);

  /// No description provided for @nursePersonalHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get nursePersonalHeaderTitle;

  /// No description provided for @nursePersonalHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your professional information'**
  String get nursePersonalHeaderSubtitle;

  /// No description provided for @nursePersonalSectionPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get nursePersonalSectionPersonal;

  /// No description provided for @nursePersonalSectionProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional Details'**
  String get nursePersonalSectionProfessional;

  /// No description provided for @nursePersonalSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get nursePersonalSaveChanges;

  /// No description provided for @nursePersonalFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nursePersonalFullName;

  /// No description provided for @nursePersonalEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get nursePersonalEmail;

  /// No description provided for @nursePersonalPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get nursePersonalPhone;

  /// No description provided for @nursePersonalLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get nursePersonalLocation;

  /// No description provided for @nursePersonalAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get nursePersonalAddress;

  /// No description provided for @nursePersonalNationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nursePersonalNationalId;

  /// No description provided for @nursePersonalBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get nursePersonalBio;

  /// No description provided for @nursePersonalLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get nursePersonalLicenseNumber;

  /// No description provided for @nursePersonalSpecialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get nursePersonalSpecialization;

  /// No description provided for @nursePersonalExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get nursePersonalExperience;

  /// No description provided for @nursePersonalServicesOffered.
  ///
  /// In en, this message translates to:
  /// **'Services Offered'**
  String get nursePersonalServicesOffered;

  /// No description provided for @nursePersonalNoServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No services found.'**
  String get nursePersonalNoServicesFound;

  /// No description provided for @nurseServiceAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get nurseServiceAddTitle;

  /// No description provided for @nurseServiceAddSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a service you provide'**
  String get nurseServiceAddSubtitle;

  /// No description provided for @nurseServiceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get nurseServiceEditTitle;

  /// No description provided for @nurseServiceEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your service pricing'**
  String get nurseServiceEditSubtitle;

  /// No description provided for @nurseServiceSelectRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a service'**
  String get nurseServiceSelectRequired;

  /// No description provided for @nurseServicePriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get nurseServicePriceInvalid;

  /// No description provided for @nurseServiceAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service added successfully'**
  String get nurseServiceAddedSuccess;

  /// No description provided for @nurseServiceUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service updated successfully'**
  String get nurseServiceUpdatedSuccess;

  /// No description provided for @nurseServiceDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service deleted successfully'**
  String get nurseServiceDeletedSuccess;

  /// No description provided for @nurseServiceSelectLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Service *'**
  String get nurseServiceSelectLabel;

  /// No description provided for @nurseServiceDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Duration'**
  String get nurseServiceDurationLabel;

  /// No description provided for @nurseServicePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Price *'**
  String get nurseServicePriceLabel;

  /// No description provided for @nurseServicePriceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your price'**
  String get nurseServicePriceHint;

  /// No description provided for @nurseServicePriceHelp.
  ///
  /// In en, this message translates to:
  /// **'Set your price for this service'**
  String get nurseServicePriceHelp;

  /// No description provided for @nurseServiceChooseHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a service...'**
  String get nurseServiceChooseHint;

  /// No description provided for @nurseServiceSelectFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a service first'**
  String get nurseServiceSelectFirst;

  /// No description provided for @nurseServiceFixedDuration.
  ///
  /// In en, this message translates to:
  /// **'(Fixed duration)'**
  String get nurseServiceFixedDuration;

  /// No description provided for @nurseServiceMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String nurseServiceMinutes(int count);

  /// No description provided for @nurseServiceCurrencyJod.
  ///
  /// In en, this message translates to:
  /// **'JOD'**
  String get nurseServiceCurrencyJod;

  /// No description provided for @nurseServiceAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get nurseServiceAddButton;

  /// No description provided for @nurseServiceUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Service'**
  String get nurseServiceUpdateButton;

  /// No description provided for @nurseServiceDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get nurseServiceDeleteTitle;

  /// No description provided for @nurseServiceDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this service?'**
  String get nurseServiceDeleteConfirm;

  /// No description provided for @nurseServiceNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Note:'**
  String get nurseServiceNoteTitle;

  /// No description provided for @nurseServiceAddNoteBody.
  ///
  /// In en, this message translates to:
  /// **'Service duration comes from the backend catalog. You only choose the service and enter your price.'**
  String get nurseServiceAddNoteBody;

  /// No description provided for @nurseServiceEditNoteBody.
  ///
  /// In en, this message translates to:
  /// **'Service duration comes from the backend catalog. You can update the selected service and price only.'**
  String get nurseServiceEditNoteBody;

  /// No description provided for @nurseServiceSummaryService.
  ///
  /// In en, this message translates to:
  /// **'Service: {name}'**
  String nurseServiceSummaryService(String name);

  /// No description provided for @nurseServiceSummaryDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {value}'**
  String nurseServiceSummaryDuration(String value);

  /// No description provided for @nurseServiceSummaryPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Price:'**
  String get nurseServiceSummaryPriceLabel;

  /// No description provided for @nurseServiceSummaryPriceValue.
  ///
  /// In en, this message translates to:
  /// **'{price} JOD'**
  String nurseServiceSummaryPriceValue(String price);

  /// No description provided for @nurseRatingsBasedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on {count} reviews'**
  String nurseRatingsBasedOn(int count);

  /// No description provided for @nurseRatingsRecentReviews.
  ///
  /// In en, this message translates to:
  /// **'Recent reviews'**
  String get nurseRatingsRecentReviews;

  /// No description provided for @nurseRatingsMockName1.
  ///
  /// In en, this message translates to:
  /// **'Ahmad M.'**
  String get nurseRatingsMockName1;

  /// No description provided for @nurseRatingsMockComment1.
  ///
  /// In en, this message translates to:
  /// **'Very professional and punctual. Highly recommend.'**
  String get nurseRatingsMockComment1;

  /// No description provided for @nurseRatingsMockName2.
  ///
  /// In en, this message translates to:
  /// **'Rania K.'**
  String get nurseRatingsMockName2;

  /// No description provided for @nurseRatingsMockComment2.
  ///
  /// In en, this message translates to:
  /// **'Excellent wound care. Clear explanations.'**
  String get nurseRatingsMockComment2;

  /// No description provided for @nurseRatingsMockName3.
  ///
  /// In en, this message translates to:
  /// **'Sara Al-Masri'**
  String get nurseRatingsMockName3;

  /// No description provided for @nurseRatingsMockComment3.
  ///
  /// In en, this message translates to:
  /// **'Great visit; would book again.'**
  String get nurseRatingsMockComment3;

  /// No description provided for @nurseEarningsPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get nurseEarningsPlaceholderTitle;

  /// No description provided for @nurseEarningsPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Detailed earnings and payout history will appear here once connected to your backend.'**
  String get nurseEarningsPlaceholderBody;

  /// No description provided for @nurseRegTitle.
  ///
  /// In en, this message translates to:
  /// **'Nurse Registration'**
  String get nurseRegTitle;

  /// No description provided for @nurseRegPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get nurseRegPhoneLabel;

  /// No description provided for @nurseRegPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 079XXXXXXX'**
  String get nurseRegPhoneHint;

  /// No description provided for @nurseRegNationalIdLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID Number'**
  String get nurseRegNationalIdLabel;

  /// No description provided for @nurseRegNationalIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your national ID'**
  String get nurseRegNationalIdHint;

  /// No description provided for @nurseRegLicenseLabel.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get nurseRegLicenseLabel;

  /// No description provided for @nurseRegLicenseHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your nursing license number'**
  String get nurseRegLicenseHint;

  /// No description provided for @nurseRegGovernorateLabel.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get nurseRegGovernorateLabel;

  /// No description provided for @nurseRegGovernorateSelect.
  ///
  /// In en, this message translates to:
  /// **'Select governorate'**
  String get nurseRegGovernorateSelect;

  /// No description provided for @nurseRegAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area / Neighborhood'**
  String get nurseRegAreaLabel;

  /// No description provided for @nurseRegAreaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Abdoun, Jabal Amman'**
  String get nurseRegAreaHint;

  /// No description provided for @nurseRegSpecializationLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get nurseRegSpecializationLabel;

  /// No description provided for @nurseRegSpecializationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. ICU, Elderly Care'**
  String get nurseRegSpecializationHint;

  /// No description provided for @nurseRegExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience Years'**
  String get nurseRegExperienceLabel;

  /// No description provided for @nurseRegExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get nurseRegExperienceHint;

  /// No description provided for @nurseRegBioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get nurseRegBioLabel;

  /// No description provided for @nurseRegBioHint.
  ///
  /// In en, this message translates to:
  /// **'Write a short bio about your experience'**
  String get nurseRegBioHint;

  /// No description provided for @nurseRegUploadNationalIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload National ID Image'**
  String get nurseRegUploadNationalIdTitle;

  /// No description provided for @nurseRegUploadLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Nursing License PDF'**
  String get nurseRegUploadLicenseTitle;

  /// No description provided for @nurseRegUploadProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Photo'**
  String get nurseRegUploadProfileTitle;

  /// No description provided for @nurseRegUploadImageHint.
  ///
  /// In en, this message translates to:
  /// **'JPG / JPEG / PNG'**
  String get nurseRegUploadImageHint;

  /// No description provided for @nurseRegUploadPdfHint.
  ///
  /// In en, this message translates to:
  /// **'PDF only'**
  String get nurseRegUploadPdfHint;

  /// No description provided for @nurseRegConfirmAccuracy.
  ///
  /// In en, this message translates to:
  /// **'I confirm all information is accurate'**
  String get nurseRegConfirmAccuracy;

  /// No description provided for @nurseRegSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Registration'**
  String get nurseRegSubmit;

  /// No description provided for @nurseRegRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get nurseRegRequiredField;

  /// No description provided for @nurseRegSelectGovernorateError.
  ///
  /// In en, this message translates to:
  /// **'Please select governorate'**
  String get nurseRegSelectGovernorateError;

  /// No description provided for @nurseRegConfirmInfoError.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the information'**
  String get nurseRegConfirmInfoError;

  /// No description provided for @nurseRegExperienceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Experience years must be a valid number'**
  String get nurseRegExperienceInvalid;

  /// No description provided for @nurseRegUploadNationalIdError.
  ///
  /// In en, this message translates to:
  /// **'Please upload national ID image'**
  String get nurseRegUploadNationalIdError;

  /// No description provided for @nurseRegUploadLicenseError.
  ///
  /// In en, this message translates to:
  /// **'Please upload nursing license PDF'**
  String get nurseRegUploadLicenseError;

  /// No description provided for @nurseRegUploadProfilePhotoError.
  ///
  /// In en, this message translates to:
  /// **'Please upload profile photo'**
  String get nurseRegUploadProfilePhotoError;

  /// No description provided for @nurseRegSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration submitted successfully'**
  String get nurseRegSubmittedSuccess;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsNurseTitle.
  ///
  /// In en, this message translates to:
  /// **'Nurse Notifications'**
  String get notificationsNurseTitle;

  /// No description provided for @notificationsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get notificationsLoadFailed;

  /// No description provided for @notificationsMarkOneFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark notification as read'**
  String get notificationsMarkOneFailed;

  /// No description provided for @notificationsMarkAllFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark all notifications as read'**
  String get notificationsMarkAllFailed;

  /// No description provided for @notificationsNoLinkedScreen.
  ///
  /// In en, this message translates to:
  /// **'No screen linked to this notification'**
  String get notificationsNoLinkedScreen;

  /// No description provided for @notificationsNoBookingLinked.
  ///
  /// In en, this message translates to:
  /// **'No booking linked'**
  String get notificationsNoBookingLinked;

  /// No description provided for @notificationsOpenDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open appointment details'**
  String get notificationsOpenDetailsFailed;

  /// No description provided for @notificationsUnhandledTarget.
  ///
  /// In en, this message translates to:
  /// **'Unhandled target screen: {target}'**
  String notificationsUnhandledTarget(String target);

  /// No description provided for @notificationsReadAll.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get notificationsReadAll;

  /// No description provided for @notificationsUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 unread notification} other{{count} unread notifications}}'**
  String notificationsUnreadCount(int count);

  /// No description provided for @notificationsAllRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications are read'**
  String get notificationsAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationsJustNow;

  /// No description provided for @notificationsMinAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String notificationsMinAgo(int count);

  /// No description provided for @notificationsHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String notificationsHoursAgo(int count);

  /// No description provided for @notificationsDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String notificationsDaysAgo(int count);

  /// No description provided for @notificationsMarkAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get notificationsMarkAsRead;

  /// No description provided for @nurseAppointmentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get nurseAppointmentDetailsTitle;

  /// No description provided for @nurseAppointmentWaitingBanner.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Payment\nYou confirmed this appointment. The patient needs to complete payment to activate it.'**
  String get nurseAppointmentWaitingBanner;

  /// No description provided for @nurseAppointmentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get nurseAppointmentStatusLabel;

  /// No description provided for @nurseAppointmentPatientInformation.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get nurseAppointmentPatientInformation;

  /// No description provided for @nurseAppointmentCallPatient.
  ///
  /// In en, this message translates to:
  /// **'Call Patient'**
  String get nurseAppointmentCallPatient;

  /// No description provided for @nurseAppointmentWhatsAppPatient.
  ///
  /// In en, this message translates to:
  /// **'Message on WhatsApp'**
  String get nurseAppointmentWhatsAppPatient;

  /// No description provided for @nurseAppointmentDetailsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get nurseAppointmentDetailsSectionTitle;

  /// No description provided for @nurseAppointmentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get nurseAppointmentDateLabel;

  /// No description provided for @nurseAppointmentTimeDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Time & Duration'**
  String get nurseAppointmentTimeDurationLabel;

  /// No description provided for @nurseAppointmentServiceLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Location'**
  String get nurseAppointmentServiceLocationLabel;

  /// No description provided for @nurseAppointmentYourEarnings.
  ///
  /// In en, this message translates to:
  /// **'Your Earnings'**
  String get nurseAppointmentYourEarnings;

  /// No description provided for @nurseAppointmentPaymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get nurseAppointmentPaymentStatusLabel;

  /// No description provided for @nurseAppointmentMarkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get nurseAppointmentMarkCompleted;

  /// No description provided for @nurseAppointmentCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get nurseAppointmentCancelTitle;

  /// No description provided for @nurseAppointmentCancelConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get nurseAppointmentCancelConfirmMessage;

  /// No description provided for @nurseAppointmentCompleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this appointment as completed?'**
  String get nurseAppointmentCompleteConfirmMessage;

  /// No description provided for @nurseAppointmentCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled successfully.'**
  String get nurseAppointmentCancelledSuccess;

  /// No description provided for @nurseAppointmentCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment marked as completed.'**
  String get nurseAppointmentCompletedSuccess;

  /// No description provided for @nurseAppointmentStatusWaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Payment'**
  String get nurseAppointmentStatusWaitingPayment;

  /// No description provided for @nurseAppointmentStatusActivePaid.
  ///
  /// In en, this message translates to:
  /// **'Active / Paid'**
  String get nurseAppointmentStatusActivePaid;

  /// No description provided for @nurseAppointmentPaymentPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get nurseAppointmentPaymentPaid;

  /// No description provided for @nurseAppointmentPaymentUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get nurseAppointmentPaymentUnpaid;

  /// No description provided for @nurseAppointmentPaymentNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get nurseAppointmentPaymentNotApplicable;

  /// No description provided for @nurseAppointmentServiceFallback.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get nurseAppointmentServiceFallback;

  /// No description provided for @nurseAppointmentPaymentPendingBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Patient hasn\'t paid yet — you can contact or cancel.'**
  String get nurseAppointmentPaymentPendingBannerBody;

  /// No description provided for @patientAppointmentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get patientAppointmentDetailsTitle;

  /// No description provided for @patientAppointmentNurseInformation.
  ///
  /// In en, this message translates to:
  /// **'Nurse Information'**
  String get patientAppointmentNurseInformation;

  /// No description provided for @patientAppointmentCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get patientAppointmentCall;

  /// No description provided for @patientAppointmentWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get patientAppointmentWhatsApp;

  /// No description provided for @patientAppointmentDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get patientAppointmentDate;

  /// No description provided for @patientAppointmentTimeDuration.
  ///
  /// In en, this message translates to:
  /// **'Time & Duration'**
  String get patientAppointmentTimeDuration;

  /// No description provided for @patientAppointmentAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get patientAppointmentAddress;

  /// No description provided for @patientAppointmentTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get patientAppointmentTotalCost;

  /// No description provided for @patientAppointmentPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get patientAppointmentPaymentStatus;

  /// No description provided for @patientAppointmentPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get patientAppointmentPayNow;

  /// No description provided for @patientAppointmentNoActions.
  ///
  /// In en, this message translates to:
  /// **'No actions available for this appointment.'**
  String get patientAppointmentNoActions;

  /// No description provided for @patientAppointmentCancelling.
  ///
  /// In en, this message translates to:
  /// **'Cancelling...'**
  String get patientAppointmentCancelling;

  /// No description provided for @patientAppointmentCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get patientAppointmentCancelButton;

  /// No description provided for @patientAppointmentLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load appointment details'**
  String get patientAppointmentLoadFailed;

  /// No description provided for @patientAppointmentPayToContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay to continue'**
  String get patientAppointmentPayToContinueTitle;

  /// No description provided for @patientAppointmentPayToContinueBody.
  ///
  /// In en, this message translates to:
  /// **'Your nurse confirmed this appointment. Please complete payment to activate it and keep your booking.'**
  String get patientAppointmentPayToContinueBody;

  /// No description provided for @patientAppointmentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get patientAppointmentStatusLabel;

  /// No description provided for @patientAppointmentPhoneUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Phone number is not available.'**
  String get patientAppointmentPhoneUnavailable;

  /// No description provided for @patientAppointmentDialerOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open dialer.'**
  String get patientAppointmentDialerOpenFailed;

  /// No description provided for @patientAppointmentWhatsAppOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp.'**
  String get patientAppointmentWhatsAppOpenFailed;

  /// No description provided for @patientAppointmentCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment'**
  String get patientAppointmentCancelTitle;

  /// No description provided for @patientAppointmentCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get patientAppointmentCancelConfirm;

  /// No description provided for @patientAppointmentCancelConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get patientAppointmentCancelConfirmAction;

  /// No description provided for @patientAppointmentCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled successfully.'**
  String get patientAppointmentCancelledSuccess;

  /// No description provided for @patientAppointmentHours.
  ///
  /// In en, this message translates to:
  /// **'{count} hr'**
  String patientAppointmentHours(int count);

  /// No description provided for @patientAppointmentMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String patientAppointmentMinutes(int count);

  /// No description provided for @patientAppointmentPaymentAwaitingNurse.
  ///
  /// In en, this message translates to:
  /// **'AWAITING NURSE'**
  String get patientAppointmentPaymentAwaitingNurse;

  /// No description provided for @patientAppointmentPaymentUnpaid.
  ///
  /// In en, this message translates to:
  /// **'UNPAID'**
  String get patientAppointmentPaymentUnpaid;

  /// No description provided for @patientAppointmentPaymentPaid.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get patientAppointmentPaymentPaid;

  /// No description provided for @patientAppointmentPaymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get patientAppointmentPaymentCancelled;

  /// No description provided for @patientAppointmentPaymentRejected.
  ///
  /// In en, this message translates to:
  /// **'REJECTED'**
  String get patientAppointmentPaymentRejected;

  /// No description provided for @patientNurseProfileAboutTab.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get patientNurseProfileAboutTab;

  /// No description provided for @patientNurseProfileReviewsTab.
  ///
  /// In en, this message translates to:
  /// **'Reviews ({count})'**
  String patientNurseProfileReviewsTab(int count);

  /// No description provided for @patientNurseProfileLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get patientNurseProfileLocation;

  /// No description provided for @patientNurseProfileAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get patientNurseProfileAvailability;

  /// No description provided for @patientNurseProfileServicesOffered.
  ///
  /// In en, this message translates to:
  /// **'Services Offered'**
  String get patientNurseProfileServicesOffered;

  /// No description provided for @patientNurseProfileNoServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'This nurse has no available services yet.'**
  String get patientNurseProfileNoServicesTitle;

  /// No description provided for @patientNurseProfileNoServicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You cannot book a service at the moment.'**
  String get patientNurseProfileNoServicesSubtitle;

  /// No description provided for @patientNurseProfileReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get patientNurseProfileReviews;

  /// No description provided for @patientNurseProfileReviewsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Reviews will appear after backend review endpoints are available.'**
  String get patientNurseProfileReviewsPlaceholder;

  /// No description provided for @patientNurseProfileBookServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'Book Service Request'**
  String get patientNurseProfileBookServiceRequest;

  /// No description provided for @patientNurseProfileNoServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Services Available'**
  String get patientNurseProfileNoServicesAvailable;

  /// No description provided for @patientRequestServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Request'**
  String get patientRequestServiceTitle;

  /// No description provided for @patientRequestStepServiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get patientRequestStepServiceDetails;

  /// No description provided for @patientRequestStepReviewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get patientRequestStepReviewConfirm;

  /// No description provided for @patientRequestRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields.'**
  String get patientRequestRequiredFields;

  /// No description provided for @patientRequestSelectServiceType.
  ///
  /// In en, this message translates to:
  /// **'Select Service Type'**
  String get patientRequestSelectServiceType;

  /// No description provided for @patientRequestNoServicesForNurse.
  ///
  /// In en, this message translates to:
  /// **'No services available for this nurse.'**
  String get patientRequestNoServicesForNurse;

  /// No description provided for @patientRequestSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get patientRequestSelectDate;

  /// No description provided for @patientRequestNoAvailableDates.
  ///
  /// In en, this message translates to:
  /// **'No available dates found.'**
  String get patientRequestNoAvailableDates;

  /// No description provided for @patientRequestSelectTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Available Time Slot'**
  String get patientRequestSelectTimeSlot;

  /// No description provided for @patientRequestSelectServiceDateFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a service and date to view available time slots.'**
  String get patientRequestSelectServiceDateFirst;

  /// No description provided for @patientRequestNoAvailableTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'No available time slots for this date.'**
  String get patientRequestNoAvailableTimeSlots;

  /// No description provided for @patientRequestServiceAddress.
  ///
  /// In en, this message translates to:
  /// **'Service Address'**
  String get patientRequestServiceAddress;

  /// No description provided for @patientRequestAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your complete address'**
  String get patientRequestAddressHint;

  /// No description provided for @patientRequestAdditionalNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes (Optional)'**
  String get patientRequestAdditionalNotesOptional;

  /// No description provided for @patientRequestNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions or medical information...'**
  String get patientRequestNotesHint;

  /// No description provided for @patientRequestReviewAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review and Confirm'**
  String get patientRequestReviewAndConfirm;

  /// No description provided for @patientRequestReviewYourRequest.
  ///
  /// In en, this message translates to:
  /// **'Review Your Request'**
  String get patientRequestReviewYourRequest;

  /// No description provided for @patientRequestServiceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get patientRequestServiceType;

  /// No description provided for @patientRequestDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get patientRequestDuration;

  /// No description provided for @patientRequestTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get patientRequestTime;

  /// No description provided for @patientRequestNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get patientRequestNotes;

  /// No description provided for @patientRequestServiceCost.
  ///
  /// In en, this message translates to:
  /// **'Service Cost'**
  String get patientRequestServiceCost;

  /// No description provided for @patientRequestService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get patientRequestService;

  /// No description provided for @patientRequestTotalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get patientRequestTotalPrice;

  /// No description provided for @patientRequestSubmitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get patientRequestSubmitRequest;

  /// No description provided for @patientRequestSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted!'**
  String get patientRequestSubmittedTitle;

  /// No description provided for @patientRequestSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'Your service request has been sent to\n{name}. You will receive a\nnotification once the nurse responds.'**
  String patientRequestSubmittedBody(String name);

  /// No description provided for @patientRequestSummary.
  ///
  /// In en, this message translates to:
  /// **'Request Summary'**
  String get patientRequestSummary;

  /// No description provided for @patientRequestNurseLabel.
  ///
  /// In en, this message translates to:
  /// **'Nurse:'**
  String get patientRequestNurseLabel;

  /// No description provided for @patientRequestServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service:'**
  String get patientRequestServiceLabel;

  /// No description provided for @patientRequestDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration:'**
  String get patientRequestDurationLabel;

  /// No description provided for @patientRequestDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get patientRequestDateLabel;

  /// No description provided for @patientRequestTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time:'**
  String get patientRequestTimeLabel;

  /// No description provided for @patientRequestTotalPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Price:'**
  String get patientRequestTotalPriceLabel;

  /// No description provided for @patientRequestBackToNurses.
  ///
  /// In en, this message translates to:
  /// **'Back to Nurses'**
  String get patientRequestBackToNurses;

  /// No description provided for @statusBannerNursePending.
  ///
  /// In en, this message translates to:
  /// **'This booking is waiting for your response.'**
  String get statusBannerNursePending;

  /// No description provided for @statusBannerPatientPending.
  ///
  /// In en, this message translates to:
  /// **'Your request is pending confirmation.'**
  String get statusBannerPatientPending;

  /// No description provided for @statusBannerConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Appointment confirmed. See you at the scheduled time.'**
  String get statusBannerConfirmed;

  /// No description provided for @statusBannerNurseWaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment is pending from the patient.'**
  String get statusBannerNurseWaitingPayment;

  /// No description provided for @statusBannerPatientWaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Please complete payment to finalize this appointment.'**
  String get statusBannerPatientWaitingPayment;

  /// No description provided for @statusBannerPaid.
  ///
  /// In en, this message translates to:
  /// **'Payment received. Appointment is active.'**
  String get statusBannerPaid;

  /// No description provided for @statusBannerCompleted.
  ///
  /// In en, this message translates to:
  /// **'This appointment has been completed.'**
  String get statusBannerCompleted;

  /// No description provided for @statusBannerCancelled.
  ///
  /// In en, this message translates to:
  /// **'This appointment was cancelled.'**
  String get statusBannerCancelled;

  /// No description provided for @statusBannerRejected.
  ///
  /// In en, this message translates to:
  /// **'This request was not accepted.'**
  String get statusBannerRejected;

  /// No description provided for @paymentSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccessTitle;

  /// No description provided for @paymentSuccessAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid: {amount}'**
  String paymentSuccessAmountPaid(String amount);

  /// No description provided for @paymentBackToAppointments.
  ///
  /// In en, this message translates to:
  /// **'Back to Appointments'**
  String get paymentBackToAppointments;

  /// No description provided for @paymentFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailedTitle;

  /// No description provided for @paymentFailedBody.
  ///
  /// In en, this message translates to:
  /// **'We could not process your payment. Please try again.'**
  String get paymentFailedBody;

  /// No description provided for @paymentRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry Payment'**
  String get paymentRetryButton;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotTitle;

  /// No description provided for @forgotEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get forgotEnterEmail;

  /// No description provided for @forgotEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get forgotEnterValidEmail;

  /// No description provided for @forgotServerTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Check backend/email settings and try again.'**
  String get forgotServerTimeoutMessage;

  /// No description provided for @forgotResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotResetPasswordTitle;

  /// No description provided for @forgotResetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will send you a link to reset your password.'**
  String get forgotResetPasswordSubtitle;

  /// No description provided for @forgotResetLinkHint.
  ///
  /// In en, this message translates to:
  /// **'We will send a reset link to your email.'**
  String get forgotResetLinkHint;

  /// No description provided for @forgotSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get forgotSendResetLink;

  /// No description provided for @nurseResubmitTitle.
  ///
  /// In en, this message translates to:
  /// **'Resubmit Verification'**
  String get nurseResubmitTitle;

  /// No description provided for @nurseResubmitNoFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get nurseResubmitNoFileSelected;

  /// No description provided for @nurseResubmitExperienceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Experience years must be a valid number'**
  String get nurseResubmitExperienceInvalid;

  /// No description provided for @nurseResubmitSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Resubmitted successfully. Waiting for admin approval.'**
  String get nurseResubmitSubmittedSuccess;

  /// No description provided for @nurseResubmitSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Submit failed: {error}'**
  String nurseResubmitSubmitFailed(String error);

  /// No description provided for @nurseResubmitUpdateDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Update your details'**
  String get nurseResubmitUpdateDetailsTitle;

  /// No description provided for @nurseResubmitUpdateDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fix the requested items and resubmit your information.\nAfter submitting, your status will return to Pending.'**
  String get nurseResubmitUpdateDetailsSubtitle;

  /// No description provided for @nurseResubmitPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get nurseResubmitPhoneRequired;

  /// No description provided for @nurseResubmitPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get nurseResubmitPhoneInvalid;

  /// No description provided for @nurseResubmitAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get nurseResubmitAddressRequired;

  /// No description provided for @nurseResubmitLocationHint.
  ///
  /// In en, this message translates to:
  /// **'City / Location (e.g., Amman)'**
  String get nurseResubmitLocationHint;

  /// No description provided for @nurseResubmitLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get nurseResubmitLocationRequired;

  /// No description provided for @nurseResubmitNationalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'National ID is required'**
  String get nurseResubmitNationalIdRequired;

  /// No description provided for @nurseResubmitNationalIdInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid National ID'**
  String get nurseResubmitNationalIdInvalid;

  /// No description provided for @nurseResubmitLicenseRequired.
  ///
  /// In en, this message translates to:
  /// **'License number is required'**
  String get nurseResubmitLicenseRequired;

  /// No description provided for @nurseResubmitSpecializationRequired.
  ///
  /// In en, this message translates to:
  /// **'Specialization is required'**
  String get nurseResubmitSpecializationRequired;

  /// No description provided for @nurseResubmitExperienceRequired.
  ///
  /// In en, this message translates to:
  /// **'Experience years is required'**
  String get nurseResubmitExperienceRequired;

  /// No description provided for @nurseResubmitEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get nurseResubmitEnterValidNumber;

  /// No description provided for @nurseResubmitDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get nurseResubmitDocumentsTitle;

  /// No description provided for @nurseResubmitDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload the requested updated files.'**
  String get nurseResubmitDocumentsSubtitle;

  /// No description provided for @nurseResubmitNationalIdTitle.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nurseResubmitNationalIdTitle;

  /// No description provided for @nurseResubmitNationalIdHint.
  ///
  /// In en, this message translates to:
  /// **'Upload your National ID (image/PDF)'**
  String get nurseResubmitNationalIdHint;

  /// No description provided for @nurseResubmitLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Nursing License'**
  String get nurseResubmitLicenseTitle;

  /// No description provided for @nurseResubmitLicenseHint.
  ///
  /// In en, this message translates to:
  /// **'Upload your license (image/PDF)'**
  String get nurseResubmitLicenseHint;

  /// No description provided for @nurseResubmitProfilePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get nurseResubmitProfilePhotoTitle;

  /// No description provided for @nurseResubmitProfilePhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Upload a profile photo (image)'**
  String get nurseResubmitProfilePhotoHint;

  /// No description provided for @nurseResubmitChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get nurseResubmitChoose;

  /// No description provided for @nurseResubmitSubmitForReview.
  ///
  /// In en, this message translates to:
  /// **'Submit for Review'**
  String get nurseResubmitSubmitForReview;

  /// No description provided for @nurseAvailDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String nurseAvailDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @patientOnboardStepOfFour.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 4'**
  String patientOnboardStepOfFour(int step);

  /// No description provided for @patientOnboardSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get patientOnboardSkipForNow;

  /// No description provided for @patientOnboardNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get patientOnboardNext;

  /// No description provided for @patientOnboardGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get patientOnboardGetStarted;

  /// No description provided for @patientOnboardPersonalTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get patientOnboardPersonalTitle;

  /// No description provided for @patientOnboardPersonalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — you can skip and complete this later.'**
  String get patientOnboardPersonalSubtitle;

  /// No description provided for @patientOnboardSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get patientOnboardSelectGender;

  /// No description provided for @patientOnboardSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get patientOnboardSelectDate;

  /// No description provided for @patientOnboardSelectBloodType.
  ///
  /// In en, this message translates to:
  /// **'Select blood type'**
  String get patientOnboardSelectBloodType;

  /// No description provided for @patientOnboardAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get patientOnboardAddressTitle;

  /// No description provided for @patientOnboardAddressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — helps nurses find you faster.'**
  String get patientOnboardAddressSubtitle;

  /// No description provided for @patientOnboardAreaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Abdoun, Jubeiha'**
  String get patientOnboardAreaHint;

  /// No description provided for @patientOnboardStreetLabel.
  ///
  /// In en, this message translates to:
  /// **'Street / building details'**
  String get patientOnboardStreetLabel;

  /// No description provided for @patientOnboardStreetHint.
  ///
  /// In en, this message translates to:
  /// **'Apartment, building, landmarks'**
  String get patientOnboardStreetHint;

  /// No description provided for @patientOnboardMedicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical info'**
  String get patientOnboardMedicalTitle;

  /// No description provided for @patientOnboardMedicalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — share only what you are comfortable with.'**
  String get patientOnboardMedicalSubtitle;

  /// No description provided for @patientOnboardConditionsSection.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get patientOnboardConditionsSection;

  /// No description provided for @patientOnboardConditionsHint.
  ///
  /// In en, this message translates to:
  /// **'Select any that apply. None cannot be combined with other conditions.'**
  String get patientOnboardConditionsHint;

  /// No description provided for @patientOnboardOtherConditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Other condition (optional)'**
  String get patientOnboardOtherConditionLabel;

  /// No description provided for @patientOnboardOtherConditionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cancer, Kidney disease'**
  String get patientOnboardOtherConditionHint;

  /// No description provided for @patientOnboardAllergiesSection.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get patientOnboardAllergiesSection;

  /// No description provided for @patientOnboardAllergiesHint.
  ///
  /// In en, this message translates to:
  /// **'Tap common allergies or add your own below.'**
  String get patientOnboardAllergiesHint;

  /// No description provided for @patientOnboardOtherAllergiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Other allergies (optional)'**
  String get patientOnboardOtherAllergiesLabel;

  /// No description provided for @patientOnboardOtherAllergiesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sulfa, nuts, seafood'**
  String get patientOnboardOtherAllergiesHint;

  /// No description provided for @patientOnboardNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get patientOnboardNotes;

  /// No description provided for @patientOnboardNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything else your care team should know...'**
  String get patientOnboardNotesHint;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
