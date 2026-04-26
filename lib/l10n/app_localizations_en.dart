// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBackTitle => 'Welcome Back!';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get emailAddressLabel => 'Email Address';

  @override
  String get emailFieldHint => 'your.email@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordFieldHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get errorValidEmail => 'Please enter a valid email';

  @override
  String get errorEnterPassword => 'Please enter your password';

  @override
  String errorUnknownNurseStatus(String status) {
    return 'Unknown nurse verification status: $status';
  }

  @override
  String errorUnknownRole(String role) {
    return 'Unknown role: $role';
  }

  @override
  String errorLoginFailed(String message) {
    return 'Login failed: $message';
  }

  @override
  String get signupCreateNurseAccount => 'Create Nurse Account';

  @override
  String get signupCreateAccount => 'Create Account';

  @override
  String get signupNurseSubtitle => 'Complete nurse registration in two steps';

  @override
  String get signupPatientSubtitle => 'Sign up to get started';

  @override
  String get signupStep1Of4 => 'Step 1 of 4';

  @override
  String get signupIAmA => 'I am a:';

  @override
  String get rolePatient => 'Patient';

  @override
  String get roleNurse => 'Nurse';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get validationFullNameRequired => 'Full name is required';

  @override
  String get signupEmailLabel => 'Email Address';

  @override
  String get signupEmailHint => 'Enter your email';

  @override
  String get validationEmailInvalid => 'Enter valid email';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get phoneNumberHint => 'e.g. 0790000000';

  @override
  String get validationPhoneRequired => 'Phone number is required';

  @override
  String get validationPhoneInvalid => 'Enter a valid phone number';

  @override
  String get signupPasswordLabel => 'Password';

  @override
  String get signupPasswordHint => 'Create a password';

  @override
  String get validationPasswordMin => 'Minimum 6 characters';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get validationPasswordsMismatch => 'Passwords do not match';

  @override
  String get continueButton => 'Continue';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signupFooterNurse => 'You will complete verification in the next step.';

  @override
  String get signupFooterPatient => 'Create your account to continue.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String signUpErrorFailed(String message) {
    return 'Sign up failed: $message';
  }

  @override
  String get patientNavHome => 'Home';

  @override
  String get patientNavNurses => 'Nurses';

  @override
  String get patientNavAppointments => 'Appointments';

  @override
  String get patientNavPayments => 'Payments';

  @override
  String get patientNavMore => 'More';

  @override
  String get patientWelcomeBackLine => 'Welcome back,';

  @override
  String get patientSearchNursesHint => 'Search nurses by name or specialty...';

  @override
  String get patientQuickServices => 'Quick Services';

  @override
  String get patientUpcomingAppointments => 'Upcoming Appointments';

  @override
  String get patientViewAll => 'View All';

  @override
  String get patientTotalBookings => 'Total Bookings';

  @override
  String get patientActiveRequests => 'Active Requests';

  @override
  String get patientAppointmentsPlaceholder => 'Appointments section stays as-is.';

  @override
  String get patientLogout => 'Logout';

  @override
  String get patientServiceIvTherapy => 'IV\nTherapy';

  @override
  String get patientServiceWoundCare => 'Wound\nCare';

  @override
  String get patientServicePostSurgery => 'Post-\nSurgery';

  @override
  String get patientServiceMedication => 'Medication';

  @override
  String get patientRateExperienceTitle => 'Rate Your Experience';

  @override
  String patientRateExperienceSubtitle(String nurseName) {
    return 'Help others by sharing your feedback\nabout $nurseName';
  }

  @override
  String get patientWriteReview => 'Write Review';

  @override
  String get patientReviewSubmittedThanks => 'Thanks! Your review was submitted.';

  @override
  String patientLogoutFailed(String message) {
    return 'Logout failed: $message';
  }

  @override
  String get user => 'User';

  @override
  String get patientRetry => 'Retry';

  @override
  String get patientBrowseTitle => 'Browse Nurses';

  @override
  String get patientBrowseSearchHint => 'Search by name or specialty...';

  @override
  String get patientBrowseFilters => 'Filters';

  @override
  String get patientBrowseFilterSheetTitle => 'Filter Nurses';

  @override
  String get patientBrowseReset => 'Reset';

  @override
  String get patientBrowseServiceType => 'Service Type';

  @override
  String get patientBrowseChooseService => 'Choose a service';

  @override
  String get patientBrowseAllServices => 'All Services';

  @override
  String get patientBrowseGovernorate => 'Governorate';

  @override
  String get patientBrowseAllLocations => 'All Locations';

  @override
  String get patientGovZarqa => 'Zarqa';

  @override
  String get patientGovIrbid => 'Irbid';

  @override
  String get patientGovAmman => 'Amman';

  @override
  String get patientGovTafilah => 'Tafilah';

  @override
  String get patientGovKarak => 'Karak';

  @override
  String get patientGovMadaba => 'Madaba';

  @override
  String get patientGovBalqa => 'Balqa';

  @override
  String get patientGovAjloun => 'Ajloun';

  @override
  String get patientGovJerash => 'Jerash';

  @override
  String get patientGovAqaba => 'Aqaba';

  @override
  String get patientGovMaan => 'Ma\'an';

  @override
  String get patientGovMafraq => 'Mafraq';

  @override
  String get patientBrowseApplyFilters => 'Apply Filters';

  @override
  String get patientBrowseClearAll => 'Clear all';

  @override
  String patientBrowseFoundNurses(int count) {
    return 'Found $count nurses';
  }

  @override
  String patientBrowsePageIndicator(int current, int total) {
    return 'Page $current/$total';
  }

  @override
  String get patientBrowseNoResults => 'No nurses match your filters.';

  @override
  String get patientBrowseViewProfile => 'View Profile';

  @override
  String patientBrowseExperienceYears(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years of experience',
      one: '1 year of experience',
    );
    return '$_temp0';
  }

  @override
  String get patientBrowseCatalog1 => 'IV Therapy';

  @override
  String get patientBrowseCatalog2 => 'Wound Care and Dressing';

  @override
  String get patientBrowseCatalog3 => 'Injection or Medication Administration';

  @override
  String get patientBrowseCatalog4 => 'Post-Surgery Care';

  @override
  String get patientBrowseCatalog5 => 'Medication Management';

  @override
  String get patientBrowseCatalog6 => 'Vital Signs Monitoring';

  @override
  String get patientBrowseCatalog7 => 'Blood Draw or Lab Sample Collection';

  @override
  String get patientBrowseCatalog8 => 'Catheter Care';

  @override
  String get patientBrowseCatalog9 => 'Diabetes Monitoring and Insulin Injection';

  @override
  String get patientBrowseCatalog10 => 'Elderly Home Care Visit';

  @override
  String get patientBrowseCatalog11 => 'Oxygen Therapy Setup';

  @override
  String get patientBrowseCatalog12 => 'Nebulizer Therapy Session';

  @override
  String get patientBrowseCatalog13 => 'Stitches Removal';

  @override
  String get patientBrowseCatalog14 => 'Pressure Ulcer Care';

  @override
  String get patientBrowseCatalog15 => 'General Nursing Home Visit';

  @override
  String get patientBrowseCatalog16 => 'Blood Pressure Check';

  @override
  String get patientBrowseCatalog17 => 'Short Care Shift (4 hours)';

  @override
  String get patientBrowseCatalog18 => 'Half-Day Home Care (6 hours)';

  @override
  String get patientBrowseCatalog19 => 'Full-Day Home Care (12 hours)';

  @override
  String get patientAppointmentsTitle => 'My Appointments';

  @override
  String patientAppointmentsUpcomingCount(int count) {
    return 'Upcoming ($count)';
  }

  @override
  String patientAppointmentsPastCount(int count) {
    return 'Past ($count)';
  }

  @override
  String get patientAppointmentsNoUpcoming => 'No upcoming appointments.';

  @override
  String get patientAppointmentsNoPast => 'No past appointments.';

  @override
  String get patientAppointmentsLoadFailed => 'Failed to load appointments';

  @override
  String get patientAppointmentTotal => 'Total';

  @override
  String get patientAppointmentStatusPending => 'Pending';

  @override
  String get patientAppointmentStatusConfirmed => 'Confirmed';

  @override
  String get patientAppointmentStatusActivePaid => 'Active/Paid';

  @override
  String get patientAppointmentStatusCompleted => 'Completed';

  @override
  String get patientAppointmentStatusCancelled => 'Cancelled';

  @override
  String get patientAppointmentStatusRejected => 'Rejected';

  @override
  String get patientPayBannerTitlePayContinue => 'Pay to continue';

  @override
  String get patientPayBannerTitlePaymentRequired => 'Payment required';

  @override
  String get patientPayBannerBodyPayContinue => 'Your nurse confirmed this appointment. Please complete payment to activate it and keep your booking.';

  @override
  String get patientPayBannerBodyPaymentRequired => 'Complete payment to confirm your appointment.';

  @override
  String get patientPaymentTitle => 'Payment';

  @override
  String get patientPaymentBookingSummary => 'Booking Summary';

  @override
  String get patientPaymentLabelNurse => 'Nurse';

  @override
  String get patientPaymentLabelService => 'Service';

  @override
  String get patientPaymentLabelDate => 'Date';

  @override
  String get patientPaymentLabelTime => 'Time';

  @override
  String get patientPaymentLabelAmount => 'Amount';

  @override
  String get patientPaymentMethod => 'Payment Method';

  @override
  String get patientPaymentStripeDisabled => 'Card payments (Stripe) are turned off in this build for local development.';

  @override
  String get patientPaymentConfirm => 'Confirm Payment';

  @override
  String get patientPaymentStripeDisabledSnack => 'Stripe is disabled in this build. Re-enable flutter_stripe in pubspec and restore _confirmPayment below.';

  @override
  String patientPaymentError(String message) {
    return 'Payment error: $message';
  }

  @override
  String get patientMoreProfileTitle => 'Profile';

  @override
  String get patientMoreProfileSubtitle => 'View and edit your information';

  @override
  String get patientPaymentsTabEmpty => 'Payment history and receipts will appear here when available.';

  @override
  String get patientReviewSetRatingFirstSnack => 'Please set your overall rating first.';

  @override
  String get patientReviewOverallRating => 'Overall Rating';

  @override
  String get patientReviewTapToRate => 'Tap to rate';

  @override
  String get patientReviewRateSpecificAreas => 'Rate Specific Areas';

  @override
  String get patientReviewProfessionalism => 'Professionalism';

  @override
  String get patientReviewPunctuality => 'Punctuality';

  @override
  String get patientReviewCommunication => 'Communication';

  @override
  String get patientReviewServiceQuality => 'Service Quality';

  @override
  String get patientReviewTextOptional => 'Review Text (Optional)';

  @override
  String get patientReviewTextHint => 'Share details about your experience...';

  @override
  String get patientReviewLater => 'Later';

  @override
  String get patientReviewSubmit => 'Submit Review';

  @override
  String get patientReviewServiceShort => 'Service';

  @override
  String patientReviewServiceLine(String name) {
    return 'Service: $name';
  }

  @override
  String get patientReviewNurseShort => 'Nurse';

  @override
  String patientReviewNurseLine(String name) {
    return 'Nurse: $name';
  }

  @override
  String get patientReviewCloseTooltip => 'Close';

  @override
  String get profileTitle => 'Profile';

  @override
  String get personalInfo => 'Personal info';

  @override
  String get profileAddressSection => 'Address';

  @override
  String get profileMedicalSection => 'Medical info';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get gender => 'Gender';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get bloodType => 'Blood type';

  @override
  String get address => 'Address';

  @override
  String get governorate => 'Governorate';

  @override
  String get area => 'Area';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileSave => 'Save';

  @override
  String get profileSelectGender => 'Select gender';

  @override
  String get profileSelectBloodType => 'Select blood type';

  @override
  String get profileSelectGovernorate => 'Select governorate';

  @override
  String get profileSelectDate => 'Select date';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully.';

  @override
  String get profileConditions => 'Conditions';

  @override
  String get profileAllergies => 'Allergies';

  @override
  String get profileNotes => 'Notes';

  @override
  String get profileNoneCombinationWarning => 'None cannot be combined with other conditions.';

  @override
  String get profileOtherConditionOptional => 'Other condition (optional)';

  @override
  String get profileConditionHint => 'e.g. Cancer, Kidney disease';

  @override
  String get profileOtherAllergiesOptional => 'Other allergies (optional)';

  @override
  String get profileAllergiesHint => 'e.g. Seafood, Aspirin';

  @override
  String get profileConditionDiabetes => 'Diabetes';

  @override
  String get profileConditionHypertension => 'Hypertension';

  @override
  String get profileConditionAsthma => 'Asthma';

  @override
  String get profileConditionHeartDisease => 'Heart disease';

  @override
  String get profileConditionArthritis => 'Arthritis';

  @override
  String get profileConditionNone => 'None';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderFemale => 'Female';

  @override
  String get profileAllergyPenicillin => 'Penicillin';

  @override
  String get profileAllergyDust => 'Dust';

  @override
  String get profileAllergyFood => 'Food';

  @override
  String get profileAllergyLatex => 'Latex';

  @override
  String get profileAllergyPollen => 'Pollen';

  @override
  String get notLoggedIn => 'Please log in first';

  @override
  String get patientMoreLanguage => 'Language';

  @override
  String get patientMoreLanguageEnglish => 'English';

  @override
  String get patientMoreLanguageArabic => 'Arabic';

  @override
  String get languageSelectorTitle => 'Choose language';

  @override
  String get languageSelectorSubtitle => 'Change app language';

  @override
  String get nurseHomeWelcomeBack => 'Welcome back,';

  @override
  String get nurseHomeDefaultName => 'Nurse';

  @override
  String get nurseHomeSummaryTodayAppointments => 'Today\'s Appointments';

  @override
  String get nurseHomeSummaryPendingRequests => 'Pending Requests';

  @override
  String get nurseHomeSummaryJodToday => 'JOD Today';

  @override
  String get nurseHomeWeekSummaryTitle => 'This Week Summary';

  @override
  String get nurseHomeWeekCompleted => 'Completed';

  @override
  String get nurseHomeWeekCancelled => 'Cancelled';

  @override
  String get nurseHomeWeekJodEarned => 'JOD Earned';

  @override
  String get nurseHomeQuickActionsTitle => 'Quick Actions';

  @override
  String get nurseHomeActionManageAvailabilityTitle => 'Manage Availability';

  @override
  String get nurseHomeActionManageAvailabilitySubtitle => 'Set your working hours';

  @override
  String get nurseHomeActionViewRequestsTitle => 'View Requests';

  @override
  String get nurseHomeActionViewRequestsSubtitle => 'Pending and rejected requests';

  @override
  String get nurseHomeActionAppointmentsTitle => 'Appointments';

  @override
  String get nurseHomeActionAppointmentsSubtitle => 'View your appointments';

  @override
  String get nurseHomeTodayScheduleTitle => 'Today\'s Schedule';

  @override
  String get nurseHomeViewAll => 'View All';

  @override
  String get nurseStatusAccepted => 'Accepted';

  @override
  String get nurseStatusActive => 'Active';

  @override
  String get nurseStatusCompleted => 'Completed';

  @override
  String get nurseStatusCancelled => 'Cancelled';

  @override
  String get nurseStatusRejected => 'Rejected';

  @override
  String get nurseStatusPending => 'Pending';

  @override
  String get nurseHomePatientFallback => 'Patient';

  @override
  String nurseHomeEarningsJod(String amount) {
    return '$amount JOD';
  }

  @override
  String get nurseHomeNoAppointmentsToday => 'No appointments for today';

  @override
  String get nurseHomeNoAppointmentsTodayHint => 'Today appointments will appear here.';

  @override
  String get nurseHomeAvailableTitle => 'You\'re Available';

  @override
  String get nurseHomeAvailableSubtitle => 'You can receive new service requests';

  @override
  String get nurseNavHome => 'Home';

  @override
  String get nurseNavAvailability => 'Availability';

  @override
  String get nurseNavAppointments => 'Appointments';

  @override
  String get nurseNavRequests => 'Requests';

  @override
  String get nurseNavProfile => 'Profile';

  @override
  String get nurseRequestsTitle => 'Service Requests';

  @override
  String nurseRequestsPendingCountSubtitle(int count) {
    return '$count pending requests';
  }

  @override
  String nurseRequestsRejectedCountSubtitle(int count) {
    return '$count rejected requests';
  }

  @override
  String nurseRequestsTabPending(int count) {
    return 'Pending ($count)';
  }

  @override
  String nurseRequestsTabRejected(int count) {
    return 'Rejected ($count)';
  }

  @override
  String get nurseRequestsEmptyPendingTitle => 'No pending requests';

  @override
  String get nurseRequestsEmptyPendingSubtitle => 'New service requests will appear here.';

  @override
  String get nurseRequestsEmptyRejectedTitle => 'No rejected requests';

  @override
  String get nurseRequestsEmptyRejectedSubtitle => 'Rejected requests will appear here for reference.';

  @override
  String get nurseRequestsLoadErrorTitle => 'Failed to load requests';

  @override
  String get nurseRequestsLoadErrorSubtitle => 'Please check your connection and try again.';

  @override
  String get nurseRetry => 'Retry';

  @override
  String get nurseRequestsRejectDialogTitle => 'Reject Request';

  @override
  String get nurseRequestsRejectDialogMessage => 'Are you sure you want to reject this request?';

  @override
  String get nurseDialogNo => 'No';

  @override
  String get nurseReject => 'Reject';

  @override
  String get nurseAccept => 'Accept';

  @override
  String get nurseRequestsAcceptedSuccess => 'Request accepted successfully.';

  @override
  String get nurseRequestsRejectedSuccess => 'Request rejected successfully.';

  @override
  String nurseRequestsDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get nurseAvailEmbeddedTitle => 'Availability';

  @override
  String get nurseAvailManageTitle => 'Manage Availability';

  @override
  String get nurseAvailTapDateHint => 'Your weekly schedule repeats every week. Tap any date to block it or set custom hours for that day.';

  @override
  String get nurseAvailLegendWorking => 'Working';

  @override
  String get nurseAvailLegendCustomHours => 'Custom hours';

  @override
  String get nurseAvailLegendBlocked => 'Blocked';

  @override
  String get nurseAvailWeeklySchedule => 'Weekly Schedule';

  @override
  String get nurseAvailAddTimeSlot => 'Add Time Slot';

  @override
  String get nurseAvailNoScheduleYet => 'No schedule set yet';

  @override
  String get nurseAvailNoScheduleHint => 'Tap \"Add Time Slot\" to set your working hours';

  @override
  String get nurseAvailSave => 'Save Availability';

  @override
  String get nurseAvailSaveAutoMessage => 'Changes are saved automatically after each action';

  @override
  String get nurseAvailTimeSlotAdded => 'Time slot added successfully';

  @override
  String get nurseAvailDayBlocked => 'Day blocked successfully';

  @override
  String get nurseAvailDayUnblocked => 'Day unblocked successfully';

  @override
  String nurseAvailOverrideSuccess(String start, String end) {
    return 'Working hours overridden: $start - $end';
  }

  @override
  String get nurseAvailSlotDeleted => 'Slot deleted successfully';

  @override
  String get nurseAvailSlotStatusUpdated => 'Slot status updated';

  @override
  String get nurseAvailManageDayTitle => 'Manage Day';

  @override
  String get nurseAvailWorkingHours => 'Working Hours';

  @override
  String get nurseAvailNoHoursThisDay => 'No scheduled hours for this day';

  @override
  String get nurseAvailFromWeeklySchedule => 'From your weekly schedule';

  @override
  String get nurseAvailDayBlockedShort => 'This day is blocked';

  @override
  String get nurseAvailCustomOverrideApplied => 'Custom override applied';

  @override
  String get nurseAvailOverrideHoursTitle => 'Override Working Hours';

  @override
  String get nurseAvailOverrideHoursSubtitle => 'Set custom hours for this date only';

  @override
  String get nurseAvailBlockDayTitle => 'Block This Day';

  @override
  String get nurseAvailUnblockDayTitle => 'Unblock This Day';

  @override
  String get nurseAvailUnblockDaySubtitle => 'Make this day available again';

  @override
  String get nurseAvailBlockDaySubtitle => 'Mark as unavailable (vacation, day off)';

  @override
  String nurseAvailOverrideHoursForDate(String date) {
    return 'Set custom hours for $date';
  }

  @override
  String get nurseAvailStartTime => 'Start Time';

  @override
  String get nurseAvailEndTime => 'End Time';

  @override
  String get nurseAvailCancel => 'Cancel';

  @override
  String get nurseAvailSaveOverride => 'Save Override';

  @override
  String get nurseAvailBlockConfirmTitle => 'Block this day?';

  @override
  String get nurseAvailBlockConfirmMessage => 'Patients will not be able to book appointments on this day.';

  @override
  String get nurseAvailBlockDay => 'Block Day';

  @override
  String get nurseAvailQuickSettingsTitle => 'Quick Settings';

  @override
  String get nurseAvailQuickCopyWeekdays => 'Copy to All Weekdays';

  @override
  String get nurseAvailQuickCopyWeekdaysSubtitle => 'Apply Monday schedule to Tue–Fri';

  @override
  String get nurseAvailQuickWeekend => 'Set Weekend Availability';

  @override
  String get nurseAvailQuickWeekendSubtitle => 'Configure Saturday & Sunday hours';

  @override
  String get nurseAvailQuickBlockDays => 'Block Specific Days';

  @override
  String get nurseAvailQuickBlockDaysSubtitle => 'Mark days when you\'re unavailable';

  @override
  String get nurseAvailQuickPlaceholder => 'Quick settings are UI-only for now';

  @override
  String get nurseAvailQuickBlockHint => 'Use the calendar to block specific days';

  @override
  String get nurseAvailAddWorkingHoursTitle => 'Add Working Hours';

  @override
  String get nurseAvailAddWorkingHoursSubtitle => 'Set your weekly schedule';

  @override
  String get nurseAvailSelectDay => 'Select Day';

  @override
  String get nurseAvailSummary => 'Summary';

  @override
  String get nurseAvailSummaryDay => 'Day';

  @override
  String get nurseAvailSummaryHours => 'Hours';

  @override
  String get nurseAvailSummaryDuration => 'Duration';

  @override
  String get nurseAvailBookingNote => 'Note: The system will automatically generate available booking slots based on your working hours and service durations.';

  @override
  String get nurseAvailAddButton => 'Add Working Hours';

  @override
  String get nurseAvailInvalidTimeRange => 'Invalid range';

  @override
  String get nurseAvailEndAfterStart => 'End time must be after start time';

  @override
  String get nurseAvailWeekdayMonday => 'Monday';

  @override
  String get nurseAvailWeekdayTuesday => 'Tuesday';

  @override
  String get nurseAvailWeekdayWednesday => 'Wednesday';

  @override
  String get nurseAvailWeekdayThursday => 'Thursday';

  @override
  String get nurseAvailWeekdayFriday => 'Friday';

  @override
  String get nurseAvailWeekdaySaturday => 'Saturday';

  @override
  String get nurseAvailWeekdaySunday => 'Sunday';

  @override
  String nurseAvailSlotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slots',
      one: '1 slot',
    );
    return '$_temp0';
  }

  @override
  String get nurseAvailDeactivateSlot => 'Deactivate slot';

  @override
  String get nurseAvailActivateSlot => 'Activate slot';

  @override
  String get nurseAvailDelete => 'Delete';

  @override
  String get nurseAppointmentsTitle => 'My Appointments';

  @override
  String nurseAppointmentsTabToday(int count) {
    return 'Today ($count)';
  }

  @override
  String nurseAppointmentsTabUpcoming(int count) {
    return 'Upcoming ($count)';
  }

  @override
  String nurseAppointmentsTabPast(int count) {
    return 'Past ($count)';
  }

  @override
  String get nurseAppointmentsEmpty => 'No appointments right now';

  @override
  String get nurseAppointmentsErrorGeneric => 'Something went wrong.';

  @override
  String get nurseLoginRequiredShort => 'Please log in';

  @override
  String get nurseProfileTitle => 'Profile';

  @override
  String get nurseProfileSubtitle => 'Account & preferences';

  @override
  String get nurseProfilePersonalInfoTitle => 'Personal Info';

  @override
  String get nurseProfilePersonalInfoSubtitle => 'Profile, services & professional details';

  @override
  String get nurseProfileMyServicesTitle => 'My Services';

  @override
  String get nurseProfileMyServicesSubtitle => 'Add or edit your offered services';

  @override
  String get nurseProfileRatingsTitle => 'Ratings';

  @override
  String get nurseProfileRatingsSubtitle => 'Reviews from patients';

  @override
  String get nurseProfileEarningsTitle => 'Earnings';

  @override
  String get nurseProfileEarningsSubtitle => 'Payouts and transaction history';

  @override
  String get nurseProfileLogoutTitle => 'Logout';

  @override
  String get nurseProfileLogoutSubtitle => 'Sign out of this device';

  @override
  String get nurseProfileLogoutDialogTitle => 'Log out?';

  @override
  String get nurseProfileLogoutDialogMessage => 'You will need to sign in again to access your account.';

  @override
  String nurseProfileLogoutFailed(String error) {
    return 'Logout failed: $error';
  }

  @override
  String nursePersonalLoadFailed(String error) {
    return 'Failed to load profile: $error';
  }

  @override
  String get nursePersonalExperienceInvalid => 'Experience must be a valid number';

  @override
  String get nursePersonalUpdatedSuccess => 'Profile updated successfully';

  @override
  String nursePersonalUpdateFailed(String error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get nursePersonalHeaderTitle => 'Personal Info';

  @override
  String get nursePersonalHeaderSubtitle => 'Manage your professional information';

  @override
  String get nursePersonalSectionPersonal => 'Personal Information';

  @override
  String get nursePersonalSectionProfessional => 'Professional Details';

  @override
  String get nursePersonalSaveChanges => 'Save Changes';

  @override
  String get nursePersonalFullName => 'Full Name';

  @override
  String get nursePersonalEmail => 'Email';

  @override
  String get nursePersonalPhone => 'Phone Number';

  @override
  String get nursePersonalLocation => 'Location';

  @override
  String get nursePersonalAddress => 'Address';

  @override
  String get nursePersonalNationalId => 'National ID';

  @override
  String get nursePersonalBio => 'Bio';

  @override
  String get nursePersonalLicenseNumber => 'License Number';

  @override
  String get nursePersonalSpecialization => 'Specialization';

  @override
  String get nursePersonalExperience => 'Experience';

  @override
  String get nursePersonalServicesOffered => 'Services Offered';

  @override
  String get nursePersonalNoServicesFound => 'No services found.';

  @override
  String get nurseServiceAddTitle => 'Add Service';

  @override
  String get nurseServiceAddSubtitle => 'Add a service you provide';

  @override
  String get nurseServiceEditTitle => 'Edit Service';

  @override
  String get nurseServiceEditSubtitle => 'Update your service pricing';

  @override
  String get nurseServiceSelectRequired => 'Please select a service';

  @override
  String get nurseServicePriceInvalid => 'Please enter a valid price';

  @override
  String get nurseServiceAddedSuccess => 'Service added successfully';

  @override
  String get nurseServiceUpdatedSuccess => 'Service updated successfully';

  @override
  String get nurseServiceDeletedSuccess => 'Service deleted successfully';

  @override
  String get nurseServiceSelectLabel => 'Select Service *';

  @override
  String get nurseServiceDurationLabel => 'Service Duration';

  @override
  String get nurseServicePriceLabel => 'Your Price *';

  @override
  String get nurseServicePriceHint => 'Enter your price';

  @override
  String get nurseServicePriceHelp => 'Set your price for this service';

  @override
  String get nurseServiceChooseHint => 'Choose a service...';

  @override
  String get nurseServiceSelectFirst => 'Select a service first';

  @override
  String get nurseServiceFixedDuration => '(Fixed duration)';

  @override
  String nurseServiceMinutes(int count) {
    return '$count minutes';
  }

  @override
  String get nurseServiceCurrencyJod => 'JOD';

  @override
  String get nurseServiceAddButton => 'Add Service';

  @override
  String get nurseServiceUpdateButton => 'Update Service';

  @override
  String get nurseServiceDeleteTitle => 'Delete Service';

  @override
  String get nurseServiceDeleteConfirm => 'Are you sure you want to delete this service?';

  @override
  String get nurseServiceNoteTitle => 'Note:';

  @override
  String get nurseServiceAddNoteBody => 'Service duration comes from the backend catalog. You only choose the service and enter your price.';

  @override
  String get nurseServiceEditNoteBody => 'Service duration comes from the backend catalog. You can update the selected service and price only.';

  @override
  String nurseServiceSummaryService(String name) {
    return 'Service: $name';
  }

  @override
  String nurseServiceSummaryDuration(String value) {
    return 'Duration: $value';
  }

  @override
  String get nurseServiceSummaryPriceLabel => 'Your Price:';

  @override
  String nurseServiceSummaryPriceValue(String price) {
    return '$price JOD';
  }

  @override
  String nurseRatingsBasedOn(int count) {
    return 'Based on $count reviews';
  }

  @override
  String get nurseRatingsRecentReviews => 'Recent reviews';

  @override
  String get nurseRatingsMockName1 => 'Ahmad M.';

  @override
  String get nurseRatingsMockComment1 => 'Very professional and punctual. Highly recommend.';

  @override
  String get nurseRatingsMockName2 => 'Rania K.';

  @override
  String get nurseRatingsMockComment2 => 'Excellent wound care. Clear explanations.';

  @override
  String get nurseRatingsMockName3 => 'Sara Al-Masri';

  @override
  String get nurseRatingsMockComment3 => 'Great visit; would book again.';

  @override
  String get nurseEarningsPlaceholderTitle => 'Earnings';

  @override
  String get nurseEarningsPlaceholderBody => 'Detailed earnings and payout history will appear here once connected to your backend.';

  @override
  String get nurseRegTitle => 'Nurse Registration';

  @override
  String get nurseRegPhoneLabel => 'Phone Number';

  @override
  String get nurseRegPhoneHint => 'e.g. 079XXXXXXX';

  @override
  String get nurseRegNationalIdLabel => 'National ID Number';

  @override
  String get nurseRegNationalIdHint => 'Enter your national ID';

  @override
  String get nurseRegLicenseLabel => 'License Number';

  @override
  String get nurseRegLicenseHint => 'Enter your nursing license number';

  @override
  String get nurseRegGovernorateLabel => 'Governorate';

  @override
  String get nurseRegGovernorateSelect => 'Select governorate';

  @override
  String get nurseRegAreaLabel => 'Area / Neighborhood';

  @override
  String get nurseRegAreaHint => 'e.g. Abdoun, Jabal Amman';

  @override
  String get nurseRegSpecializationLabel => 'Specialization';

  @override
  String get nurseRegSpecializationHint => 'e.g. ICU, Elderly Care';

  @override
  String get nurseRegExperienceLabel => 'Experience Years';

  @override
  String get nurseRegExperienceHint => 'e.g. 5';

  @override
  String get nurseRegBioLabel => 'Bio';

  @override
  String get nurseRegBioHint => 'Write a short bio about your experience';

  @override
  String get nurseRegUploadNationalIdTitle => 'Upload National ID Image';

  @override
  String get nurseRegUploadLicenseTitle => 'Upload Nursing License PDF';

  @override
  String get nurseRegUploadProfileTitle => 'Upload Profile Photo';

  @override
  String get nurseRegUploadImageHint => 'JPG / JPEG / PNG';

  @override
  String get nurseRegUploadPdfHint => 'PDF only';

  @override
  String get nurseRegConfirmAccuracy => 'I confirm all information is accurate';

  @override
  String get nurseRegSubmit => 'Submit Registration';

  @override
  String get nurseRegRequiredField => 'Required field';

  @override
  String get nurseRegSelectGovernorateError => 'Please select governorate';

  @override
  String get nurseRegConfirmInfoError => 'Please confirm the information';

  @override
  String get nurseRegExperienceInvalid => 'Experience years must be a valid number';

  @override
  String get nurseRegUploadNationalIdError => 'Please upload national ID image';

  @override
  String get nurseRegUploadLicenseError => 'Please upload nursing license PDF';

  @override
  String get nurseRegUploadProfilePhotoError => 'Please upload profile photo';

  @override
  String get nurseRegSubmittedSuccess => 'Registration submitted successfully';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsNurseTitle => 'Nurse Notifications';

  @override
  String get notificationsLoadFailed => 'Failed to load notifications';

  @override
  String get notificationsMarkOneFailed => 'Failed to mark notification as read';

  @override
  String get notificationsMarkAllFailed => 'Failed to mark all notifications as read';

  @override
  String get notificationsNoLinkedScreen => 'No screen linked to this notification';

  @override
  String get notificationsNoBookingLinked => 'No booking linked';

  @override
  String get notificationsOpenDetailsFailed => 'Failed to open appointment details';

  @override
  String notificationsUnhandledTarget(String target) {
    return 'Unhandled target screen: $target';
  }

  @override
  String get notificationsReadAll => 'Read all';

  @override
  String notificationsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread notifications',
      one: '1 unread notification',
    );
    return '$_temp0';
  }

  @override
  String get notificationsAllRead => 'All notifications are read';

  @override
  String get notificationsEmpty => 'No notifications yet.';

  @override
  String get notificationsJustNow => 'Just now';

  @override
  String notificationsMinAgo(int count) {
    return '$count min ago';
  }

  @override
  String notificationsHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String notificationsDaysAgo(int count) {
    return '$count d ago';
  }

  @override
  String get notificationsMarkAsRead => 'Mark as read';

  @override
  String get nurseAppointmentDetailsTitle => 'Appointment Details';

  @override
  String get nurseAppointmentWaitingBanner => 'Waiting for Payment\nYou confirmed this appointment. The patient needs to complete payment to activate it.';

  @override
  String get nurseAppointmentStatusLabel => 'Status';

  @override
  String get nurseAppointmentPatientInformation => 'Patient Information';

  @override
  String get nurseAppointmentCallPatient => 'Call Patient';

  @override
  String get nurseAppointmentWhatsAppPatient => 'Message on WhatsApp';

  @override
  String get nurseAppointmentDetailsSectionTitle => 'Appointment Details';

  @override
  String get nurseAppointmentDateLabel => 'Date';

  @override
  String get nurseAppointmentTimeDurationLabel => 'Time & Duration';

  @override
  String get nurseAppointmentServiceLocationLabel => 'Service Location';

  @override
  String get nurseAppointmentYourEarnings => 'Your Earnings';

  @override
  String get nurseAppointmentPaymentStatusLabel => 'Payment Status';

  @override
  String get nurseAppointmentMarkCompleted => 'Mark as completed';

  @override
  String get nurseAppointmentCancelTitle => 'Cancel Appointment';

  @override
  String get nurseAppointmentCancelConfirmMessage => 'Are you sure you want to cancel this appointment?';

  @override
  String get nurseAppointmentCompleteConfirmMessage => 'Are you sure you want to mark this appointment as completed?';

  @override
  String get nurseAppointmentCancelledSuccess => 'Appointment cancelled successfully.';

  @override
  String get nurseAppointmentCompletedSuccess => 'Appointment marked as completed.';

  @override
  String get nurseAppointmentStatusWaitingPayment => 'Waiting for Payment';

  @override
  String get nurseAppointmentStatusActivePaid => 'Active / Paid';

  @override
  String get nurseAppointmentPaymentPaid => 'Paid';

  @override
  String get nurseAppointmentPaymentUnpaid => 'Unpaid';

  @override
  String get nurseAppointmentPaymentNotApplicable => 'N/A';

  @override
  String get nurseAppointmentServiceFallback => 'Service';

  @override
  String get nurseAppointmentPaymentPendingBannerBody => 'Patient hasn\'t paid yet — you can contact or cancel.';

  @override
  String get patientAppointmentDetailsTitle => 'Appointment Details';

  @override
  String get patientAppointmentNurseInformation => 'Nurse Information';

  @override
  String get patientAppointmentCall => 'Call';

  @override
  String get patientAppointmentWhatsApp => 'WhatsApp';

  @override
  String get patientAppointmentDate => 'Date';

  @override
  String get patientAppointmentTimeDuration => 'Time & Duration';

  @override
  String get patientAppointmentAddress => 'Address';

  @override
  String get patientAppointmentTotalCost => 'Total Cost';

  @override
  String get patientAppointmentPaymentStatus => 'Payment Status';

  @override
  String get patientAppointmentPayNow => 'Pay now';

  @override
  String get patientAppointmentNoActions => 'No actions available for this appointment.';

  @override
  String get patientAppointmentCancelling => 'Cancelling...';

  @override
  String get patientAppointmentCancelButton => 'Cancel Appointment';

  @override
  String get patientAppointmentLoadFailed => 'Failed to load appointment details';

  @override
  String get patientAppointmentPayToContinueTitle => 'Pay to continue';

  @override
  String get patientAppointmentPayToContinueBody => 'Your nurse confirmed this appointment. Please complete payment to activate it and keep your booking.';

  @override
  String get patientAppointmentStatusLabel => 'Status';

  @override
  String get patientAppointmentPhoneUnavailable => 'Phone number is not available.';

  @override
  String get patientAppointmentDialerOpenFailed => 'Could not open dialer.';

  @override
  String get patientAppointmentWhatsAppOpenFailed => 'Could not open WhatsApp.';

  @override
  String get patientAppointmentCancelTitle => 'Cancel appointment';

  @override
  String get patientAppointmentCancelConfirm => 'Are you sure you want to cancel this appointment?';

  @override
  String get patientAppointmentCancelConfirmAction => 'Yes, cancel';

  @override
  String get patientAppointmentCancelledSuccess => 'Appointment cancelled successfully.';

  @override
  String patientAppointmentHours(int count) {
    return '$count hr';
  }

  @override
  String patientAppointmentMinutes(int count) {
    return '$count min';
  }

  @override
  String get patientAppointmentPaymentAwaitingNurse => 'AWAITING NURSE';

  @override
  String get patientAppointmentPaymentUnpaid => 'UNPAID';

  @override
  String get patientAppointmentPaymentPaid => 'PAID';

  @override
  String get patientAppointmentPaymentCancelled => 'CANCELLED';

  @override
  String get patientAppointmentPaymentRejected => 'REJECTED';

  @override
  String get patientNurseProfileAboutTab => 'About';

  @override
  String patientNurseProfileReviewsTab(int count) {
    return 'Reviews ($count)';
  }

  @override
  String get patientNurseProfileLocation => 'Location';

  @override
  String get patientNurseProfileAvailability => 'Availability';

  @override
  String get patientNurseProfileServicesOffered => 'Services Offered';

  @override
  String get patientNurseProfileNoServicesTitle => 'This nurse has no available services yet.';

  @override
  String get patientNurseProfileNoServicesSubtitle => 'You cannot book a service at the moment.';

  @override
  String get patientNurseProfileReviews => 'Reviews';

  @override
  String get patientNurseProfileReviewsPlaceholder => 'Reviews will appear after backend review endpoints are available.';

  @override
  String get patientNurseProfileBookServiceRequest => 'Book Service Request';

  @override
  String get patientNurseProfileNoServicesAvailable => 'No Services Available';

  @override
  String get patientRequestServiceTitle => 'Service Request';

  @override
  String get patientRequestStepServiceDetails => 'Service Details';

  @override
  String get patientRequestStepReviewConfirm => 'Review & Confirm';

  @override
  String get patientRequestRequiredFields => 'Please complete all required fields.';

  @override
  String get patientRequestSelectServiceType => 'Select Service Type';

  @override
  String get patientRequestNoServicesForNurse => 'No services available for this nurse.';

  @override
  String get patientRequestSelectDate => 'Select Date';

  @override
  String get patientRequestNoAvailableDates => 'No available dates found.';

  @override
  String get patientRequestSelectTimeSlot => 'Select Available Time Slot';

  @override
  String get patientRequestSelectServiceDateFirst => 'Select a service and date to view available time slots.';

  @override
  String get patientRequestNoAvailableTimeSlots => 'No available time slots for this date.';

  @override
  String get patientRequestServiceAddress => 'Service Address';

  @override
  String get patientRequestAddressHint => 'Enter your complete address';

  @override
  String get patientRequestAdditionalNotesOptional => 'Additional Notes (Optional)';

  @override
  String get patientRequestNotesHint => 'Any special instructions or medical information...';

  @override
  String get patientRequestReviewAndConfirm => 'Review and Confirm';

  @override
  String get patientRequestReviewYourRequest => 'Review Your Request';

  @override
  String get patientRequestServiceType => 'Service Type';

  @override
  String get patientRequestDuration => 'Duration';

  @override
  String get patientRequestTime => 'Time';

  @override
  String get patientRequestNotes => 'Notes';

  @override
  String get patientRequestServiceCost => 'Service Cost';

  @override
  String get patientRequestService => 'Service';

  @override
  String get patientRequestTotalPrice => 'Total Price';

  @override
  String get patientRequestSubmitRequest => 'Submit Request';

  @override
  String get patientRequestSubmittedTitle => 'Request Submitted!';

  @override
  String patientRequestSubmittedBody(String name) {
    return 'Your service request has been sent to\n$name. You will receive a\nnotification once the nurse responds.';
  }

  @override
  String get patientRequestSummary => 'Request Summary';

  @override
  String get patientRequestNurseLabel => 'Nurse:';

  @override
  String get patientRequestServiceLabel => 'Service:';

  @override
  String get patientRequestDurationLabel => 'Duration:';

  @override
  String get patientRequestDateLabel => 'Date:';

  @override
  String get patientRequestTimeLabel => 'Time:';

  @override
  String get patientRequestTotalPriceLabel => 'Total Price:';

  @override
  String get patientRequestBackToNurses => 'Back to Nurses';

  @override
  String get statusBannerNursePending => 'This booking is waiting for your response.';

  @override
  String get statusBannerPatientPending => 'Your request is pending confirmation.';

  @override
  String get statusBannerConfirmed => 'Appointment confirmed. See you at the scheduled time.';

  @override
  String get statusBannerNurseWaitingPayment => 'Payment is pending from the patient.';

  @override
  String get statusBannerPatientWaitingPayment => 'Please complete payment to finalize this appointment.';

  @override
  String get statusBannerPaid => 'Payment received. Appointment is active.';

  @override
  String get statusBannerCompleted => 'This appointment has been completed.';

  @override
  String get statusBannerCancelled => 'This appointment was cancelled.';

  @override
  String get statusBannerRejected => 'This request was not accepted.';

  @override
  String get paymentSuccessTitle => 'Payment Successful';

  @override
  String paymentSuccessAmountPaid(String amount) {
    return 'Amount paid: $amount';
  }

  @override
  String get paymentBackToAppointments => 'Back to Appointments';

  @override
  String get paymentFailedTitle => 'Payment Failed';

  @override
  String get paymentFailedBody => 'We could not process your payment. Please try again.';

  @override
  String get paymentRetryButton => 'Retry Payment';

  @override
  String get forgotTitle => 'Forgot Password';

  @override
  String get forgotEnterEmail => 'Please enter your email';

  @override
  String get forgotEnterValidEmail => 'Please enter a valid email';

  @override
  String get forgotServerTimeoutMessage => 'The server took too long to respond. Check backend/email settings and try again.';

  @override
  String get forgotResetPasswordTitle => 'Reset your password';

  @override
  String get forgotResetPasswordSubtitle => 'Enter your email and we will send you a link to reset your password.';

  @override
  String get forgotResetLinkHint => 'We will send a reset link to your email.';

  @override
  String get forgotSendResetLink => 'Send Reset Link';

  @override
  String get nurseResubmitTitle => 'Resubmit Verification';

  @override
  String get nurseResubmitNoFileSelected => 'No file selected';

  @override
  String get nurseResubmitExperienceInvalid => 'Experience years must be a valid number';

  @override
  String get nurseResubmitSubmittedSuccess => 'Resubmitted successfully. Waiting for admin approval.';

  @override
  String nurseResubmitSubmitFailed(String error) {
    return 'Submit failed: $error';
  }

  @override
  String get nurseResubmitUpdateDetailsTitle => 'Update your details';

  @override
  String get nurseResubmitUpdateDetailsSubtitle => 'Fix the requested items and resubmit your information.\nAfter submitting, your status will return to Pending.';

  @override
  String get nurseResubmitPhoneRequired => 'Phone is required';

  @override
  String get nurseResubmitPhoneInvalid => 'Enter a valid phone number';

  @override
  String get nurseResubmitAddressRequired => 'Address is required';

  @override
  String get nurseResubmitLocationHint => 'City / Location (e.g., Amman)';

  @override
  String get nurseResubmitLocationRequired => 'Location is required';

  @override
  String get nurseResubmitNationalIdRequired => 'National ID is required';

  @override
  String get nurseResubmitNationalIdInvalid => 'Enter a valid National ID';

  @override
  String get nurseResubmitLicenseRequired => 'License number is required';

  @override
  String get nurseResubmitSpecializationRequired => 'Specialization is required';

  @override
  String get nurseResubmitExperienceRequired => 'Experience years is required';

  @override
  String get nurseResubmitEnterValidNumber => 'Enter a valid number';

  @override
  String get nurseResubmitDocumentsTitle => 'Documents';

  @override
  String get nurseResubmitDocumentsSubtitle => 'Upload the requested updated files.';

  @override
  String get nurseResubmitNationalIdTitle => 'National ID';

  @override
  String get nurseResubmitNationalIdHint => 'Upload your National ID (image/PDF)';

  @override
  String get nurseResubmitLicenseTitle => 'Nursing License';

  @override
  String get nurseResubmitLicenseHint => 'Upload your license (image/PDF)';

  @override
  String get nurseResubmitProfilePhotoTitle => 'Profile Photo';

  @override
  String get nurseResubmitProfilePhotoHint => 'Upload a profile photo (image)';

  @override
  String get nurseResubmitChoose => 'Choose';

  @override
  String get nurseResubmitSubmitForReview => 'Submit for Review';

  @override
  String nurseAvailDurationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String patientOnboardStepOfFour(int step) {
    return 'Step $step of 4';
  }

  @override
  String get patientOnboardSkipForNow => 'Skip for now';

  @override
  String get patientOnboardNext => 'Next';

  @override
  String get patientOnboardGetStarted => 'Get started';

  @override
  String get patientOnboardPersonalTitle => 'Personal info';

  @override
  String get patientOnboardPersonalSubtitle => 'Optional — you can skip and complete this later.';

  @override
  String get patientOnboardSelectGender => 'Select gender';

  @override
  String get patientOnboardSelectDate => 'Select date';

  @override
  String get patientOnboardSelectBloodType => 'Select blood type';

  @override
  String get patientOnboardAddressTitle => 'Address';

  @override
  String get patientOnboardAddressSubtitle => 'Optional — helps nurses find you faster.';

  @override
  String get patientOnboardAreaHint => 'e.g. Abdoun, Jubeiha';

  @override
  String get patientOnboardStreetLabel => 'Street / building details';

  @override
  String get patientOnboardStreetHint => 'Apartment, building, landmarks';

  @override
  String get patientOnboardMedicalTitle => 'Medical info';

  @override
  String get patientOnboardMedicalSubtitle => 'Optional — share only what you are comfortable with.';

  @override
  String get patientOnboardConditionsSection => 'Conditions';

  @override
  String get patientOnboardConditionsHint => 'Select any that apply. None cannot be combined with other conditions.';

  @override
  String get patientOnboardOtherConditionLabel => 'Other condition (optional)';

  @override
  String get patientOnboardOtherConditionHint => 'e.g. Cancer, Kidney disease';

  @override
  String get patientOnboardAllergiesSection => 'Allergies';

  @override
  String get patientOnboardAllergiesHint => 'Tap common allergies or add your own below.';

  @override
  String get patientOnboardOtherAllergiesLabel => 'Other allergies (optional)';

  @override
  String get patientOnboardOtherAllergiesHint => 'e.g. Sulfa, nuts, seafood';

  @override
  String get patientOnboardNotes => 'Notes';

  @override
  String get patientOnboardNotesHint => 'Anything else your care team should know...';

  @override
  String get paymentBillingTitle => 'Payments & Billing';

  @override
  String get paymentTotalSpent => 'Total Spent';

  @override
  String get paymentPendingLabel => 'Pending';

  @override
  String get paymentTransactionHistoryTitle => 'Transaction History';

  @override
  String get paymentTransactionHistorySubtitle => 'View all payments';

  @override
  String get paymentMethodsTitle => 'Payment Methods';

  @override
  String get paymentMethodsSubtitle => 'Manage your cards';

  @override
  String get paymentRecentTransactions => 'Recent Transactions';

  @override
  String get paymentViewAll => 'View All';

  @override
  String get paymentStatusCompleted => 'Completed';

  @override
  String get paymentStatusPending => 'Pending';

  @override
  String get paymentPrimaryLabel => 'Primary';

  @override
  String get paymentAddNewMethod => 'Add New Payment Method';

  @override
  String get paymentSupportedMethods => 'Supported Payment Methods';

  @override
  String get paymentCreditDebitCards => 'Credit/Debit Cards';

  @override
  String get paymentCashComingSoon => 'Cash (Coming Soon)';

  @override
  String get paymentNoTransactions => 'No transactions yet.';

  @override
  String get patientMoreReportIssueTitle => 'Report Issue';

  @override
  String get patientMoreReportIssueSubtitle => 'Flag a concern or complaint';

  @override
  String get reportIssueTitle => 'Report Issue';

  @override
  String get reportIssueCategoryLabel => 'Category';

  @override
  String get reportIssueCategoryHint => 'Select a category';

  @override
  String get reportIssueSubjectLabel => 'Subject';

  @override
  String get reportIssueSubjectHint => 'Enter subject';

  @override
  String get reportIssueDescriptionLabel => 'Detailed Description';

  @override
  String get reportIssueDescriptionHint => 'Describe the issue in detail...';

  @override
  String get reportIssueMarkUrgent => 'Mark as Urgent';

  @override
  String get reportIssueUrgentSubtitle => 'This requires immediate attention';

  @override
  String get reportIssueNoticeTitle => 'Important Notice';

  @override
  String get reportIssueNoticeBody => 'False reports are taken very seriously and may result in account suspension. Please ensure all information provided is accurate and truthful.';

  @override
  String get reportIssueSubmit => 'Submit Report';

  @override
  String get reportIssueCancel => 'Cancel';

  @override
  String get reportIssueFieldRequired => 'This field is required';

  @override
  String get reportIssueCategoryRequired => 'Please select a category';

  @override
  String get reportIssueCatLateArrival => 'Late Arrival';

  @override
  String get reportIssueCatUnprofessional => 'Unprofessional Behavior';

  @override
  String get reportIssueCatPoorService => 'Poor Service Quality';

  @override
  String get reportIssueCatCommunication => 'Communication Issues';

  @override
  String get reportIssueCatHygiene => 'Hygiene Concerns';

  @override
  String get reportIssueCatBillingDispute => 'Billing Dispute';

  @override
  String get reportIssueCatInappropriate => 'Inappropriate Behavior';

  @override
  String get reportIssueCatHarassment => 'Harassment';

  @override
  String get reportIssueCatSafety => 'Safety Concern';

  @override
  String get reportIssueCatFraud => 'Fraud/Scam';

  @override
  String get reportIssueCatViolence => 'Violence or Threats';

  @override
  String get reportIssueCatOtherSerious => 'Other Serious Issue';

  @override
  String get reportIssueCatOther => 'Other';

  @override
  String get nurseEarningsSubtitle => 'Track your income';

  @override
  String get nurseEarningsTotalLabel => 'Total Earnings';

  @override
  String get nurseEarningsThisMonthLabel => 'Earnings This Month';

  @override
  String get nurseEarningsPendingLabel => 'Pending Amount';

  @override
  String get nurseEarningsAwaitingPayment => 'Awaiting payment completion';

  @override
  String get nurseEarningsTabAll => 'All Earnings';

  @override
  String get nurseEarningsTabThisMonth => 'This Month';

  @override
  String get nurseEarningsTabHistory => 'History';

  @override
  String get nurseEarningsRecords => 'Earnings Records';

  @override
  String get nurseEarningsCompletedServices => 'completed services';

  @override
  String get nurseEarningsServicesThisMonth => 'services this month';

  @override
  String get nurseEarningsEmpty => 'No earnings records yet.';

  @override
  String get nurseProfileReportTitle => 'Report a Problem';

  @override
  String get nurseProfileReportSubtitle => 'Flag a technical or service issue';

  @override
  String get nurseReportTitle => 'Report a Problem';

  @override
  String get nurseReportCategoryLabel => 'Problem Category';

  @override
  String get nurseReportCategoryHint => 'Select a category';

  @override
  String get nurseReportSubjectLabel => 'Subject';

  @override
  String get nurseReportSubjectHint => 'Enter subject';

  @override
  String get nurseReportDescriptionLabel => 'Detailed Description';

  @override
  String get nurseReportDescriptionHint => 'Describe the problem in detail...';

  @override
  String get nurseReportMarkUrgent => 'Mark as Urgent';

  @override
  String get nurseReportUrgentSubtitle => 'This requires immediate attention';

  @override
  String get nurseReportNoticeTitle => 'Important Notice';

  @override
  String get nurseReportNoticeBody => 'False reports are taken seriously and may result in account suspension. Only report genuine issues.';

  @override
  String get nurseReportSubmit => 'Submit Report';

  @override
  String get nurseReportCancel => 'Cancel';

  @override
  String get nurseReportFieldRequired => 'This field is required';

  @override
  String get nurseReportCategoryRequired => 'Please select a category';

  @override
  String get nurseReportCatPayment => 'Payment Issue';

  @override
  String get nurseReportCatTechnical => 'Technical Problem';

  @override
  String get nurseReportCatPatient => 'Patient Issue';

  @override
  String get nurseReportCatSafety => 'Safety Concern';

  @override
  String get nurseReportCatBug => 'Platform Bug';

  @override
  String get nurseReportCatAccount => 'Account Problem';

  @override
  String get nurseReportCatScheduling => 'Scheduling Issue';

  @override
  String get nurseReportCatOther => 'Other';

  @override
  String get emailDomainSuffix => '@nursenow.com';

  @override
  String get emailLocalPartHint => 'your.username';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle => 'Enter the verification code sent to your email and set a new password.';

  @override
  String get resetPasswordCodeLabel => 'Verification Code';

  @override
  String get resetPasswordCodeHint => 'Enter the code from your email';

  @override
  String get resetPasswordNewLabel => 'New Password';

  @override
  String get resetPasswordNewHint => 'Enter your new password';

  @override
  String get resetPasswordConfirmLabel => 'Confirm Password';

  @override
  String get resetPasswordConfirmHint => 'Re-enter your new password';

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get resetPasswordCodeRequired => 'Verification code is required';

  @override
  String get resetPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get resetPasswordMismatch => 'Passwords do not match';

  @override
  String get resetPasswordSuccess => 'Password reset successfully. Please log in.';

  @override
  String get welcomeDialogTitle => 'You\'re all set!';

  @override
  String get welcomeDialogBody => 'Your profile is ready. Start exploring and book your first nurse appointment.';

  @override
  String get welcomeDialogButton => 'Go to Dashboard';
}
