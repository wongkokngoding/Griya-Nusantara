/// Info aplikasi — samakan dengan `version` di pubspec.yaml.
class AppInfo {
  AppInfo._();

  static const String name = 'Griya Nusantara';
  static const String version = '1.0.0';
  static const String buildNumber = '1';

  static String get versionLabel => '$version ($buildNumber)';
}
