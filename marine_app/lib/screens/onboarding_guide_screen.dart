import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/theme/app_theme.dart';
import '../data/orca_guide_content.dart';
import '../data/orca_languages.dart';

class OnboardingGuideScreen extends StatefulWidget {
  final String initialLanguageCode;

  const OnboardingGuideScreen({super.key, this.initialLanguageCode = 'en'});

  @override
  State<OnboardingGuideScreen> createState() => _OnboardingGuideScreenState();
}

class _OnboardingGuideScreenState extends State<OnboardingGuideScreen> {
  final FlutterTts _tts = FlutterTts();

  late String selectedLanguageCode;
  int selectedRoleIndex = 0;
  int currentStep = 0;
  bool isSpeaking = false;

  GuideLocalePack get pack => getGuidePack(selectedLanguageCode);
  RoleGuideData get selectedGuide => pack.guides[selectedRoleIndex];
  GuideStepData get selectedStep => selectedGuide.steps[currentStep];

  OrcaLanguage get currentLanguage => orcaLanguages.firstWhere(
    (language) => language.code == selectedLanguageCode,
    orElse: () => orcaLanguages.first,
  );

  @override
  void initState() {
    super.initState();
    selectedLanguageCode = widget.initialLanguageCode;
    _configureTts();
  }

  Future<void> _configureTts() async {
    await _tts.setSpeechRate(0.44);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      if (mounted) setState(() => isSpeaking = true);
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => isSpeaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => isSpeaking = false);
    });
    _tts.setErrorHandler((_) {
      if (mounted) setState(() => isSpeaking = false);
    });
  }

  Future<void> _speakCurrentStep() async {
    await _tts.stop();

    final available = await _tts.isLanguageAvailable(currentLanguage.ttsCode);
    if (available != true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pack.voiceUnavailable)));
      return;
    }

    await _tts.setLanguage(currentLanguage.ttsCode);
    await _tts.speak(
      '${selectedGuide.title}. ${selectedStep.title}. ${selectedStep.description}',
    );
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();
    if (mounted) setState(() => isSpeaking = false);
  }

  void _changeLanguage(String code) {
    _stopSpeaking();
    setState(() {
      selectedLanguageCode = code;
      selectedRoleIndex = 0;
      currentStep = 0;
    });
  }

  void _changeRole(int index) {
    _stopSpeaking();
    setState(() {
      selectedRoleIndex = index;
      currentStep = 0;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F9),
      body: Stack(
        children: [
          const _GuideBackground(),
          SafeArea(
            child: Column(
              children: [
                _topBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Column(
                            key: ValueKey(selectedLanguageCode),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pack.pageTitle,
                                style: const TextStyle(
                                  color: AppTheme.navy,
                                  fontSize: 31,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                pack.pageSubtitle,
                                style: const TextStyle(
                                  color: Color(0xFF647A85),
                                  fontSize: 14.5,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _languageSelector(),
                        const SizedBox(height: 24),
                        Text(
                          pack.chooseGuide,
                          style: const TextStyle(
                            color: AppTheme.navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _roleSelector(),
                        const SizedBox(height: 26),
                        _roleOverview(),
                        const SizedBox(height: 20),
                        _currentStepCard(),
                        const SizedBox(height: 20),
                        _stepIndicators(),
                        const SizedBox(height: 24),
                        _navigationButtons(),
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

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.oceanBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 16,
                  color: AppTheme.oceanBlue,
                ),
                SizedBox(width: 6),
                Text(
                  'ORCA GUIDE',
                  style: TextStyle(
                    color: AppTheme.oceanBlue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDCE8EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.oceanBlue, AppTheme.cyan],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.language_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedLanguageCode,
                borderRadius: BorderRadius.circular(18),
                items: orcaLanguages.map((language) {
                  return DropdownMenuItem(
                    value: language.code,
                    child: Text(
                      '${language.nativeName} • ${language.name}',
                      style: const TextStyle(
                        color: AppTheme.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) _changeLanguage(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleSelector() {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pack.guides.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final guide = pack.guides[index];
          final selected = selectedRoleIndex == index;

          return GestureDetector(
            onTap: () => _changeRole(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 132,
              padding: const EdgeInsets.all(13),
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
                  color: selected
                      ? Colors.transparent
                      : const Color(0xFFDCE8EC),
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: AppTheme.oceanBlue.withValues(alpha: 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    guide.icon,
                    color: selected ? Colors.white : AppTheme.oceanBlue,
                    size: 27,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    guide.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.navy,
                      fontSize: 11.5,
                      height: 1.12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _roleOverview() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey('${selectedLanguageCode}_${selectedGuide.roleKey}'),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF061B2C), Color(0xFF0A566D)],
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(selectedGuide.icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedGuide.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    selectedGuide.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentStepCard() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(
          '${selectedLanguageCode}_${selectedRoleIndex}_$currentStep',
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFFDCE8EC)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.oceanBlue.withValues(alpha: 0.07),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.oceanBlue, AppTheme.cyan],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(selectedStep.icon, color: Colors.white, size: 29),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${pack.stepLabel} ${currentStep + 1}',
                    style: const TextStyle(
                      color: AppTheme.oceanBlue,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              selectedStep.title,
              style: const TextStyle(
                color: AppTheme.navy,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedStep.description,
              style: const TextStyle(
                color: Color(0xFF617783),
                fontSize: 14.5,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: isSpeaking ? _stopSpeaking : _speakCurrentStep,
                icon: Icon(
                  isSpeaking
                      ? Icons.stop_circle_outlined
                      : Icons.volume_up_rounded,
                ),
                label: Text(
                  isSpeaking
                      ? pack.stopListening
                      : '${pack.listen} • ${currentLanguage.nativeName}',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.oceanBlue,
                  side: const BorderSide(color: Color(0xFFB8D8E0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(selectedGuide.steps.length, (index) {
        final selected = index == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: selected ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: selected ? AppTheme.oceanBlue : const Color(0xFFC7D6DC),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }

  Widget _navigationButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: currentStep == 0
                  ? null
                  : () {
                      _stopSpeaking();
                      setState(() => currentStep--);
                    },
              child: Text(pack.previous),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: () {
                _stopSpeaking();
                if (currentStep < selectedGuide.steps.length - 1) {
                  setState(() => currentStep++);
                } else {
                  Navigator.pop(context);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.navy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: Text(
                currentStep == selectedGuide.steps.length - 1
                    ? pack.finishGuide
                    : pack.nextStep,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GuideBackground extends StatelessWidget {
  const _GuideBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.cyan.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.oceanBlue.withValues(alpha: 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
