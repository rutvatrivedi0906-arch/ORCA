import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'role_selection_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  final List<_LanguageOption> languages = const [
    _LanguageOption('English', 'English', 'EN'),
    _LanguageOption('Hindi', 'हिन्दी', 'HI'),
    _LanguageOption('Gujarati', 'ગુજરાતી', 'GU'),
    _LanguageOption('Marathi', 'मराठी', 'MR'),
    _LanguageOption('Telugu', 'తెలుగు', 'TE'),
    _LanguageOption('Tamil', 'தமிழ்', 'TA'),
    _LanguageOption('Kannada', 'ಕನ್ನಡ', 'KN'),
    _LanguageOption('Malayalam', 'മലയാളം', 'ML'),
    _LanguageOption('Bengali', 'বাংলা', 'BN'),
    _LanguageOption('Odia', 'ଓଡ଼ିଆ', 'OR'),
  ];

  void _continue() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (context, animation, secondaryAnimation) {
          return RoleSelectionScreen(selectedLanguage: selectedLanguage);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FA),
      body: Stack(
        children: [
          const _BackgroundDecoration(),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.oceanBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.language_rounded,
                              size: 17,
                              color: AppTheme.oceanBlue,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'LANGUAGE',
                              style: TextStyle(
                                color: AppTheme.oceanBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),

                        const Text(
                          'Choose your\nlanguage',
                          style: TextStyle(
                            fontSize: 34,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.navy,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Choose the language you understand best. '
                          'ORCA will use it across guidance, alerts '
                          'and marine information.',
                          style: TextStyle(
                            color: Color(0xFF617783),
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: languages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.65,
                                ),
                            itemBuilder: (context, index) {
                              final language = languages[index];

                              final isSelected =
                                  selectedLanguage == language.name;

                              return _LanguageCard(
                                language: language,
                                selected: isSelected,
                                onTap: () {
                                  setState(() {
                                    selectedLanguage = language.name;
                                  });
                                },
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F6F6),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.volume_up_rounded,
                                color: AppTheme.cyan,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Voice guidance will also follow '
                                  'your selected language.',
                                  style: TextStyle(
                                    color: AppTheme.navy,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: FilledButton(
                            onPressed: _continue,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.navy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue in $selectedLanguage',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.arrow_forward_rounded),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final _LanguageOption language;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.oceanBlue, AppTheme.cyan],
              )
            : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Colors.transparent : const Color(0xFFDCE7EC),
        ),
        boxShadow: [
          BoxShadow(
            color: selected
                ? AppTheme.oceanBlue.withValues(alpha: 0.20)
                : Colors.black.withValues(alpha: 0.035),
            blurRadius: selected ? 18 : 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.18)
                        : const Color(0xFFF0F6F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    language.code,
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.oceanBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Text(
                    language.nativeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.navy,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -110,
            right: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.cyan.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.oceanBlue.withValues(alpha: 0.06),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption {
  final String name;
  final String nativeName;
  final String code;

  const _LanguageOption(this.name, this.nativeName, this.code);
}
