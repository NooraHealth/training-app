App.accessRule( "*");

App.setPreference('Orientation', 'landscape');
App.setPreference('AllowInlineMediaPlayback', 'true');
App.setPreference('MediaPlaybackRequiresUserAction', 'false');
App.setPreference('MediaPlaybackRequiresUserGesture', 'false');
App.setPreference('LoadUrlTimeoutValue', 70000);

App.info({
  name: "Noora Health WebApp",
  description: "Noora Health's online and mobile app curriculum",
  version: "0.0.3"
});

App.icons({
  // iOS
  'iphone': 'public/icons/icon-60x60.png',
  'ipad': 'public/icons/icon-76x76.png',
  'ipad_2x': 'public/icons/icon-152x152.png',

  //// Android
  'android_ldpi': 'public/icons/icon-36x36.png',
  'android_mdpi': 'public/icons/icon-48x48.png',
  'android_xhdpi': 'public/icons/icon-96x96.png'
});

App.launchScreens({
  // iOS
  'iphone': 'public/splash/splash-320x480.png',
  //'iphone_2x': 'public/splash/splash-320x480@2x.png',
  //'iphone5': 'public/splash/splash-320x568@2x.png',
  //'iphone6': 'public/splash/splash-375x667@2x.png',
  //'iphone6p_portrait': 'public/splash/splash-414x736@3x.png',
  //'iphone6p_landscape': 'public/splash/splash-736x414@3x.png',

  'ipad_portrait': 'public/splash/splash-768x1024.png',
  //'ipad_portrait_2x': 'public/splash/splash-768x1024@2x.png',
  'ipad_landscape': 'public/splash/splash-1024x768.png',
  //'ipad_landscape_2x': 'public/splash/splash-1024x768@2x.png',

  //// Android
  //'android_ldpi_portrait': 'public/splash/splash-200x320.png',
  //'android_ldpi_landscape': 'public/splash/splash-320x200.png',
  //'android_mdpi_portrait': 'public/splash/splash-320x480.png',
  //'android_mdpi_landscape': 'public/splash/splash-480x320.png',
  //'android_hdpi_portrait': 'public/splash/splash-480x800.png',
  //'android_hdpi_landscape': 'public/splash/splash-800x480.png',
  //'android_xhdpi_portrait': 'public/splash/splash-720x1280.png',
  //'android_xhdpi_landscape': 'public/splash/splash-1280x720.png'
});
