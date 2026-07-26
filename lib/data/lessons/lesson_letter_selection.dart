import '../../config/content_ids.dart';

/// Lesson data for "Letter Identification".
final Map<String, dynamic> lessonLetterSelection = {
  'id': ContentIds.letterSelection,
  'title': 'Letter Identification',
  'order': 2,
  'shuffleSections': true,
  'shuffleTasks': true,
  'visible': true,
  'sections': [
    {
      'id': 'section_vowel_selection',
      'title': 'Vowel Sounds',
      'tasks': [
        {
          'id': 'ls_01',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ੳ',
            'distractorLetters': ['ਅ', 'ੲ', 'ਸ'],
          },
        },
        {
          'id': 'ls_02',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਅ',
            'distractorLetters': ['ੳ', 'ੲ', 'ਹ'],
          },
        },
        {
          'id': 'ls_03',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ੲ',
            'distractorLetters': ['ੳ', 'ਸ', 'ਹ'],
          },
        },
        {
          'id': 'ls_04',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਸ',
            'distractorLetters': ['ਅ', 'ੲ', 'ਹ'],
          },
        },
        {
          'id': 'ls_05',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਹ',
            'distractorLetters': ['ੳ', 'ਅ', 'ਸ'],
          },
        },
      ],
    },
    {
      'id': 'section_guttural_selection',
      'title': 'Guttural Sounds',
      'tasks': [
        {
          'id': 'ls_06',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਕ',
            'distractorLetters': ['ਖ', 'ਗ', 'ਘ'],
          },
        },
        {
          'id': 'ls_07',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਖ',
            'distractorLetters': ['ਕ', 'ਗ', 'ਙ'],
          },
        },
        {
          'id': 'ls_08',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਗ',
            'distractorLetters': ['ਕ', 'ਖ', 'ਘ'],
          },
        },
        {
          'id': 'ls_09',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਘ',
            'distractorLetters': ['ਖ', 'ਗ', 'ਙ'],
          },
        },
        {
          'id': 'ls_10',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਙ',
            'distractorLetters': ['ਕ', 'ਗ', 'ਘ'],
          },
        },
      ],
    },
    {
      'id': 'section_palatal_selection',
      'title': 'Palatal Sounds',
      'tasks': [
        {
          'id': 'ls_11',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਚ',
            'distractorLetters': ['ਛ', 'ਜ', 'ਝ'],
          },
        },
        {
          'id': 'ls_12',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਛ',
            'distractorLetters': ['ਚ', 'ਜ', 'ਞ'],
          },
        },
        {
          'id': 'ls_13',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਜ',
            'distractorLetters': ['ਚ', 'ਛ', 'ਝ'],
          },
        },
        {
          'id': 'ls_14',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਝ',
            'distractorLetters': ['ਛ', 'ਜ', 'ਞ'],
          },
        },
        {
          'id': 'ls_15',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਞ',
            'distractorLetters': ['ਚ', 'ਜ', 'ਝ'],
          },
        },
      ],
    },
    {
      'id': 'section_retroflex_selection',
      'title': 'Retroflex Sounds',
      'tasks': [
        {
          'id': 'ls_16',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਟ',
            'distractorLetters': ['ਠ', 'ਡ', 'ਢ'],
          },
        },
        {
          'id': 'ls_17',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਠ',
            'distractorLetters': ['ਟ', 'ਡ', 'ਣ'],
          },
        },
        {
          'id': 'ls_18',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਡ',
            'distractorLetters': ['ਟ', 'ਠ', 'ਢ'],
          },
        },
        {
          'id': 'ls_19',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਢ',
            'distractorLetters': ['ਠ', 'ਡ', 'ਣ'],
          },
        },
        {
          'id': 'ls_20',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਣ',
            'distractorLetters': ['ਟ', 'ਡ', 'ਢ'],
          },
        },
      ],
    },
    {
      'id': 'section_dental_selection',
      'title': 'Dental Sounds',
      'tasks': [
        {
          'id': 'ls_21',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਤ',
            'distractorLetters': ['ਥ', 'ਦ', 'ਧ'],
          },
        },
        {
          'id': 'ls_22',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਥ',
            'distractorLetters': ['ਤ', 'ਦ', 'ਨ'],
          },
        },
        {
          'id': 'ls_23',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਦ',
            'distractorLetters': ['ਤ', 'ਥ', 'ਧ'],
          },
        },
        {
          'id': 'ls_24',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਧ',
            'distractorLetters': ['ਥ', 'ਦ', 'ਨ'],
          },
        },
        {
          'id': 'ls_25',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਨ',
            'distractorLetters': ['ਤ', 'ਦ', 'ਧ'],
          },
        },
      ],
    },
    {
      'id': 'section_labial_selection',
      'title': 'Labial Sounds',
      'tasks': [
        {
          'id': 'ls_26',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਪ',
            'distractorLetters': ['ਫ', 'ਬ', 'ਭ'],
          },
        },
        {
          'id': 'ls_27',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਫ',
            'distractorLetters': ['ਪ', 'ਬ', 'ਮ'],
          },
        },
        {
          'id': 'ls_28',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਬ',
            'distractorLetters': ['ਪ', 'ਫ', 'ਭ'],
          },
        },
        {
          'id': 'ls_29',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਭ',
            'distractorLetters': ['ਫ', 'ਬ', 'ਮ'],
          },
        },
        {
          'id': 'ls_30',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਮ',
            'distractorLetters': ['ਪ', 'ਬ', 'ਭ'],
          },
        },
      ],
    },
    {
      'id': 'section_semivowel_selection',
      'title': 'Semivowels',
      'tasks': [
        {
          'id': 'ls_31',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਯ',
            'distractorLetters': ['ਰ', 'ਲ', 'ਵ'],
          },
        },
        {
          'id': 'ls_32',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਰ',
            'distractorLetters': ['ਯ', 'ਲ', 'ੜ'],
          },
        },
        {
          'id': 'ls_33',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਲ',
            'distractorLetters': ['ਰ', 'ਵ', 'ੜ'],
          },
        },
        {
          'id': 'ls_34',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ਵ',
            'distractorLetters': ['ਯ', 'ਲ', 'ੜ'],
          },
        },
        {
          'id': 'ls_35',
          'type': 'letterSelection',
          'pointsAwarded': 10,
          'content': {
            'correctLetter': 'ੜ',
            'distractorLetters': ['ਰ', 'ਲ', 'ਵ'],
          },
        },
      ],
    },
  ],
};
