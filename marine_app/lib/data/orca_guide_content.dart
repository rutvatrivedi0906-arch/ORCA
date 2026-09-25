import 'package:flutter/material.dart';

class GuideStepData {
  final IconData icon;
  final String title;
  final String description;

  const GuideStepData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class RoleGuideData {
  final String roleKey;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<GuideStepData> steps;

  const RoleGuideData({
    required this.roleKey,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.steps,
  });
}

class GuideLocalePack {
  final String code;
  final String pageTitle;
  final String pageSubtitle;
  final String languageLabel;
  final String chooseGuide;
  final String listen;
  final String stopListening;
  final String previous;
  final String nextStep;
  final String finishGuide;
  final String stepLabel;
  final String voiceUnavailable;
  final List<RoleGuideData> guides;

  const GuideLocalePack({
    required this.code,
    required this.pageTitle,
    required this.pageSubtitle,
    required this.languageLabel,
    required this.chooseGuide,
    required this.listen,
    required this.stopListening,
    required this.previous,
    required this.nextStep,
    required this.finishGuide,
    required this.stepLabel,
    required this.voiceUnavailable,
    required this.guides,
  });
}

const _roleOrder = ['FISHERMAN', 'RESEARCHER', 'AUTHORITY', 'ADMIN'];

const _roleIcons = <String, IconData>{
  'FISHERMAN': Icons.phishing_rounded,
  'RESEARCHER': Icons.science_rounded,
  'AUTHORITY': Icons.health_and_safety_rounded,
  'ADMIN': Icons.admin_panel_settings_rounded,
};

const _stepIcons = <String, List<IconData>>{
  'FISHERMAN': [
    Icons.waves_rounded,
    Icons.route_rounded,
    Icons.download_for_offline_rounded,
    Icons.sos_rounded,
  ],
  'RESEARCHER': [
    Icons.layers_rounded,
    Icons.travel_explore_rounded,
    Icons.analytics_rounded,
    Icons.fact_check_rounded,
  ],
  'AUTHORITY': [
    Icons.crisis_alert_rounded,
    Icons.sos_rounded,
    Icons.assignment_turned_in_rounded,
    Icons.campaign_rounded,
  ],
  'ADMIN': [
    Icons.manage_accounts_rounded,
    Icons.storage_rounded,
    Icons.model_training_rounded,
    Icons.monitor_heart_outlined,
  ],
};

GuideLocalePack getGuidePack(String code) {
  final locale = _localizedText[code] ?? _localizedText['en']!;
  final roles = locale['roles'] as Map<String, dynamic>;

  final guides = _roleOrder.map((roleKey) {
    final role = roles[roleKey] as Map<String, dynamic>;
    final rawSteps = role['steps'] as List<dynamic>;
    final icons = _stepIcons[roleKey]!;

    return RoleGuideData(
      roleKey: roleKey,
      title: role['title'] as String,
      subtitle: role['subtitle'] as String,
      icon: _roleIcons[roleKey]!,
      steps: List.generate(rawSteps.length, (index) {
        final step = rawSteps[index] as Map<String, dynamic>;
        return GuideStepData(
          icon: icons[index],
          title: step['title'] as String,
          description: step['description'] as String,
        );
      }),
    );
  }).toList();

  return GuideLocalePack(
    code: code,
    pageTitle: locale['pageTitle'] as String,
    pageSubtitle: locale['pageSubtitle'] as String,
    languageLabel: locale['languageLabel'] as String,
    chooseGuide: locale['chooseGuide'] as String,
    listen: locale['listen'] as String,
    stopListening: locale['stopListening'] as String,
    previous: locale['previous'] as String,
    nextStep: locale['nextStep'] as String,
    finishGuide: locale['finishGuide'] as String,
    stepLabel: locale['stepLabel'] as String,
    voiceUnavailable: locale['voiceUnavailable'] as String,
    guides: guides,
  );
}

final Map<String, Map<String, dynamic>> _localizedText = {
  'en': {
    'pageTitle': 'How ORCA Works',
    'pageSubtitle': 'Choose your language and role. ORCA will explain the workflow in the same language.',
    'languageLabel': 'Explanation language',
    'chooseGuide': 'Choose your guide',
    'listen': 'Listen',
    'stopListening': 'Stop',
    'previous': 'Previous',
    'nextStep': 'Next step',
    'finishGuide': 'Finish guide',
    'stepLabel': 'STEP',
    'voiceUnavailable':
        'A speech voice for this language is not installed on this device.',
    'roles': {
      'FISHERMAN': {
        'title': 'Fisherman',
        'subtitle': 'Simple guidance for safer sea trips, offline use and emergency support.',
        'steps': [
          {
            'title': 'Check the sea before leaving',
            'description': 'See simple sea-safety information such as waves, wind, tide, weather and important marine warnings before starting your trip.',
          },
          {
            'title': 'Plan a safer trip',
            'description': 'Enter your departure and return plan. ORCA can show a safer route, nearby hazards and boundary risks instead of only drawing a straight line.',
          },
          {
            'title': 'Carry a Mission Pack offline',
            'description': 'Before leaving network coverage, download the map, route, alerts, geofences and forecast information needed for your sea mission.',
          },
          {
            'title': 'Use SOS when needed',
            'description': 'ORCA can prepare your coordinates, vessel and mission details for rescue teams and clearly show whether the SOS was sent, acknowledged or still waiting for network.',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'Marine Researcher',
        'subtitle': 'Professional exploration of ocean data, anomalies, environmental suitability and evidence.',
        'steps': [
          {
            'title': 'Explore scientific data layers',
            'description': 'Work with SST, chlorophyll-a, significant wave height and swell, wind, ocean currents, tides, bathymetry and historical PFZ occurrence in one research workspace.',
          },
          {
            'title': 'Query an area and time window',
            'description': 'Select an area of interest and date range, overlay multiple layers, compare locations or periods, inspect seasonal baselines and identify spatial or temporal anomalies.',
          },
          {
            'title': 'Investigate productivity and suitability',
            'description': 'Use the Productivity Investigator to study relationships among SST, chlorophyll, fronts, currents and PFZ history. Without catch or CPUE data, ORCA reports environmental indicators associated with fishing suitability rather than claiming biological causation.',
          },
          {
            'title': 'Produce evidence-backed outcomes',
            'description': 'Review data provenance, freshness, validity and confidence; generate maps and charts; compare conditions; and prepare traceable research summaries or reports with the evidence used for each conclusion.',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'Coastal Authority / Rescue',
        'subtitle': 'Operational awareness for hazards, SOS incidents, advisories and geofenced safety.',
        'steps': [
          {
            'title': 'Monitor marine hazards',
            'description': 'Use the command map to view high-wave conditions, adverse weather, cyclone or lightning information, restricted areas and other geofenced risks.',
          },
          {
            'title': 'Receive SOS with context',
            'description': 'Inspect reported coordinates together with fisherman identity, vessel information, persons onboard and mission context instead of receiving only a bare location.',
          },
          {
            'title': 'Manage the incident lifecycle',
            'description': 'Acknowledge, assign, track and resolve incidents through a clear workflow so response teams share the same operational status.',
          },
          {
            'title': 'Publish safety advisories',
            'description': 'Maintain geofences, review hazard areas and broadcast targeted marine warnings or advisories to connected ORCA users.',
          },
        ],
      },
      'ADMIN': {
        'title': 'Administrator',
        'subtitle': 'Restricted operational control for ORCA users, data services, models and system health.',
        'steps': [
          {
            'title': 'Manage users and roles',
            'description': 'Review accounts and role assignments while keeping Fisherman, Researcher, Authority and Admin access separated by backend permissions.',
          },
          {
            'title': 'Monitor data freshness',
            'description': 'Track dataset and API availability, update timestamps and ingestion health so stale marine information can be identified before it affects decisions.',
          },
          {
            'title': 'Monitor models and agents',
            'description': 'Review model versions, metrics, agent execution logs and service behavior for the intelligence components used by ORCA.',
          },
          {
            'title': 'Maintain platform health',
            'description': 'Monitor backend services, geofence datasets and platform status while preserving traceability for operational changes.',
          },
        ],
      },
    },
  },
  'hi': {
    'pageTitle': 'ORCA कैसे काम करता है',
    'pageSubtitle':
        'अपनी भाषा और भूमिका चुनें। ORCA उसी भाषा में पूरी प्रक्रिया समझाएगा।',
    'languageLabel': 'समझाने की भाषा',
    'chooseGuide': 'अपना गाइड चुनें',
    'listen': 'सुनें',
    'stopListening': 'रोकें',
    'previous': 'पिछला',
    'nextStep': 'अगला चरण',
    'finishGuide': 'गाइड पूरा करें',
    'stepLabel': 'चरण',
    'voiceUnavailable': 'इस भाषा की आवाज़ इस डिवाइस पर उपलब्ध नहीं है।',
    'roles': {
      'FISHERMAN': {
        'title': 'मछुआरा',
        'subtitle': 'सुरक्षित समुद्री यात्रा, ऑफलाइन उपयोग और आपात सहायता के लिए सरल मार्गदर्शन।',
        'steps': [
          {
            'title': 'निकलने से पहले समुद्र की स्थिति देखें',
            'description': 'यात्रा से पहले लहरें, हवा, ज्वार, मौसम और जरूरी समुद्री चेतावनियां आसान रूप में देखें।',
          },
          {
            'title': 'सुरक्षित यात्रा की योजना बनाएं',
            'description': 'जाने और लौटने का समय दें। ORCA सुरक्षित मार्ग, आसपास के खतरे और सीमा पार करने के जोखिम दिखा सकता है।',
          },
          {
            'title': 'Mission Pack ऑफलाइन रखें',
            'description': 'नेटवर्क छोड़ने से पहले नक्शा, मार्ग, alerts, geofences और जरूरी forecast जानकारी डाउनलोड करें।',
          },
          {
            'title': 'जरूरत पर SOS इस्तेमाल करें',
            'description': 'ORCA आपके coordinates, vessel और mission details rescue team के लिए तैयार करता है और साफ बताता है कि SOS भेजा गया, acknowledge हुआ या network की प्रतीक्षा में है।',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'समुद्री शोधकर्ता',
        'subtitle': 'Ocean data, anomalies, environmental suitability और evidence का पेशेवर विश्लेषण।',
        'steps': [
          {
            'title': 'Scientific data layers देखें',
            'description': 'SST, chlorophyll-a, significant wave height और swell, wind, ocean currents, tides, bathymetry और historical PFZ occurrence को एक research workspace में देखें।',
          },
          {
            'title': 'Area और time window चुनें',
            'description': 'Area of interest और date range चुनकर layers overlay करें, locations या periods compare करें, seasonal baselines देखें और spatial या temporal anomalies पहचानें।',
          },
          {
            'title': 'Productivity और suitability का अध्ययन करें',
            'description': 'SST, chlorophyll, fronts, currents और PFZ history के संबंधों का विश्लेषण करें। Catch या CPUE data न होने पर ORCA biological causation नहीं बताएगा, बल्कि fishing suitability से जुड़े environmental indicators बताएगा।',
          },
          {
            'title': 'Evidence-backed परिणाम तैयार करें',
            'description': 'Data provenance, freshness, validity और confidence देखें; maps और charts बनाएं; conditions compare करें; और evidence के साथ traceable research summary या report तैयार करें।',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'तटीय प्राधिकरण / बचाव',
        'subtitle': 'Hazards, SOS incidents, advisories और geofenced safety के लिए operational awareness।',
        'steps': [
          {
            'title': 'समुद्री खतरों की निगरानी करें',
            'description': 'Command map पर high-wave conditions, खराब मौसम, cyclone या lightning information, restricted areas और geofenced risks देखें।',
          },
          {
            'title': 'पूरे context के साथ SOS प्राप्त करें',
            'description': 'Coordinates के साथ fisherman identity, vessel information, persons onboard और mission context देखें।',
          },
          {
            'title': 'Incident lifecycle संभालें',
            'description': 'Incident acknowledge, assign, track और resolve करें ताकि response teams एक ही operational status देखें।',
          },
          {
            'title': 'Safety advisories जारी करें',
            'description': 'Geofences और hazard areas manage करके connected ORCA users तक targeted warnings भेजें।',
          },
        ],
      },
      'ADMIN': {
        'title': 'एडमिन',
        'subtitle': 'Users, data services, models और system health के लिए restricted control।',
        'steps': [
          {
            'title': 'Users और roles manage करें',
            'description': 'Accounts और role assignments देखें और backend permissions से access अलग रखें।',
          },
          {
            'title': 'Data freshness monitor करें',
            'description': 'Dataset और API availability, update timestamps और ingestion health देखें ताकि stale data पहचाना जा सके।',
          },
          {
            'title': 'Models और agents monitor करें',
            'description': 'Model versions, metrics, agent execution logs और intelligence services की activity देखें।',
          },
          {
            'title': 'Platform health बनाए रखें',
            'description': 'Backend services, geofence datasets और overall platform status traceable तरीके से monitor करें।',
          },
        ],
      },
    },
  },
  'mr': {
    'pageTitle': 'ORCA कसे काम करते',
    'pageSubtitle': 'तुमची भाषा आणि भूमिका निवडा. ORCA त्याच भाषेत संपूर्ण प्रक्रिया समजावून सांगेल.',
    'languageLabel': 'समजावणीची भाषा',
    'chooseGuide': 'तुमचा मार्गदर्शक निवडा',
    'listen': 'ऐका',
    'stopListening': 'थांबवा',
    'previous': 'मागील',
    'nextStep': 'पुढील टप्पा',
    'finishGuide': 'मार्गदर्शक पूर्ण करा',
    'stepLabel': 'टप्पा',
    'voiceUnavailable': 'या भाषेसाठी आवाज या डिव्हाइसवर उपलब्ध नाही.',
    'roles': {
      'FISHERMAN': {
        'title': 'मच्छीमार',
        'subtitle': 'सुरक्षित समुद्री प्रवास, ऑफलाइन वापर आणि आपत्कालीन मदतीसाठी सोपे मार्गदर्शन।',
        'steps': [
          {
            'title': 'निघण्यापूर्वी समुद्राची स्थिती पाहा',
            'description': 'प्रवासापूर्वी लाटा, वारा, भरती-ओहोटी, हवामान आणि महत्त्वाच्या समुद्री सूचना सोप्या पद्धतीने पाहा.',
          },
          {
            'title': 'अधिक सुरक्षित प्रवासाची योजना करा',
            'description': 'जाण्याची आणि परतण्याची माहिती द्या. ORCA अधिक सुरक्षित मार्ग, जवळचे धोके आणि सीमा ओलांडण्याचा धोका दाखवू शकते.',
          },
          {
            'title': 'Mission Pack ऑफलाइन ठेवा',
            'description': 'नेटवर्क सोडण्यापूर्वी नकाशा, route, alerts, geofences आणि आवश्यक forecast माहिती डाउनलोड करा.',
          },
          {
            'title': 'गरज पडल्यास SOS वापरा',
            'description': 'ORCA तुमचे coordinates, vessel आणि mission details rescue team साठी तयार करते आणि SOS पाठवला, acknowledge झाला किंवा network ची प्रतीक्षा आहे हे स्पष्ट दाखवते.',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'समुद्री संशोधक',
        'subtitle': 'Ocean data, anomalies, environmental suitability आणि evidence चे व्यावसायिक विश्लेषण.',
        'steps': [
          {
            'title': 'Scientific data layers पाहा',
            'description': 'SST, chlorophyll-a, significant wave height आणि swell, wind, ocean currents, tides, bathymetry आणि historical PFZ occurrence एकाच research workspace मध्ये पाहा.',
          },
          {
            'title': 'Area आणि time window निवडा',
            'description': 'Area of interest आणि date range निवडून layers overlay करा, locations किंवा periods compare करा, seasonal baselines पाहा आणि spatial किंवा temporal anomalies ओळखा.',
          },
          {
            'title': 'Productivity आणि suitability तपासा',
            'description': 'SST, chlorophyll, fronts, currents आणि PFZ history यांच्यातील संबंधांचा अभ्यास करा. Catch किंवा CPUE data नसल्यास ORCA biological causation न सांगता fishing suitability शी संबंधित environmental indicators दाखवते.',
          },
          {
            'title': 'Evidence-backed outcomes तयार करा',
            'description': 'Data provenance, freshness, validity आणि confidence तपासा; maps आणि charts तयार करा; conditions compare करा; आणि evidence सह traceable research summary किंवा report तयार करा.',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'किनारी प्राधिकरण / बचाव',
        'subtitle': 'Hazards, SOS incidents, advisories आणि geofenced safety साठी operational awareness.',
        'steps': [
          {
            'title': 'समुद्री धोके monitor करा',
            'description': 'Command map वर high-wave conditions, खराब हवामान, cyclone किंवा lightning information, restricted areas आणि geofenced risks पाहा.',
          },
          {
            'title': 'पूर्ण context सह SOS मिळवा',
            'description': 'Coordinates सोबत fisherman identity, vessel information, persons onboard आणि mission context पाहा.',
          },
          {
            'title': 'Incident lifecycle manage करा',
            'description': 'Incident acknowledge, assign, track आणि resolve करा, जेणेकरून response teams एकच operational status पाहतील.',
          },
          {
            'title': 'Safety advisories प्रसारित करा',
            'description': 'Geofences आणि hazard areas manage करून connected ORCA users पर्यंत targeted warnings पोहोचवा.',
          },
        ],
      },
      'ADMIN': {
        'title': 'प्रशासक',
        'subtitle': 'Users, data services, models आणि system health साठी restricted control.',
        'steps': [
          {
            'title': 'Users आणि roles manage करा',
            'description': 'Accounts आणि role assignments तपासा आणि backend permissions द्वारे access वेगळे ठेवा.',
          },
          {
            'title': 'Data freshness तपासा',
            'description': 'Dataset आणि API availability, update timestamps आणि ingestion health monitor करा.',
          },
          {
            'title': 'Models आणि agents monitor करा',
            'description': 'Model versions, metrics, agent execution logs आणि intelligence services तपासा.',
          },
          {
            'title': 'Platform health सांभाळा',
            'description': 'Backend services, geofence datasets आणि platform status traceable पद्धतीने monitor करा.',
          },
        ],
      },
    },
  },
  'gu': {
    'pageTitle': 'ORCA કેવી રીતે કામ કરે છે',
    'pageSubtitle': 'તમારી ભાષા અને ભૂમિકા પસંદ કરો. ORCA એ જ ભાષામાં સમગ્ર પ્રક્રિયા સમજાવશે.',
    'languageLabel': 'સમજાવટની ભાષા',
    'chooseGuide': 'તમારો માર્ગદર્શક પસંદ કરો',
    'listen': 'સાંભળો',
    'stopListening': 'બંધ કરો',
    'previous': 'પાછળ',
    'nextStep': 'આગળનું પગલું',
    'finishGuide': 'માર્ગદર્શક પૂર્ણ કરો',
    'stepLabel': 'પગલું',
    'voiceUnavailable': 'આ ભાષાનો અવાજ આ ઉપકરણમાં ઉપલબ્ધ નથી.',
    'roles': {
      'FISHERMAN': {
        'title': 'માછીમાર',
        'subtitle': 'સુરક્ષિત દરિયાઈ મુસાફરી, ઓફલાઇન ઉપયોગ અને આપાતકાલીન સહાય માટે સરળ માર્ગદર્શન.',
        'steps': [
          {
            'title': 'નિકળતા પહેલા દરિયાની સ્થિતિ જુઓ',
            'description': 'મુસાફરી પહેલા તરંગો, પવન, જ્વાર, હવામાન અને મહત્વપૂર્ણ દરિયાઈ ચેતવણીઓ સરળ રીતે જુઓ.',
          },
          {
            'title': 'વધુ સુરક્ષિત મુસાફરીની યોજના બનાવો',
            'description': 'પ્રસ્થાન અને પરત આવવાનો સમય આપો. ORCA વધુ સુરક્ષિત માર્ગ, નજીકના જોખમ અને સીમા જોખમ બતાવી શકે છે.',
          },
          {
            'title': 'Mission Pack ઓફલાઇન રાખો',
            'description': 'નેટવર્ક છોડતા પહેલા નકશો, route, alerts, geofences અને forecast માહિતી ડાઉનલોડ કરો.',
          },
          {
            'title': 'જરૂર પડે ત્યારે SOS કરો',
            'description': 'ORCA તમારા coordinates, vessel અને mission details rescue team માટે તૈયાર કરે છે અને SOS મોકલાયું, acknowledge થયું કે network માટે રાહ જુએ છે તે બતાવે છે.',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'સમુદ્રી સંશોધક',
        'subtitle': 'Ocean data, anomalies, environmental suitability અને evidence નું વ્યાવસાયિક વિશ્લેષણ.',
        'steps': [
          {
            'title': 'Scientific data layers જુઓ',
            'description': 'SST, chlorophyll-a, significant wave height અને swell, wind, ocean currents, tides, bathymetry અને historical PFZ occurrence એક research workspace માં તપાસો.',
          },
          {
            'title': 'Area અને time window પસંદ કરો',
            'description': 'Area of interest અને date range પસંદ કરીને layers overlay કરો, locations અથવા periods compare કરો, seasonal baselines અને anomalies તપાસો.',
          },
          {
            'title': 'Productivity અને suitability તપાસો',
            'description': 'SST, chlorophyll, fronts, currents અને PFZ history વચ્ચેના સંબંધો તપાસો. Catch અથવા CPUE data વગર ORCA biological causation નહિ કહે; તે fishing suitability સાથે જોડાયેલા environmental indicators દર્શાવે છે.',
          },
          {
            'title': 'Evidence-backed outcomes બનાવો',
            'description': 'Data provenance, freshness, validity અને confidence તપાસો; maps અને charts બનાવો; conditions compare કરો; અને evidence સાથે traceable research report તૈયાર કરો.',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'કાંઠા સત્તા / બચાવ',
        'subtitle': 'Hazards, SOS, advisories અને geofenced safety માટે operational awareness.',
        'steps': [
          {
            'title': 'દરિયાઈ જોખમો monitor કરો',
            'description': 'Command map પર high waves, bad weather, cyclone અથવા lightning information, restricted areas અને geofenced risks જુઓ.',
          },
          {
            'title': 'Context સાથે SOS મેળવો',
            'description': 'Coordinates સાથે fisherman identity, vessel information, persons onboard અને mission context જુઓ.',
          },
          {
            'title': 'Incident lifecycle manage કરો',
            'description': 'Incident acknowledge, assign, track અને resolve કરો જેથી તમામ response teams એક જ status જુએ.',
          },
          {
            'title': 'Safety advisories મોકલો',
            'description': 'Geofences અને hazard areas manage કરીને targeted warnings connected ORCA users સુધી પહોંચાડો.',
          },
        ],
      },
      'ADMIN': {
        'title': 'એડમિન',
        'subtitle': 'Users, data services, models અને system health માટે restricted control.',
        'steps': [
          {
            'title': 'Users અને roles manage કરો',
            'description': 'Accounts અને role assignments તપાસો અને backend permissions વડે access અલગ રાખો.',
          },
          {
            'title': 'Data freshness monitor કરો',
            'description': 'Dataset અને API availability, update timestamps અને ingestion health તપાસો.',
          },
          {
            'title': 'Models અને agents monitor કરો',
            'description': 'Model versions, metrics, agent execution logs અને intelligence services તપાસો.',
          },
          {
            'title': 'Platform health જાળવો',
            'description': 'Backend services, geofence datasets અને platform status traceable રીતે monitor કરો.',
          },
        ],
      },
    },
  },
  'te': {
    'pageTitle': 'ORCA ఎలా పనిచేస్తుంది',
    'pageSubtitle': 'మీ భాష మరియు పాత్రను ఎంచుకోండి. ORCA అదే భాషలో మొత్తం ప్రక్రియను వివరిస్తుంది.',
    'languageLabel': 'వివరణ భాష',
    'chooseGuide': 'మీ గైడ్‌ను ఎంచుకోండి',
    'listen': 'వినండి',
    'stopListening': 'ఆపండి',
    'previous': 'మునుపటి',
    'nextStep': 'తదుపరి దశ',
    'finishGuide': 'గైడ్ పూర్తి చేయండి',
    'stepLabel': 'దశ',
    'voiceUnavailable': 'ఈ భాషకు సంబంధించిన వాయిస్ ఈ పరికరంలో లేదు.',
    'roles': {
      'FISHERMAN': {
        'title': 'మత్స్యకారుడు',
        'subtitle': 'సురక్షిత సముద్ర ప్రయాణం, ఆఫ్‌లైన్ వినియోగం మరియు అత్యవసర సహాయం కోసం సులభమైన మార్గదర్శకం.',
        'steps': [
          {
            'title': 'బయలుదేరే ముందు సముద్ర పరిస్థితిని చూడండి',
            'description': 'ప్రయాణానికి ముందు అలలు, గాలి, టైడ్, వాతావరణం మరియు ముఖ్యమైన సముద్ర హెచ్చరికలను సులభంగా చూడండి.',
          },
          {
            'title': 'సురక్షితమైన ప్రయాణాన్ని ప్లాన్ చేయండి',
            'description': 'బయలుదేరు మరియు తిరుగు సమయాన్ని ఇవ్వండి. ORCA సురక్షిత మార్గం, సమీప ప్రమాదాలు మరియు సరిహద్దు ప్రమాదాలను చూపగలదు.',
          },
          {
            'title': 'Mission Pack ను ఆఫ్‌లైన్‌లో ఉంచండి',
            'description': 'నెట్‌వర్క్ విడిచే ముందు మ్యాప్, route, alerts, geofences మరియు forecast సమాచారాన్ని డౌన్‌లోడ్ చేయండి.',
          },
          {
            'title': 'అవసరమైనప్పుడు SOS వాడండి',
            'description': 'ORCA మీ coordinates, vessel మరియు mission details ను rescue team కోసం సిద్ధం చేస్తుంది; SOS పంపబడిందా, acknowledge అయ్యిందా లేదా network కోసం వేచి ఉందా స్పష్టంగా చూపిస్తుంది.',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'సముద్ర పరిశోధకుడు',
        'subtitle': 'Ocean data, anomalies, environmental suitability మరియు evidence పై ప్రొఫెషనల్ విశ్లేషణ.',
        'steps': [
          {
            'title': 'Scientific data layers ను పరిశీలించండి',
            'description': 'SST, chlorophyll-a, significant wave height మరియు swell, wind, ocean currents, tides, bathymetry మరియు historical PFZ occurrence ను ఒకే research workspace లో పరిశీలించండి.',
          },
          {
            'title': 'Area మరియు time window ఎంచుకోండి',
            'description': 'Area of interest మరియు date range ఎంచుకుని layers overlay చేయండి, locations లేదా periods ను compare చేయండి, seasonal baselines మరియు anomalies ను పరిశీలించండి.',
          },
          {
            'title': 'Productivity మరియు suitability విశ్లేషించండి',
            'description': 'SST, chlorophyll, fronts, currents మరియు PFZ history మధ్య సంబంధాలను అధ్యయనం చేయండి. Catch లేదా CPUE data లేకపోతే ORCA biological causation అని చెప్పదు; fishing suitability కు సంబంధించిన environmental indicators మాత్రమే చూపిస్తుంది.',
          },
          {
            'title': 'Evidence-backed outcomes రూపొందించండి',
            'description': 'Data provenance, freshness, validity మరియు confidence చూడండి; maps, charts రూపొందించండి; conditions compare చేసి evidence తో traceable research summary లేదా report తయారు చేయండి.',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'తీర అధికార సంస్థ / రక్షణ',
        'subtitle': 'Hazards, SOS incidents, advisories మరియు geofenced safety కోసం operational awareness.',
        'steps': [
          {
            'title': 'సముద్ర ప్రమాదాలను monitor చేయండి',
            'description': 'Command map లో high-wave conditions, bad weather, cyclone లేదా lightning information, restricted areas మరియు geofenced risks చూడండి.',
          },
          {
            'title': 'Context తో SOS పొందండి',
            'description': 'Coordinates తో పాటు fisherman identity, vessel information, persons onboard మరియు mission context చూడండి.',
          },
          {
            'title': 'Incident lifecycle నిర్వహించండి',
            'description': 'Incident ను acknowledge, assign, track మరియు resolve చేసి response teams ఒకే operational status ను చూడేలా చేయండి.',
          },
          {
            'title': 'Safety advisories పంపండి',
            'description': 'Geofences మరియు hazard areas నిర్వహించి targeted warnings ను connected ORCA users కు పంపండి.',
          },
        ],
      },
      'ADMIN': {
        'title': 'అడ్మిన్',
        'subtitle': 'Users, data services, models మరియు system health కోసం restricted control.',
        'steps': [
          {
            'title': 'Users మరియు roles నిర్వహించండి',
            'description': 'Accounts మరియు role assignments ను పరిశీలించి backend permissions ద్వారా access ను విడిగా ఉంచండి.',
          },
          {
            'title': 'Data freshness monitor చేయండి',
            'description': 'Dataset మరియు API availability, update timestamps మరియు ingestion health ను పరిశీలించండి.',
          },
          {
            'title': 'Models మరియు agents monitor చేయండి',
            'description': 'Model versions, metrics, agent execution logs మరియు intelligence services ను పరిశీలించండి.',
          },
          {
            'title': 'Platform health నిర్వహించండి',
            'description': 'Backend services, geofence datasets మరియు platform status ను traceable విధంగా monitor చేయండి.',
          },
        ],
      },
    },
  },
  'ta': {
    'pageTitle': 'ORCA எப்படி செயல்படுகிறது',
    'pageSubtitle': 'உங்கள் மொழி மற்றும் பாத்திரத்தை தேர்ந்தெடுக்கவும். ORCA அதே மொழியில் முழு செயல்முறையையும் விளக்கும்.',
    'languageLabel': 'விளக்க மொழி',
    'chooseGuide': 'உங்கள் வழிகாட்டியை தேர்ந்தெடுக்கவும்',
    'listen': 'கேளுங்கள்',
    'stopListening': 'நிறுத்து',
    'previous': 'முந்தையது',
    'nextStep': 'அடுத்த படி',
    'finishGuide': 'வழிகாட்டி முடி',
    'stepLabel': 'படி',
    'voiceUnavailable': 'இந்த மொழிக்கான குரல் இந்த சாதனத்தில் கிடைக்கவில்லை.',
    'roles': {
      'FISHERMAN': {
        'title': 'மீனவர்',
        'subtitle': 'பாதுகாப்பான கடல் பயணம், ஆஃப்லைன் பயன்பாடு மற்றும் அவசர உதவிக்கான எளிய வழிகாட்டி.',
        'steps': [
          {
            'title': 'புறப்படும் முன் கடல் நிலையை பாருங்கள்',
            'description': 'பயணம் தொடங்குவதற்கு முன் அலைகள், காற்று, அலைச்சல், வானிலை மற்றும் முக்கிய கடல் எச்சரிக்கைகளை எளிதாக பார்க்கவும்.',
          },
          {
            'title': 'பாதுகாப்பான பயணத்தை திட்டமிடுங்கள்',
            'description': 'புறப்படும் மற்றும் திரும்பும் நேரத்தை கொடுக்கவும். ORCA பாதுகாப்பான பாதை, அருகிலுள்ள அபாயங்கள் மற்றும் எல்லை அபாயங்களை காட்ட முடியும்.',
          },
          {
            'title': 'Mission Pack ஐ ஆஃப்லைனில் வைத்திருங்கள்',
            'description': 'நெட்வொர்க் விட்டு செல்லும் முன் வரைபடம், route, alerts, geofences மற்றும் forecast தகவலை பதிவிறக்கவும்.',
          },
          {
            'title': 'தேவைப்படும் போது SOS பயன்படுத்துங்கள்',
            'description': 'ORCA உங்கள் coordinates, vessel மற்றும் mission details ஐ rescue team க்காக தயார் செய்து SOS அனுப்பப்பட்டதா, acknowledge ஆனதா அல்லது network க்காக காத்திருக்கிறதா என்பதை தெளிவாக காட்டும்.',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'கடல் ஆராய்ச்சியாளர்',
        'subtitle': 'Ocean data, anomalies, environmental suitability மற்றும் evidence பற்றிய தொழில்முறை பகுப்பாய்வு.',
        'steps': [
          {
            'title': 'Scientific data layers ஐ ஆராயுங்கள்',
            'description': 'SST, chlorophyll-a, significant wave height மற்றும் swell, wind, ocean currents, tides, bathymetry மற்றும் historical PFZ occurrence ஆகியவற்றை ஒரே research workspace இல் பார்க்கவும்.',
          },
          {
            'title': 'Area மற்றும் time window தேர்ந்தெடுக்கவும்',
            'description': 'Area of interest மற்றும் date range தேர்ந்தெடுத்து layers overlay செய்யவும், locations அல்லது periods ஒப்பிடவும், seasonal baselines மற்றும் anomalies ஆய்வு செய்யவும்.',
          },
          {
            'title': 'Productivity மற்றும் suitability ஆய்வு செய்யவும்',
            'description': 'SST, chlorophyll, fronts, currents மற்றும் PFZ history இடையேயான தொடர்புகளை ஆய்வு செய்யவும். Catch அல்லது CPUE data இல்லையெனில் ORCA biological causation என்று கூறாது; fishing suitability உடன் தொடர்புடைய environmental indicators ஐ மட்டும் காட்டும்.',
          },
          {
            'title': 'Evidence-backed outcomes உருவாக்கவும்',
            'description': 'Data provenance, freshness, validity மற்றும் confidence ஐ பரிசோதிக்கவும்; maps மற்றும் charts உருவாக்கவும்; conditions ஒப்பிட்டு evidence உடன் traceable research summary அல்லது report தயாரிக்கவும்.',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'கடலோர அதிகாரம் / மீட்பு',
        'subtitle': 'Hazards, SOS incidents, advisories மற்றும் geofenced safety க்கான operational awareness.',
        'steps': [
          {
            'title': 'கடல் அபாயங்களை கண்காணிக்கவும்',
            'description': 'Command map இல் high-wave conditions, bad weather, cyclone அல்லது lightning information, restricted areas மற்றும் geofenced risks பார்க்கவும்.',
          },
          {
            'title': 'Context உடன் SOS பெறவும்',
            'description': 'Coordinates உடன் fisherman identity, vessel information, persons onboard மற்றும் mission context பார்க்கவும்.',
          },
          {
            'title': 'Incident lifecycle நிர்வகிக்கவும்',
            'description': 'Incident ஐ acknowledge, assign, track மற்றும் resolve செய்து response teams கும் ஒரே operational status கிடைக்கச் செய்யவும்.',
          },
          {
            'title': 'Safety advisories அனுப்பவும்',
            'description': 'Geofences மற்றும் hazard areas நிர்வகித்து targeted warnings ஐ connected ORCA users க்கு அனுப்பவும்.',
          },
        ],
      },
      'ADMIN': {
        'title': 'நிர்வாகி',
        'subtitle': 'Users, data services, models மற்றும் system health க்கான restricted control.',
        'steps': [
          {
            'title': 'Users மற்றும் roles நிர்வகிக்கவும்',
            'description': 'Accounts மற்றும் role assignments பரிசோதித்து backend permissions மூலம் access ஐ பிரித்து பாதுகாக்கவும்.',
          },
          {
            'title': 'Data freshness கண்காணிக்கவும்',
            'description': 'Dataset மற்றும் API availability, update timestamps மற்றும் ingestion health பார்க்கவும்.',
          },
          {
            'title': 'Models மற்றும் agents கண்காணிக்கவும்',
            'description': 'Model versions, metrics, agent execution logs மற்றும் intelligence services பார்க்கவும்.',
          },
          {
            'title': 'Platform health பராமரிக்கவும்',
            'description': 'Backend services, geofence datasets மற்றும் platform status ஐ traceable முறையில் monitor செய்யவும்.',
          },
        ],
      },
    },
  },
  'kn': {
    'pageTitle': 'ORCA ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ',
    'pageSubtitle': 'ನಿಮ್ಮ ಭಾಷೆ ಮತ್ತು ಪಾತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ. ORCA ಅದೇ ಭಾಷೆಯಲ್ಲಿ ಸಂಪೂರ್ಣ ಪ್ರಕ್ರಿಯೆಯನ್ನು ವಿವರಿಸುತ್ತದೆ.',
    'languageLabel': 'ವಿವರಣೆ ಭಾಷೆ',
    'chooseGuide': 'ನಿಮ್ಮ ಮಾರ್ಗದರ್ಶಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
    'listen': 'ಕೇಳಿ',
    'stopListening': 'ನಿಲ್ಲಿಸಿ',
    'previous': 'ಹಿಂದಿನದು',
    'nextStep': 'ಮುಂದಿನ ಹಂತ',
    'finishGuide': 'ಮಾರ್ಗದರ್ಶಿ ಮುಗಿಸಿ',
    'stepLabel': 'ಹಂತ',
    'voiceUnavailable': 'ಈ ಭಾಷೆಯ ಧ್ವನಿ ಈ ಸಾಧನದಲ್ಲಿ ಲಭ್ಯವಿಲ್ಲ.',
    'roles': {
      'FISHERMAN': {
        'title': 'ಮೀನುಗಾರ',
        'subtitle': 'ಸುರಕ್ಷಿತ ಸಮುದ್ರ ಪ್ರಯಾಣ, ಆಫ್‌ಲೈನ್ ಬಳಕೆ ಮತ್ತು ತುರ್ತು ಸಹಾಯಕ್ಕಾಗಿ ಸರಳ ಮಾರ್ಗದರ್ಶನ.',
        'steps': [
          {
            'title': 'ಹೊರಡುವ ಮೊದಲು ಸಮುದ್ರ ಸ್ಥಿತಿ ನೋಡಿ',
            'description': 'ಪ್ರಯಾಣದ ಮೊದಲು ಅಲೆಗಳು, ಗಾಳಿ, ಜ್ವಾರ, ಹವಾಮಾನ ಮತ್ತು ಪ್ರಮುಖ ಸಮುದ್ರ ಎಚ್ಚರಿಕೆಗಳನ್ನು ಸರಳವಾಗಿ ನೋಡಿ.',
          },
          {
            'title': 'ಸುರಕ್ಷಿತ ಪ್ರಯಾಣವನ್ನು ಯೋಜಿಸಿ',
            'description': 'ಹೊರಡುವ ಮತ್ತು ಹಿಂದಿರುಗುವ ಸಮಯ ನೀಡಿ. ORCA ಸುರಕ್ಷಿತ ಮಾರ್ಗ, ಸಮೀಪದ ಅಪಾಯಗಳು ಮತ್ತು ಗಡಿ ಅಪಾಯಗಳನ್ನು ತೋರಿಸಬಹುದು.',
          },
          {
            'title': 'Mission Pack ಅನ್ನು ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿ ಇಡಿ',
            'description': 'ನೆಟ್‌ವರ್ಕ್ ಬಿಡುವ ಮೊದಲು ನಕ್ಷೆ, route, alerts, geofences ಮತ್ತು forecast ಮಾಹಿತಿಯನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ.',
          },
          {
            'title': 'ಅಗತ್ಯವಿದ್ದಾಗ SOS ಬಳಸಿ',
            'description': 'ORCA ನಿಮ್ಮ coordinates, vessel ಮತ್ತು mission details ಅನ್ನು rescue team ಗಾಗಿ ಸಿದ್ಧಪಡಿಸಿ SOS ಕಳುಹಿಸಲಾಯಿತೇ, acknowledge ಆಯಿತೇ ಅಥವಾ network ಗಾಗಿ ಕಾಯುತ್ತಿದೆಯೇ ಎಂದು ತೋರಿಸುತ್ತದೆ.',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'ಸಮುದ್ರ ಸಂಶೋಧಕ',
        'subtitle': 'Ocean data, anomalies, environmental suitability ಮತ್ತು evidence ಮೇಲೆ ವೃತ್ತಿಪರ ವಿಶ್ಲೇಷಣೆ.',
        'steps': [
          {
            'title': 'Scientific data layers ಪರಿಶೀಲಿಸಿ',
            'description': 'SST, chlorophyll-a, significant wave height ಮತ್ತು swell, wind, ocean currents, tides, bathymetry ಮತ್ತು historical PFZ occurrence ಅನ್ನು ಒಂದೇ research workspace ನಲ್ಲಿ ಪರಿಶೀಲಿಸಿ.',
          },
          {
            'title': 'Area ಮತ್ತು time window ಆಯ್ಕೆಮಾಡಿ',
            'description': 'Area of interest ಮತ್ತು date range ಆಯ್ಕೆಮಾಡಿ layers overlay ಮಾಡಿ, locations ಅಥವಾ periods compare ಮಾಡಿ, seasonal baselines ಮತ್ತು anomalies ಪರಿಶೀಲಿಸಿ.',
          },
          {
            'title': 'Productivity ಮತ್ತು suitability ವಿಶ್ಲೇಷಿಸಿ',
            'description': 'SST, chlorophyll, fronts, currents ಮತ್ತು PFZ history ನಡುವಿನ ಸಂಬಂಧಗಳನ್ನು ಅಧ್ಯಯನ ಮಾಡಿ. Catch ಅಥವಾ CPUE data ಇಲ್ಲದಿದ್ದರೆ ORCA biological causation ಎಂದು ಹೇಳುವುದಿಲ್ಲ; fishing suitability ಗೆ ಸಂಬಂಧಿಸಿದ environmental indicators ಅನ್ನು ಮಾತ್ರ ತೋರಿಸುತ್ತದೆ.',
          },
          {
            'title': 'Evidence-backed outcomes ತಯಾರಿಸಿ',
            'description': 'Data provenance, freshness, validity ಮತ್ತು confidence ಪರಿಶೀಲಿಸಿ; maps ಮತ್ತು charts ರಚಿಸಿ; conditions compare ಮಾಡಿ evidence ಜೊತೆಗೆ traceable research summary ಅಥವಾ report ತಯಾರಿಸಿ.',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'ಕರಾವಳಿ ಪ್ರಾಧಿಕಾರ / ರಕ್ಷಣೆ',
        'subtitle': 'Hazards, SOS incidents, advisories ಮತ್ತು geofenced safety ಗಾಗಿ operational awareness.',
        'steps': [
          {
            'title': 'ಸಮುದ್ರ ಅಪಾಯಗಳನ್ನು monitor ಮಾಡಿ',
            'description': 'Command map ನಲ್ಲಿ high-wave conditions, bad weather, cyclone ಅಥವಾ lightning information, restricted areas ಮತ್ತು geofenced risks ನೋಡಿ.',
          },
          {
            'title': 'Context ಜೊತೆಗೆ SOS ಸ್ವೀಕರಿಸಿ',
            'description': 'Coordinates ಜೊತೆಗೆ fisherman identity, vessel information, persons onboard ಮತ್ತು mission context ನೋಡಿ.',
          },
          {
            'title': 'Incident lifecycle ನಿರ್ವಹಿಸಿ',
            'description': 'Incident ಅನ್ನು acknowledge, assign, track ಮತ್ತು resolve ಮಾಡಿ response teams ಒಂದೇ operational status ನೋಡಲು ಅವಕಾಶ ಮಾಡಿಕೊಡಿ.',
          },
          {
            'title': 'Safety advisories ಕಳುಹಿಸಿ',
            'description': 'Geofences ಮತ್ತು hazard areas ನಿರ್ವಹಿಸಿ targeted warnings ಅನ್ನು connected ORCA users ಗೆ ಕಳುಹಿಸಿ.',
          },
        ],
      },
      'ADMIN': {
        'title': 'ಅಡ್ಮಿನ್',
        'subtitle': 'Users, data services, models ಮತ್ತು system health ಗಾಗಿ restricted control.',
        'steps': [
          {
            'title': 'Users ಮತ್ತು roles ನಿರ್ವಹಿಸಿ',
            'description': 'Accounts ಮತ್ತು role assignments ಪರಿಶೀಲಿಸಿ backend permissions ಮೂಲಕ access ಅನ್ನು ಬೇರ್ಪಡಿಸಿ.',
          },
          {
            'title': 'Data freshness monitor ಮಾಡಿ',
            'description': 'Dataset ಮತ್ತು API availability, update timestamps ಮತ್ತು ingestion health ಪರಿಶೀಲಿಸಿ.',
          },
          {
            'title': 'Models ಮತ್ತು agents monitor ಮಾಡಿ',
            'description': 'Model versions, metrics, agent execution logs ಮತ್ತು intelligence services ಪರಿಶೀಲಿಸಿ.',
          },
          {
            'title': 'Platform health ಕಾಪಾಡಿ',
            'description': 'Backend services, geofence datasets ಮತ್ತು platform status ಅನ್ನು traceable ರೀತಿಯಲ್ಲಿ monitor ಮಾಡಿ.',
          },
        ],
      },
    },
  },
  'ml': {
    'pageTitle': 'ORCA എങ്ങനെ പ്രവർത്തിക്കുന്നു',
    'pageSubtitle': 'നിങ്ങളുടെ ഭാഷയും റോളും തിരഞ്ഞെടുക്കുക. ORCA അതേ ഭാഷയിൽ മുഴുവൻ പ്രവൃത്തി രീതിയും വിശദീകരിക്കും.',
    'languageLabel': 'വിശദീകരണ ഭാഷ',
    'chooseGuide': 'നിങ്ങളുടെ ഗൈഡ് തിരഞ്ഞെടുക്കുക',
    'listen': 'കേൾക്കുക',
    'stopListening': 'നിർത്തുക',
    'previous': 'മുൻപത്തെ',
    'nextStep': 'അടുത്ത ഘട്ടം',
    'finishGuide': 'ഗൈഡ് പൂർത്തിയാക്കുക',
    'stepLabel': 'ഘട്ടം',
    'voiceUnavailable': 'ഈ ഭാഷയ്ക്കുള്ള ശബ്ദം ഈ ഉപകരണത്തിൽ ലഭ്യമല്ല.',
    'roles': {
      'FISHERMAN': {
        'title': 'മത്സ്യത്തൊഴിലാളി',
        'subtitle': 'സുരക്ഷിത കടൽ യാത്ര, ഓഫ്‌ലൈൻ ഉപയോഗം, അടിയന്തര സഹായം എന്നിവയ്ക്കുള്ള ലളിതമായ മാർഗ്ഗനിർദേശം.',
        'steps': [
          {
            'title': 'പുറപ്പെടും മുമ്പ് കടൽ സ്ഥിതി പരിശോധിക്കുക',
            'description': 'യാത്ര ആരംഭിക്കുന്നതിന് മുമ്പ് തിരമാല, കാറ്റ്, ടൈഡ്, കാലാവസ്ഥ, പ്രധാന കടൽ മുന്നറിയിപ്പുകൾ എന്നിവ ലളിതമായി കാണുക.',
          },
          {
            'title': 'കൂടുതൽ സുരക്ഷിതമായ യാത്ര പ്ലാൻ ചെയ്യുക',
            'description': 'പുറപ്പെടുന്ന സമയവും മടങ്ങുന്ന സമയവും നൽകുക. ORCA സുരക്ഷിതമായ മാർഗ്ഗം, സമീപ അപകടങ്ങൾ, അതിർത്തി അപകടങ്ങൾ എന്നിവ കാണിക്കാം.',
          },
          {
            'title': 'Mission Pack ഓഫ്‌ലൈൻ സൂക്ഷിക്കുക',
            'description': 'നെറ്റ്‌വർക്ക് വിടുന്നതിന് മുമ്പ് മാപ്പ്, route, alerts, geofences, forecast വിവരങ്ങൾ എന്നിവ ഡൗൺലോഡ് ചെയ്യുക.',
          },
          {
            'title': 'ആവശ്യമായപ്പോൾ SOS ഉപയോഗിക്കുക',
            'description': 'ORCA coordinates, vessel, mission details എന്നിവ rescue team നായി തയ്യാറാക്കുകയും SOS അയച്ചോ, acknowledge ചെയ്തോ, network കാത്തിരിക്കുകയോ എന്നത് വ്യക്തമായി കാണിക്കുകയും ചെയ്യും.',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'മറൈൻ ഗവേഷകൻ',
        'subtitle': 'Ocean data, anomalies, environmental suitability, evidence എന്നിവയുടെ പ്രൊഫഷണൽ വിശകലനം.',
        'steps': [
          {
            'title': 'Scientific data layers പരിശോധിക്കുക',
            'description': 'SST, chlorophyll-a, significant wave height, swell, wind, ocean currents, tides, bathymetry, historical PFZ occurrence എന്നിവ ഒരേ research workspace ൽ പരിശോധിക്കുക.',
          },
          {
            'title': 'Areaയും time windowഉം തിരഞ്ഞെടുക്കുക',
            'description': 'Area of interest, date range എന്നിവ തിരഞ്ഞെടുത്ത് layers overlay ചെയ്യുക, locations അല്ലെങ്കിൽ periods compare ചെയ്യുക, seasonal baselines, anomalies പരിശോധിക്കുക.',
          },
          {
            'title': 'Productivityയും suitabilityയും പഠിക്കുക',
            'description': 'SST, chlorophyll, fronts, currents, PFZ history എന്നിവ തമ്മിലുള്ള ബന്ധം പരിശോധിക്കുക. Catch അല്ലെങ്കിൽ CPUE data ഇല്ലെങ്കിൽ ORCA biological causation അവകാശപ്പെടില്ല; fishing suitability നോട് ബന്ധപ്പെട്ട environmental indicators മാത്രമേ റിപ്പോർട്ട് ചെയ്യൂ.',
          },
          {
            'title': 'Evidence-backed outcomes സൃഷ്ടിക്കുക',
            'description': 'Data provenance, freshness, validity, confidence പരിശോധിക്കുക; maps, charts സൃഷ്ടിക്കുക; conditions compare ചെയ്ത് evidence സഹിതം traceable research summary അല്ലെങ്കിൽ report തയ്യാറാക്കുക.',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'തീര അതോറിറ്റി / രക്ഷാപ്രവർത്തനം',
        'subtitle': 'Hazards, SOS incidents, advisories, geofenced safety എന്നിവയ്ക്കുള്ള operational awareness.',
        'steps': [
          {
            'title': 'കടൽ അപകടങ്ങൾ monitor ചെയ്യുക',
            'description': 'Command map ൽ high-wave conditions, bad weather, cyclone അല്ലെങ്കിൽ lightning information, restricted areas, geofenced risks കാണുക.',
          },
          {
            'title': 'Context സഹിതം SOS ലഭിക്കുക',
            'description': 'Coordinates നൊപ്പം fisherman identity, vessel information, persons onboard, mission context എന്നിവ കാണുക.',
          },
          {
            'title': 'Incident lifecycle നിയന്ത്രിക്കുക',
            'description': 'Incident acknowledge, assign, track, resolve ചെയ്ത് response teams നും ഒരേ operational status ലഭ്യമാക്കുക.',
          },
          {
            'title': 'Safety advisories അയയ്ക്കുക',
            'description': 'Geofences, hazard areas എന്നിവ നിയന്ത്രിച്ച് targeted warnings connected ORCA users ലേക്ക് അയയ്ക്കുക.',
          },
        ],
      },
      'ADMIN': {
        'title': 'അഡ്മിൻ',
        'subtitle': 'Users, data services, models, system health എന്നിവയ്ക്കുള്ള restricted control.',
        'steps': [
          {
            'title': 'Users, roles നിയന്ത്രിക്കുക',
            'description': 'Accounts, role assignments പരിശോധിച്ച് backend permissions വഴി access വേർതിരിച്ച് സുരക്ഷിതമാക്കുക.',
          },
          {
            'title': 'Data freshness monitor ചെയ്യുക',
            'description': 'Dataset, API availability, update timestamps, ingestion health എന്നിവ പരിശോധിക്കുക.',
          },
          {
            'title': 'Models, agents monitor ചെയ്യുക',
            'description': 'Model versions, metrics, agent execution logs, intelligence services എന്നിവ പരിശോധിക്കുക.',
          },
          {
            'title': 'Platform health നിലനിർത്തുക',
            'description': 'Backend services, geofence datasets, platform status എന്നിവ traceable ആയി monitor ചെയ്യുക.',
          },
        ],
      },
    },
  },
  'bn': {
    'pageTitle': 'ORCA কীভাবে কাজ করে',
    'pageSubtitle': 'আপনার ভাষা এবং ভূমিকা বেছে নিন। ORCA একই ভাষায় সম্পূর্ণ প্রক্রিয়া ব্যাখ্যা করবে।',
    'languageLabel': 'ব্যাখ্যার ভাষা',
    'chooseGuide': 'আপনার গাইড বেছে নিন',
    'listen': 'শুনুন',
    'stopListening': 'বন্ধ করুন',
    'previous': 'পূর্ববর্তী',
    'nextStep': 'পরবর্তী ধাপ',
    'finishGuide': 'গাইড শেষ করুন',
    'stepLabel': 'ধাপ',
    'voiceUnavailable': 'এই ভাষার ভয়েস এই ডিভাইসে ইনস্টল করা নেই।',
    'roles': {
      'FISHERMAN': {
        'title': 'মৎস্যজীবী',
        'subtitle': 'নিরাপদ সমুদ্রযাত্রা, অফলাইন ব্যবহার এবং জরুরি সহায়তার জন্য সহজ নির্দেশনা।',
        'steps': [
          {
            'title': 'রওনা হওয়ার আগে সমুদ্রের অবস্থা দেখুন',
            'description': 'যাত্রার আগে ঢেউ, বাতাস, জোয়ার, আবহাওয়া এবং গুরুত্বপূর্ণ সামুদ্রিক সতর্কতা সহজভাবে দেখুন।',
          },
          {
            'title': 'আরও নিরাপদ যাত্রা পরিকল্পনা করুন',
            'description': 'যাত্রা ও ফেরার সময় দিন। ORCA নিরাপদ route, কাছাকাছি ঝুঁকি এবং সীমান্ত ঝুঁকি দেখাতে পারে।',
          },
          {
            'title': 'Mission Pack অফলাইনে রাখুন',
            'description': 'নেটওয়ার্ক ছাড়ার আগে মানচিত্র, route, alerts, geofences এবং forecast তথ্য ডাউনলোড করুন।',
          },
          {
            'title': 'প্রয়োজনে SOS ব্যবহার করুন',
            'description': 'ORCA আপনার coordinates, vessel এবং mission details rescue team এর জন্য প্রস্তুত করে এবং SOS পাঠানো, acknowledge হওয়া বা network অপেক্ষায় থাকা স্পষ্ট দেখায়।',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'সামুদ্রিক গবেষক',
        'subtitle': 'Ocean data, anomalies, environmental suitability এবং evidence-এর পেশাদার বিশ্লেষণ।',
        'steps': [
          {
            'title': 'Scientific data layers বিশ্লেষণ করুন',
            'description': 'SST, chlorophyll-a, significant wave height ও swell, wind, ocean currents, tides, bathymetry এবং historical PFZ occurrence এক research workspace-এ দেখুন।',
          },
          {
            'title': 'Area ও time window নির্বাচন করুন',
            'description': 'Area of interest ও date range নির্বাচন করে layers overlay করুন, locations বা periods compare করুন, seasonal baselines ও anomalies দেখুন।',
          },
          {
            'title': 'Productivity ও suitability তদন্ত করুন',
            'description': 'SST, chlorophyll, fronts, currents এবং PFZ history-এর সম্পর্ক বিশ্লেষণ করুন। Catch বা CPUE data না থাকলে ORCA biological causation দাবি করবে না; fishing suitability-এর সঙ্গে যুক্ত environmental indicators দেখাবে।',
          },
          {
            'title': 'Evidence-backed outcomes তৈরি করুন',
            'description': 'Data provenance, freshness, validity ও confidence দেখুন; maps ও charts তৈরি করুন; conditions compare করুন; এবং evidence সহ traceable research summary বা report প্রস্তুত করুন।',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'উপকূলীয় কর্তৃপক্ষ / উদ্ধার',
        'subtitle': 'Hazards, SOS incidents, advisories এবং geofenced safety-এর জন্য operational awareness.',
        'steps': [
          {
            'title': 'সামুদ্রিক ঝুঁকি monitor করুন',
            'description': 'Command map-এ high-wave conditions, bad weather, cyclone বা lightning information, restricted areas এবং geofenced risks দেখুন।',
          },
          {
            'title': 'Context সহ SOS গ্রহণ করুন',
            'description': 'Coordinates-এর সঙ্গে fisherman identity, vessel information, persons onboard এবং mission context দেখুন।',
          },
          {
            'title': 'Incident lifecycle পরিচালনা করুন',
            'description': 'Incident acknowledge, assign, track এবং resolve করুন যাতে response teams একই operational status দেখে।',
          },
          {
            'title': 'Safety advisories পাঠান',
            'description': 'Geofences ও hazard areas manage করে targeted warnings connected ORCA users-এর কাছে পাঠান।',
          },
        ],
      },
      'ADMIN': {
        'title': 'অ্যাডমিন',
        'subtitle': 'Users, data services, models এবং system health-এর restricted control.',
        'steps': [
          {
            'title': 'Users ও roles manage করুন',
            'description': 'Accounts ও role assignments পর্যালোচনা করে backend permissions-এর মাধ্যমে access আলাদা রাখুন।',
          },
          {
            'title': 'Data freshness monitor করুন',
            'description': 'Dataset ও API availability, update timestamps এবং ingestion health দেখুন।',
          },
          {
            'title': 'Models ও agents monitor করুন',
            'description': 'Model versions, metrics, agent execution logs এবং intelligence services দেখুন।',
          },
          {
            'title': 'Platform health বজায় রাখুন',
            'description': 'Backend services, geofence datasets এবং platform status traceableভাবে monitor করুন।',
          },
        ],
      },
    },
  },
  'or': {
    'pageTitle': 'ORCA କିପରି କାମ କରେ',
    'pageSubtitle': 'ଆପଣଙ୍କ ଭାଷା ଏବଂ ଭୂମିକା ବାଛନ୍ତୁ। ORCA ସେହି ଭାଷାରେ ସମ୍ପୂର୍ଣ୍ଣ ପ୍ରକ୍ରିୟା ବୁଝାଇବ।',
    'languageLabel': 'ବ୍ୟାଖ୍ୟା ଭାଷା',
    'chooseGuide': 'ଆପଣଙ୍କ ଗାଇଡ୍ ବାଛନ୍ତୁ',
    'listen': 'ଶୁଣନ୍ତୁ',
    'stopListening': 'ବନ୍ଦ କରନ୍ତୁ',
    'previous': 'ପୂର୍ବବର୍ତ୍ତୀ',
    'nextStep': 'ପରବର୍ତ୍ତୀ ପଦକ୍ଷେପ',
    'finishGuide': 'ଗାଇଡ୍ ସମାପ୍ତ କରନ୍ତୁ',
    'stepLabel': 'ପଦକ୍ଷେପ',
    'voiceUnavailable': 'ଏହି ଭାଷା ପାଇଁ ଭଏସ୍ ଏହି ଡିଭାଇସ୍‌ରେ ଉପଲବ୍ଧ ନାହିଁ।',
    'roles': {
      'FISHERMAN': {
        'title': 'ମାଛ ଧରୁଥିବା ବ୍ୟକ୍ତି',
        'subtitle': 'ନିରାପଦ ସମୁଦ୍ର ଯାତ୍ରା, ଅଫଲାଇନ୍ ବ୍ୟବହାର ଏବଂ ଆପତ୍କାଳୀନ ସହାୟତା ପାଇଁ ସରଳ ମାର୍ଗଦର୍ଶନ।',
        'steps': [
          {
            'title': 'ବାହାରିବା ପୂର୍ବରୁ ସମୁଦ୍ର ଅବସ୍ଥା ଦେଖନ୍ତୁ',
            'description': 'ଯାତ୍ରା ପୂର୍ବରୁ ତରଙ୍ଗ, ପବନ, ଜ୍ୱାର, ପାଣିପାଗ ଏବଂ ମୁଖ୍ୟ ସମୁଦ୍ର ସତର୍କତା ସହଜରେ ଦେଖନ୍ତୁ।',
          },
          {
            'title': 'ଅଧିକ ନିରାପଦ ଯାତ୍ରା ପ୍ରସ୍ତୁତ କରନ୍ତୁ',
            'description': 'ବାହାରିବା ଏବଂ ଫେରିବା ସମୟ ଦିଅନ୍ତୁ। ORCA ନିରାପଦ route, ନିକଟସ୍ଥ ବିପଦ ଏବଂ boundary risk ଦେଖାଇପାରେ।',
          },
          {
            'title': 'Mission Pack ଅଫଲାଇନ୍ ରଖନ୍ତୁ',
            'description': 'ନେଟୱର୍କ ଛାଡ଼ିବା ପୂର୍ବରୁ map, route, alerts, geofences ଏବଂ forecast information ଡାଉନଲୋଡ୍ କରନ୍ତୁ।',
          },
          {
            'title': 'ଆବଶ୍ୟକତାରେ SOS ବ୍ୟବହାର କରନ୍ତୁ',
            'description': 'ORCA ଆପଣଙ୍କ coordinates, vessel ଏବଂ mission details rescue team ପାଇଁ ପ୍ରସ୍ତୁତ କରେ ଏବଂ SOS ପଠାଯାଇଛି, acknowledge ହୋଇଛି କିମ୍ବା network ଅପେକ୍ଷାରେ ଅଛି କି ଦେଖାଏ।',
          },
        ],
      },
      'RESEARCHER': {
        'title': 'ସମୁଦ୍ର ଗବେଷକ',
        'subtitle': 'Ocean data, anomalies, environmental suitability ଏବଂ evidence ର ପେଶାଦାର ବିଶ୍ଳେଷଣ।',
        'steps': [
          {
            'title': 'Scientific data layers ଅନୁସନ୍ଧାନ କରନ୍ତୁ',
            'description': 'SST, chlorophyll-a, significant wave height ଏବଂ swell, wind, ocean currents, tides, bathymetry ଏବଂ historical PFZ occurrence କୁ ଏକ research workspace ରେ ଦେଖନ୍ତୁ।',
          },
          {
            'title': 'Area ଏବଂ time window ବାଛନ୍ତୁ',
            'description': 'Area of interest ଏବଂ date range ବାଛି layers overlay କରନ୍ତୁ, locations କିମ୍ବା periods compare କରନ୍ତୁ, seasonal baselines ଏବଂ anomalies ଅନୁସନ୍ଧାନ କରନ୍ତୁ।',
          },
          {
            'title': 'Productivity ଏବଂ suitability ଅନୁସନ୍ଧାନ କରନ୍ତୁ',
            'description': 'SST, chlorophyll, fronts, currents ଏବଂ PFZ history ମଧ୍ୟରେ ସମ୍ପର୍କ ଅଧ୍ୟୟନ କରନ୍ତୁ। Catch କିମ୍ବା CPUE data ନଥିଲେ ORCA biological causation କହିବ ନାହିଁ; fishing suitability ସହିତ ସମ୍ବନ୍ଧିତ environmental indicators ଦେଖାଇବ।',
          },
          {
            'title': 'Evidence-backed outcomes ତିଆରି କରନ୍ତୁ',
            'description': 'Data provenance, freshness, validity ଏବଂ confidence ଦେଖନ୍ତୁ; maps ଏବଂ charts ତିଆରି କରନ୍ତୁ; conditions compare କରନ୍ତୁ; evidence ସହିତ traceable research summary କିମ୍ବା report ପ୍ରସ୍ତୁତ କରନ୍ତୁ।',
          },
        ],
      },
      'AUTHORITY': {
        'title': 'ତଟୀୟ କର୍ତ୍ତୃପକ୍ଷ / ଉଦ୍ଧାର',
        'subtitle': 'Hazards, SOS incidents, advisories ଏବଂ geofenced safety ପାଇଁ operational awareness.',
        'steps': [
          {
            'title': 'ସମୁଦ୍ର ବିପଦ monitor କରନ୍ତୁ',
            'description': 'Command map ରେ high-wave conditions, bad weather, cyclone କିମ୍ବା lightning information, restricted areas ଏବଂ geofenced risks ଦେଖନ୍ତୁ।',
          },
          {
            'title': 'Context ସହିତ SOS ପାଆନ୍ତୁ',
            'description': 'Coordinates ସହିତ fisherman identity, vessel information, persons onboard ଏବଂ mission context ଦେଖନ୍ତୁ।',
          },
          {
            'title': 'Incident lifecycle manage କରନ୍ତୁ',
            'description': 'Incident acknowledge, assign, track ଏବଂ resolve କରନ୍ତୁ ଯାହାରେ response teams ଏକେ operational status ଦେଖନ୍ତି।',
          },
          {
            'title': 'Safety advisories ପଠାନ୍ତୁ',
            'description': 'Geofences ଏବଂ hazard areas manage କରି targeted warnings connected ORCA users କୁ ପଠାନ୍ତୁ।',
          },
        ],
      },
      'ADMIN': {
        'title': 'ଅ୍ୟାଡମିନ୍',
        'subtitle': 'Users, data services, models ଏବଂ system health ପାଇଁ restricted control.',
        'steps': [
          {
            'title': 'Users ଏବଂ roles manage କରନ୍ତୁ',
            'description': 'Accounts ଏବଂ role assignments ଦେଖି backend permissions ଦ୍ୱାରା access ଅଲଗା ଏବଂ ସୁରକ୍ଷିତ ରଖନ୍ତୁ।',
          },
          {
            'title': 'Data freshness monitor କରନ୍ତୁ',
            'description': 'Dataset ଏବଂ API availability, update timestamps ଏବଂ ingestion health ଦେଖନ୍ତୁ।',
          },
          {
            'title': 'Models ଏବଂ agents monitor କରନ୍ତୁ',
            'description': 'Model versions, metrics, agent execution logs ଏବଂ intelligence services ଦେଖନ୍ତୁ।',
          },
          {
            'title': 'Platform health ରଖନ୍ତୁ',
            'description': 'Backend services, geofence datasets ଏବଂ platform status କୁ traceable ଭାବରେ monitor କରନ୍ତୁ।',
          },
        ],
      },
    },
  },
};
