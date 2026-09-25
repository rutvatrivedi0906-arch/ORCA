class OrcaLanguage {
  final String name;
  final String nativeName;
  final String code;
  final String ttsCode;

  const OrcaLanguage({
    required this.name,
    required this.nativeName,
    required this.code,
    required this.ttsCode,
  });
}

const List<OrcaLanguage> orcaLanguages = [
  OrcaLanguage(
    name: 'English',
    nativeName: 'English',
    code: 'en',
    ttsCode: 'en-IN',
  ),
  OrcaLanguage(
    name: 'Hindi',
    nativeName: 'हिन्दी',
    code: 'hi',
    ttsCode: 'hi-IN',
  ),
  OrcaLanguage(
    name: 'Gujarati',
    nativeName: 'ગુજરાતી',
    code: 'gu',
    ttsCode: 'gu-IN',
  ),
  OrcaLanguage(
    name: 'Marathi',
    nativeName: 'मराठी',
    code: 'mr',
    ttsCode: 'mr-IN',
  ),
  OrcaLanguage(
    name: 'Telugu',
    nativeName: 'తెలుగు',
    code: 'te',
    ttsCode: 'te-IN',
  ),
  OrcaLanguage(
    name: 'Tamil',
    nativeName: 'தமிழ்',
    code: 'ta',
    ttsCode: 'ta-IN',
  ),
  OrcaLanguage(
    name: 'Kannada',
    nativeName: 'ಕನ್ನಡ',
    code: 'kn',
    ttsCode: 'kn-IN',
  ),
  OrcaLanguage(
    name: 'Malayalam',
    nativeName: 'മലയാളം',
    code: 'ml',
    ttsCode: 'ml-IN',
  ),
  OrcaLanguage(
    name: 'Bengali',
    nativeName: 'বাংলা',
    code: 'bn',
    ttsCode: 'bn-IN',
  ),
  OrcaLanguage(name: 'Odia', nativeName: 'ଓଡ଼ିଆ', code: 'or', ttsCode: 'or-IN'),
];
