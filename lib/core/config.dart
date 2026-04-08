// Provide API_BASE_URL via --dart-define=API_BASE_URL at build/run time.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://192.168.240.1:8787',
);
