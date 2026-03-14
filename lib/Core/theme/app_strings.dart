class AppStrings {
  static const String lang = 'ar'; // غيريها لـ 'en' متى بدك

  // Onboarding
  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'title1': 'Professional Home\nNursing Care',
      'desc1':
          'Connect with verified registered nurses\nfor quality healthcare services in the\ncomfort of your home',
      'title2': 'Verified & Trusted\nNurses',
      'desc2':
          'All nurses are licensed professionals,\nbackground-checked and verified by\nour admin team',
      'title3': 'Book Anytime,\nAnywhere',
      'desc3':
          'Schedule nursing services 24/7 with\ninstant booking confirmations and\nreal-time updates',
      'next': 'Next  >',
      'skip': 'Skip',
      'getStarted': 'Get Started',
    },
    'ar': {
      'title1': 'رعاية تمريضية\nمنزلية احترافية',
      'desc1':
          'تواصل مع ممرضين معتمدين\nلخدمات رعاية صحية عالية الجودة\nفي راحة منزلك',
      'title2': 'ممرضون موثوقون\nومعتمدون',
      'desc2':
          'جميع الممرضين محترفون مرخصون\nتم التحقق منهم ومراجعتهم\nمن قبل فريق الإدارة',
      'title3': 'احجز في أي وقت\nومن أي مكان',
      'desc3':
          'جدول خدمات التمريض على مدار الساعة\nمع تأكيدات حجز فورية\nوتحديثات في الوقت الفعلي',
      'next': 'التالي >',
      'skip': 'تخطي',
      'getStarted': 'ابدأ الآن',
    },
  };

  static String get(String key) => _strings[lang]?[key] ?? key;
}
