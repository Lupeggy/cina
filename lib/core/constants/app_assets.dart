class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String onboarding1 = 'assets/images/onboarding1.png';
  static const String onboarding2 = 'assets/images/onboarding2.png';
  static const String onboarding3 = 'assets/images/onboarding3.png';
  static const String googleLogo = 'assets/images/google_logo.png';
  static const String facebookLogo = 'assets/images/facebook_logo.png';
  static const String appleLogo = 'assets/images/apple_logo.png';
  
  // Icons
  static const String homeFilled = 'assets/icons/home_filled.png';
  static const String homeOutlined = 'assets/icons/home_outlined.png';
  static const String searchFilled = 'assets/icons/search_filled.png';
  static const String searchOutlined = 'assets/icons/search_outlined.png';
  static const String addFilled = 'assets/icons/add_filled.png';
  static const String addOutlined = 'assets/icons/add_outlined.png';
  static const String tripFilled = 'assets/icons/trip_filled.png';
  static const String tripOutlined = 'assets/icons/trip_outlined.png';
  static const String profileFilled = 'assets/icons/profile_filled.png';
  static const String profileOutlined = 'assets/icons/profile_outlined.png';
  
  // Placeholder images
  static const String placeholderImage = 'assets/images/placeholder.png';
  static const String avatarPlaceholder = 'assets/images/avatar_placeholder.png';
  
  // Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  
  // Add more assets as needed
  
  // Helper method to get asset path
  static String getImagePath(String imageName) => 'assets/images/$imageName';
  static String getIconPath(String iconName) => 'assets/icons/$iconName';
  static String getAnimationPath(String animationName) => 'assets/animations/$animationName';
}
