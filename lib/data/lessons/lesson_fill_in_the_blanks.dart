import '../../config/content_ids.dart';

/// Lesson data for "Fill in the Blanks".
/// Part of the app's bundled content store (see `lib/data/journey_data.dart`).
final Map<String, dynamic> lessonFillInBlank = {
  'id': ContentIds.fillInBlank,
  'title': 'Fill in the Blanks',
  'order': 6,
  'visible': true,
  'shuffleSections': true,
  'shuffleTasks': true,
  'sections': [
    {
      'id': 'section_fb_animals',
      'title': 'Animals',
      'tasks': [
        {
          'id': 'fb_an_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸ਼ੇਰ', 'ਜੰਗਲ', 'ਦਾ', '___', 'ਹੈ'],
            'correctWord': 'ਰਾਜਾ',
            'options': ['ਰਾਜਾ', 'ਦੋਸਤ', 'ਹਾਥੀ'],
          },
        },
        {
          'id': 'fb_an_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਗਾਂ', 'ਸਾਨੂੰ', '___', 'ਦਿੰਦੀ', 'ਹੈ'],
            'correctWord': 'ਦੁੱਧ',
            'options': ['ਦੁੱਧ', 'ਪਾਣੀ', 'ਘਾਹ'],
          },
        },
        {
          'id': 'fb_an_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਕੁੱਤਾ', 'ਘਰ', 'ਦੀ', '___', 'ਕਰਦਾ', 'ਹੈ'],
            'correctWord': 'ਰਾਖੀ',
            'options': ['ਰਾਖੀ', 'ਸਫਾਈ', 'ਖੇਤੀ'],
          },
        },
        {
          'id': 'fb_an_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਬਿੱਲੀ', '___', 'ਫੜਦੀ', 'ਹੈ'],
            'correctWord': 'ਚੂਹੇ',
            'options': ['ਚੂਹੇ', 'ਪੰਛੀ', 'ਕੁੱਤੇ'],
          },
        },
        {
          'id': 'fb_an_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਘੋੜਾ', 'ਬਹੁਤ', '___', 'ਦੌੜਦਾ', 'ਹੈ'],
            'correctWord': 'ਤੇਜ਼',
            'options': ['ਤੇਜ਼', 'ਹੌਲੀ', 'ਉੱਚਾ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_household',
      'title': 'Everyday Objects & Household',
      'tasks': [
        {
          'id': 'fb_ho_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', '___', 'ਨਾਲ', 'ਪਾਣੀ', 'ਪੀਂਦਾ', 'ਹਾਂ'],
            'correctWord': 'ਗਲਾਸ',
            'options': ['ਗਲਾਸ', 'ਥਾਲੀ', 'ਚਮਚ'],
          },
        },
        {
          'id': 'fb_ho_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੰਮੀ', '___', 'ਵਿੱਚ', 'ਰੋਟੀ', 'ਬਣਾਉਂਦੇ', 'ਹਨ'],
            'correctWord': 'ਰਸੋਈ',
            'options': ['ਰਸੋਈ', 'ਕਮਰੇ', 'ਬਾਗ'],
          },
        },
        {
          'id': 'fb_ho_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਅਸੀਂ', '___', 'ਉੱਤੇ', 'ਬੈਠਦੇ', 'ਹਾਂ'],
            'correctWord': 'ਕੁਰਸੀ',
            'options': ['ਕੁਰਸੀ', 'ਮੇਜ਼', 'ਪੱਖੇ'],
          },
        },
        {
          'id': 'fb_ho_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਦੀਵਾਰ', 'ਉੱਤੇ', '___', 'ਲੱਗੀ', 'ਹੈ'],
            'correctWord': 'ਘੜੀ',
            'options': ['ਘੜੀ', 'ਦਰੀ', 'ਬਾਲਟੀ'],
          },
        },
        {
          'id': 'fb_ho_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', '___', 'ਨਾਲ', 'ਦਰਵਾਜ਼ਾ', 'ਖੋਲ੍ਹਿਆ'],
            'correctWord': 'ਚਾਬੀ',
            'options': ['ਚਾਬੀ', 'ਕੰਘੀ', 'ਸਾਬਣ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_fruits',
      'title': 'Fruits',
      'tasks': [
        {
          'id': 'fb_fr_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਅੰਬ', 'ਫਲਾਂ', 'ਦਾ', '___', 'ਹੈ'],
            'correctWord': 'ਰਾਜਾ',
            'options': ['ਰਾਜਾ', 'ਮੰਤਰੀ', 'ਸਿਪਾਹੀ'],
          },
        },
        {
          'id': 'fb_fr_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਕੇਲਾ', '___', 'ਰੰਗ', 'ਦਾ', 'ਹੁੰਦਾ', 'ਹੈ'],
            'correctWord': 'ਪੀਲੇ',
            'options': ['ਪੀਲੇ', 'ਲਾਲ', 'ਨੀਲੇ'],
          },
        },
        {
          'id': 'fb_fr_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸੇਬ', 'ਖਾਣ', 'ਨਾਲ', '___', 'ਬਣਦੀ', 'ਹੈ'],
            'correctWord': 'ਸਿਹਤ',
            'options': ['ਸਿਹਤ', 'ਨੀਂਦ', 'ਭੁੱਖ'],
          },
        },
        {
          'id': 'fb_fr_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਅੰਗੂਰ', '___', 'ਹੁੰਦੇ', 'ਹਨ'],
            'correctWord': 'ਖੱਟੇ-ਮਿੱਠੇ',
            'options': ['ਖੱਟੇ-ਮਿੱਠੇ', 'ਕੌੜੇ', 'ਨਮਕੀਨ'],
          },
        },
        {
          'id': 'fb_fr_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਤਰਬੂਜ਼', 'ਅੰਦਰੋਂ', '___', 'ਹੁੰਦਾ', 'ਹੈ'],
            'correctWord': 'ਲਾਲ',
            'options': ['ਲਾਲ', 'ਹਰਾ', 'ਚਿੱਟਾ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_colors',
      'title': 'Colors',
      'tasks': [
        {
          'id': 'fb_cl_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਟਮਾਟਰ', '___', 'ਰੰਗ', 'ਦਾ', 'ਹੈ'],
            'correctWord': 'ਲਾਲ',
            'options': ['ਲਾਲ', 'ਨੀਲਾ', 'ਕਾਲਾ'],
          },
        },
        {
          'id': 'fb_cl_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਤੋਤਾ', '___', 'ਹੁੰਦਾ', 'ਹੈ'],
            'correctWord': 'ਹਰਾ',
            'options': ['ਹਰਾ', 'ਪੀਲਾ', 'ਗੁਲਾਬੀ'],
          },
        },
        {
          'id': 'fb_cl_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸਾਡੇ', 'ਵਾਲ', '___', 'ਹਨ'],
            'correctWord': 'ਕਾਲੇ',
            'options': ['ਕਾਲੇ', 'ਚਿੱਟੇ', 'ਭੂਰੇ'],
          },
        },
        {
          'id': 'fb_cl_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਦੁੱਧ', 'ਦਾ', 'ਰੰਗ', '___', 'ਹੈ'],
            'correctWord': 'ਚਿੱਟਾ',
            'options': ['ਚਿੱਟਾ', 'ਕਾਲਾ', 'ਨੀਲਾ'],
          },
        },
        {
          'id': 'fb_cl_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਬੈਂਗਣ', '___', 'ਰੰਗ', 'ਦਾ', 'ਹੈ'],
            'correctWord': 'ਜਾਮਣੀ',
            'options': ['ਜਾਮਣੀ', 'ਸੰਤਰੀ', 'ਲਾਲ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_transport',
      'title': 'Travel & Transport',
      'tasks': [
        {
          'id': 'fb_tr_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਰੇਲਗੱਡੀ', '___', 'ਉੱਤੇ', 'ਚੱਲਦੀ', 'ਹੈ'],
            'correctWord': 'ਪਟੜੀ',
            'options': ['ਪਟੜੀ', 'ਸੜਕ', 'ਪਾਣੀ'],
          },
        },
        {
          'id': 'fb_tr_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਹਵਾਈ', 'ਜਹਾਜ਼', '___', 'ਵਿੱਚ', 'ਉੱਡਦਾ', 'ਹੈ'],
            'correctWord': 'ਅਸਮਾਨ',
            'options': ['ਅਸਮਾਨ', 'ਸਮੁੰਦਰ', 'ਜੰਗਲ'],
          },
        },
        {
          'id': 'fb_tr_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਕਾਰ', 'ਦੇ', 'ਚਾਰ', '___', 'ਹੁੰਦੇ', 'ਹਨ'],
            'correctWord': 'ਪਹੀਏ',
            'options': ['ਪਹੀਏ', 'ਦਰਵਾਜ਼ੇ', 'ਸ਼ੀਸ਼ੇ'],
          },
        },
        {
          'id': 'fb_tr_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸਾਈਕਲ', 'ਚਲਾਉਣਾ', '___', 'ਲਈ', 'ਚੰਗਾ', 'ਹੈ'],
            'correctWord': 'ਸਿਹਤ',
            'options': ['ਸਿਹਤ', 'ਨੀਂਦ', 'ਪੜ੍ਹਾਈ'],
          },
        },
        {
          'id': 'fb_tr_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਬੱਸ', '___', 'ਉੱਤੇ', 'ਰੁਕਦੀ', 'ਹੈ'],
            'correctWord': 'ਅੱਡੇ',
            'options': ['ਅੱਡੇ', 'ਘਰ', 'ਛੱਤ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_school',
      'title': 'School',
      'tasks': [
        {
          'id': 'fb_sc_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', '___', 'ਵਿੱਚ', 'ਪੜ੍ਹਦਾ', 'ਹਾਂ'],
            'correctWord': 'ਸਕੂਲ',
            'options': ['ਸਕੂਲ', 'ਬਾਜ਼ਾਰ', 'ਖੇਤ'],
          },
        },
        {
          'id': 'fb_sc_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['___', 'ਸਾਨੂੰ', 'ਪੜ੍ਹਾਉਂਦੇ', 'ਹਨ'],
            'correctWord': 'ਅਧਿਆਪਕ',
            'options': ['ਅਧਿਆਪਕ', 'ਡਾਕਟਰ', 'ਕਿਸਾਨ'],
          },
        },
        {
          'id': 'fb_sc_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', 'ਆਪਣੇ', '___', 'ਵਿੱਚ', 'ਕਿਤਾਬਾਂ', 'ਰੱਖਦਾ', 'ਹਾਂ'],
            'correctWord': 'ਬਸਤੇ',
            'options': ['ਬਸਤੇ', 'ਡੱਬੇ', 'ਜੇਬ'],
          },
        },
        {
          'id': 'fb_sc_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਅਸੀਂ', '___', 'ਨਾਲ', 'ਲਿਖਦੇ', 'ਹਾਂ'],
            'correctWord': 'ਕਲਮ',
            'options': ['ਕਲਮ', 'ਰਬੜ', 'ਫੁੱਟੇ'],
          },
        },
        {
          'id': 'fb_sc_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸਕੂਲ', 'ਵਿੱਚ', 'ਇੱਕ', 'ਵੱਡਾ', '___', 'ਹੈ'],
            'correctWord': 'ਮੈਦਾਨ',
            'options': ['ਮੈਦਾਨ', 'ਕਮਰਾ', 'ਦਰਵਾਜ਼ਾ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_weather',
      'title': 'Weather',
      'tasks': [
        {
          'id': 'fb_we_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਅੱਜ', 'ਬਹੁਤ', '___', 'ਹੈ'],
            'correctWord': 'ਗਰਮੀ',
            'options': ['ਗਰਮੀ', 'ਮਿੱਠਾ', 'ਨੀਲਾ'],
          },
        },
        {
          'id': 'fb_we_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਬੱਦਲ', '___', 'ਪਾਉਂਦੇ', 'ਹਨ'],
            'correctWord': 'ਮੀਂਹ',
            'options': ['ਮੀਂਹ', 'ਧੁੱਪ', 'ਹਵਾ'],
          },
        },
        {
          'id': 'fb_we_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸਰਦੀਆਂ', 'ਵਿੱਚ', '___', 'ਲੱਗਦੀ', 'ਹੈ'],
            'correctWord': 'ਠੰਢ',
            'options': ['ਠੰਢ', 'ਪਿਆਸ', 'ਭੁੱਖ'],
          },
        },
        {
          'id': 'fb_we_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸੂਰਜ', '___', 'ਦਿੰਦਾ', 'ਹੈ'],
            'correctWord': 'ਧੁੱਪ',
            'options': ['ਧੁੱਪ', 'ਛਾਂ', 'ਠੰਢ'],
          },
        },
        {
          'id': 'fb_we_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਤੇਜ਼', '___', 'ਚੱਲ', 'ਰਹੀ', 'ਹੈ'],
            'correctWord': 'ਹਵਾ',
            'options': ['ਹਵਾ', 'ਨਦੀ', 'ਸੜਕ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_clothes',
      'title': 'Clothes',
      'tasks': [
        {
          'id': 'fb_ct_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', 'ਨਵੀਂ', '___', 'ਪਾਈ', 'ਹੈ'],
            'correctWord': 'ਕਮੀਜ਼',
            'options': ['ਕਮੀਜ਼', 'ਜੁੱਤੀ', 'ਟੋਪੀ'],
          },
        },
        {
          'id': 'fb_ct_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸਰਦੀ', 'ਵਿੱਚ', '___', 'ਪਾਓ'],
            'correctWord': 'ਕੋਟ',
            'options': ['ਕੋਟ', 'ਨਿੱਕਰ', 'ਕੁੜਤਾ'],
          },
        },
        {
          'id': 'fb_ct_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੇਰੀ', '___', 'ਨੀਲੇ', 'ਰੰਗ', 'ਦੀ', 'ਹੈ'],
            'correctWord': 'ਪੱਗ',
            'options': ['ਪੱਗ', 'ਪੈਨਸਿਲ', 'ਚਾਬੀ'],
          },
        },
        {
          'id': 'fb_ct_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਪੈਰਾਂ', 'ਵਿੱਚ', '___', 'ਪਾਓ'],
            'correctWord': 'ਜੁਰਾਬਾਂ',
            'options': ['ਜੁਰਾਬਾਂ', 'ਦਸਤਾਨੇ', 'ਐਨਕਾਂ'],
          },
        },
        {
          'id': 'fb_ct_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸਿਰ', 'ਉੱਤੇ', '___', 'ਲਵੋ'],
            'correctWord': 'ਟੋਪੀ',
            'options': ['ਟੋਪੀ', 'ਬੈਲਟ', 'ਘੜੀ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_kitchen',
      'title': 'Kitchen',
      'tasks': [
        {
          'id': 'fb_ki_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['___', 'ਨਾਲ', 'ਸਬਜ਼ੀ', 'ਕੱਟੋ'],
            'correctWord': 'ਚਾਕੂ',
            'options': ['ਚਾਕੂ', 'ਚਮਚ', 'ਗਲਾਸ'],
          },
        },
        {
          'id': 'fb_ki_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['___', 'ਵਿੱਚ', 'ਚਾਹ', 'ਪਾਓ'],
            'correctWord': 'ਕੱਪ',
            'options': ['ਕੱਪ', 'ਥਾਲੀ', 'ਕੜਾਹੀ'],
          },
        },
        {
          'id': 'fb_ki_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਰੋਟੀ', '___', 'ਵਿੱਚ', 'ਰੱਖੋ'],
            'correctWord': 'ਟੋਕਰੀ',
            'options': ['ਟੋਕਰੀ', 'ਬਾਲਟੀ', 'ਜੱਗ'],
          },
        },
        {
          'id': 'fb_ki_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੰਮੀ', '___', 'ਉੱਤੇ', 'ਖਾਣਾ', 'ਬਣਾਉਂਦੇ', 'ਹਨ'],
            'correctWord': 'ਚੁੱਲ੍ਹੇ',
            'options': ['ਚੁੱਲ੍ਹੇ', 'ਮੇਜ਼', 'ਫਰਸ਼'],
          },
        },
        {
          'id': 'fb_ki_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['___', 'ਨਾਲ', 'ਖੀਰ', 'ਖਾਓ'],
            'correctWord': 'ਚਮਚ',
            'options': ['ਚਮਚ', 'ਕਾਂਟੇ', 'ਚਾਕੂ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_nature',
      'title': 'Nature',
      'tasks': [
        {
          'id': 'fb_na_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['___', 'ਸਾਨੂੰ', 'ਛਾਂ', 'ਦਿੰਦੇ', 'ਹਨ'],
            'correctWord': 'ਰੁੱਖ',
            'options': ['ਰੁੱਖ', 'ਪੱਥਰ', 'ਪਹਾੜ'],
          },
        },
        {
          'id': 'fb_na_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸੂਰਜ', '___', 'ਵਿੱਚੋਂ', 'ਨਿਕਲਦਾ', 'ਹੈ'],
            'correctWord': 'ਪੂਰਬ',
            'options': ['ਪੂਰਬ', 'ਪੱਛਮ', 'ਉੱਤਰ'],
          },
        },
        {
          'id': 'fb_na_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਨਦੀ', 'ਵਿੱਚ', '___', 'ਵਗਦਾ', 'ਹੈ'],
            'correctWord': 'ਪਾਣੀ',
            'options': ['ਪਾਣੀ', 'ਦੁੱਧ', 'ਤੇਲ'],
          },
        },
        {
          'id': 'fb_na_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਬਾਗ', 'ਵਿੱਚ', 'ਸੁੰਦਰ', '___', 'ਖਿੜੇ', 'ਹਨ'],
            'correctWord': 'ਫੁੱਲ',
            'options': ['ਫੁੱਲ', 'ਕੰਢੇ', 'ਪੱਥਰ'],
          },
        },
        {
          'id': 'fb_na_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਰਾਤ', 'ਨੂੰ', '___', 'ਚਮਕਦੇ', 'ਹਨ'],
            'correctWord': 'ਤਾਰੇ',
            'options': ['ਤਾਰੇ', 'ਸੂਰਜ', 'ਬੱਦਲ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_birds',
      'title': 'Birds',
      'tasks': [
        {
          'id': 'fb_bi_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੋਰ', 'ਪੈਲ', '___', 'ਹੈ'],
            'correctWord': 'ਪਾਉਂਦਾ',
            'options': ['ਪਾਉਂਦਾ', 'ਖਾਂਦਾ', 'ਸੌਂਦਾ'],
          },
        },
        {
          'id': 'fb_bi_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਤੋਤਾ', '___', 'ਖਾਂਦਾ', 'ਹੈ'],
            'correctWord': 'ਚੂਰੀ',
            'options': ['ਚੂਰੀ', 'ਮੀਟ', 'ਪੱਥਰ'],
          },
        },
        {
          'id': 'fb_bi_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਚਿੜੀ', '___', 'ਕਰਦੀ', 'ਹੈ'],
            'correctWord': 'ਚੀਂ-ਚੀਂ',
            'options': ['ਚੀਂ-ਚੀਂ', 'ਕਾਂ-ਕਾਂ', 'ਗੁਟਰ-ਗੂੰ'],
          },
        },
        {
          'id': 'fb_bi_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਕਾਂ', 'ਦਾ', 'ਰੰਗ', '___', 'ਹੁੰਦਾ', 'ਹੈ'],
            'correctWord': 'ਕਾਲਾ',
            'options': ['ਕਾਲਾ', 'ਚਿੱਟਾ', 'ਨੀਲਾ'],
          },
        },
        {
          'id': 'fb_bi_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਕੋਇਲ', 'ਬਹੁਤ', '___', 'ਬੋਲਦੀ', 'ਹੈ'],
            'correctWord': 'ਮਿੱਠਾ',
            'options': ['ਮਿੱਠਾ', 'ਕੌੜਾ', 'ਉੱਚਾ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_days',
      'title': 'Days',
      'tasks': [
        {
          'id': 'fb_da_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਹਫ਼ਤੇ', 'ਵਿੱਚ', '___', 'ਦਿਨ', 'ਹੁੰਦੇ', 'ਹਨ'],
            'correctWord': 'ਸੱਤ',
            'options': ['ਸੱਤ', 'ਪੰਜ', 'ਦਸ'],
          },
        },
        {
          'id': 'fb_da_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['___', 'ਨੂੰ', 'ਸਕੂਲ', 'ਦੀ', 'ਛੁੱਟੀ', 'ਹੁੰਦੀ', 'ਹੈ'],
            'correctWord': 'ਐਤਵਾਰ',
            'options': ['ਐਤਵਾਰ', 'ਸੋਮਵਾਰ', 'ਵੀਰਵਾਰ'],
          },
        },
        {
          'id': 'fb_da_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸੋਮਵਾਰ', 'ਤੋਂ', 'ਬਾਅਦ', '___', 'ਆਉਂਦਾ', 'ਹੈ'],
            'correctWord': 'ਮੰਗਲਵਾਰ',
            'options': ['ਮੰਗਲਵਾਰ', 'ਬੁੱਧਵਾਰ', 'ਸ਼ੁੱਕਰਵਾਰ'],
          },
        },
        {
          'id': 'fb_da_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਅੱਜ', 'ਕਿਹੜਾ', '___', 'ਹੈ?'],
            'correctWord': 'ਦਿਨ',
            'options': ['ਦਿਨ', 'ਮਹੀਨਾ', 'ਸਾਲ'],
          },
        },
        {
          'id': 'fb_da_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਕੱਲ੍ਹ', '___', 'ਸੀ'],
            'correctWord': 'ਸ਼ਨੀਵਾਰ',
            'options': ['ਸ਼ਨੀਵਾਰ', 'ਜਨਵਰੀ', 'ਗਰਮੀ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_directions',
      'title': 'Directions',
      'tasks': [
        {
          'id': 'fb_di_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸੂਰਜ', '___', 'ਵਿੱਚ', 'ਛਿਪਦਾ', 'ਹੈ'],
            'correctWord': 'ਪੱਛਮ',
            'options': ['ਪੱਛਮ', 'ਪੂਰਬ', 'ਦੱਖਣ'],
          },
        },
        {
          'id': 'fb_di_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਖੱਬੇ', 'ਦੇ', 'ਉਲਟ', '___', 'ਹੁੰਦਾ', 'ਹੈ'],
            'correctWord': 'ਸੱਜਾ',
            'options': ['ਸੱਜਾ', 'ਉੱਪਰ', 'ਹੇਠਾਂ'],
          },
        },
        {
          'id': 'fb_di_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਅਸਮਾਨ', '___', 'ਹੈ'],
            'correctWord': 'ਉੱਪਰ',
            'options': ['ਉੱਪਰ', 'ਹੇਠਾਂ', 'ਪਿੱਛੇ'],
          },
        },
        {
          'id': 'fb_di_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਜ਼ਮੀਨ', '___', 'ਹੈ'],
            'correctWord': 'ਹੇਠਾਂ',
            'options': ['ਹੇਠਾਂ', 'ਉੱਪਰ', 'ਸਾਹਮਣੇ'],
          },
        },
        {
          'id': 'fb_di_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੇਰੇ', '___', 'ਦੀਵਾਰ', 'ਹੈ'],
            'correctWord': 'ਪਿੱਛੇ',
            'options': ['ਪਿੱਛੇ', 'ਅੰਦਰ', 'ਬਾਹਰ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_office',
      'title': 'Office',
      'tasks': [
        {
          'id': 'fb_of_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਪਿਤਾ', 'ਜੀ', '___', 'ਗਏ', 'ਹਨ'],
            'correctWord': 'ਦਫ਼ਤਰ',
            'options': ['ਦਫ਼ਤਰ', 'ਖੇਤ', 'ਸਕੂਲ'],
          },
        },
        {
          'id': 'fb_of_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', '___', 'ਉੱਤੇ', 'ਕੰਮ', 'ਕਰਦਾ', 'ਹਾਂ'],
            'correctWord': 'ਕੰਪਿਊਟਰ',
            'options': ['ਕੰਪਿਊਟਰ', 'ਟੀਵੀ', 'ਰੇਡੀਓ'],
          },
        },
        {
          'id': 'fb_of_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['___', 'ਵਿੱਚ', 'ਜ਼ਰੂਰੀ', 'ਕਾਗਜ਼', 'ਹਨ'],
            'correctWord': 'ਫਾਈਲ',
            'options': ['ਫਾਈਲ', 'ਬੋਤਲ', 'ਥੈਲੇ'],
          },
        },
        {
          'id': 'fb_of_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੇਜ਼', 'ਉੱਤੇ', '___', 'ਪਿਆ', 'ਹੈ'],
            'correctWord': 'ਫੋਨ',
            'options': ['ਫੋਨ', 'ਬੂਟ', 'ਛਤਰੀ'],
          },
        },
        {
          'id': 'fb_of_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਦਫ਼ਤਰ', 'ਵਿੱਚ', 'ਬਹੁਤ', '___', 'ਹਨ'],
            'correctWord': 'ਮੇਜ਼',
            'options': ['ਮੇਜ਼', 'ਬਿਸਤਰੇ', 'ਚੁੱਲ੍ਹੇ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_shopping',
      'title': 'Shopping',
      'tasks': [
        {
          'id': 'fb_sh_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਅਸੀਂ', '___', 'ਤੋਂ', 'ਸਬਜ਼ੀ', 'ਲੈਂਦੇ', 'ਹਾਂ'],
            'correctWord': 'ਬਾਜ਼ਾਰ',
            'options': ['ਬਾਜ਼ਾਰ', 'ਸਕੂਲ', 'ਬਾਗ'],
          },
        },
        {
          'id': 'fb_sh_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਇਸ', 'ਕਮੀਜ਼', 'ਦੀ', '___', 'ਕੀ', 'ਹੈ?'],
            'correctWord': 'ਕੀਮਤ',
            'options': ['ਕੀਮਤ', 'ਲੰਬਾਈ', 'ਹਵਾ'],
          },
        },
        {
          'id': 'fb_sh_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', '___', 'ਨਾਲ', 'ਪੈਸੇ', 'ਦਿੱਤੇ'],
            'correctWord': 'ਹੱਥ',
            'options': ['ਹੱਥ', 'ਪੈਰ', 'ਸਿਰ'],
          },
        },
        {
          'id': 'fb_sh_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮਾਲ', 'ਵਿੱਚ', 'ਬਹੁਤ', '___', 'ਹਨ'],
            'correctWord': 'ਦੁਕਾਨਾਂ',
            'options': ['ਦੁਕਾਨਾਂ', 'ਖੇਤ', 'ਦਰਿਆ'],
          },
        },
        {
          'id': 'fb_sh_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', 'ਨਵੇਂ', '___', 'ਖਰੀਦੇ'],
            'correctWord': 'ਕੱਪੜੇ',
            'options': ['ਕੱਪੜੇ', 'ਪੱਥਰ', 'ਬੱਦਲ'],
          },
        },
      ],
    },
    {
      'id': 'section_fb_eating',
      'title': 'Eating',
      'tasks': [
        {
          'id': 'fb_ea_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਨੂੰ', '___', 'ਲੱਗੀ', 'ਹੈ'],
            'correctWord': 'ਭੁੱਖ',
            'options': ['ਭੁੱਖ', 'ਨੀਂਦ', 'ਖੁਸ਼ੀ'],
          },
        },
        {
          'id': 'fb_ea_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਖਾਣਾ', 'ਬਹੁਤ', '___', 'ਹੈ'],
            'correctWord': 'ਸੁਆਦੀ',
            'options': ['ਸੁਆਦੀ', 'ਨੀਲਾ', 'ਉੱਚਾ'],
          },
        },
        {
          'id': 'fb_ea_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', 'ਰੋਟੀ', 'ਨਾਲ', '___', 'ਖਾਧੀ'],
            'correctWord': 'ਦਾਲ',
            'options': ['ਦਾਲ', 'ਪਾਣੀ', 'ਚਾਹ'],
          },
        },
        {
          'id': 'fb_ea_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਪਾਣੀ', '___', 'ਚਾਹੀਦਾ', 'ਹੈ'],
            'correctWord': 'ਪੀਣਾ',
            'options': ['ਪੀਣਾ', 'ਖਾਣਾ', 'ਸੌਣਾ'],
          },
        },
        {
          'id': 'fb_ea_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਸਾਨੂੰ', '___', 'ਫਲ', 'ਖਾਣੇ', 'ਚਾਹੀਦੇ', 'ਹਨ'],
            'correctWord': 'ਤਾਜ਼ੇ',
            'options': ['ਤਾਜ਼ੇ', 'ਬੇਹੇ', 'ਗੰਦੇ'],
          },
        },
      ],
    },
  ],
};
