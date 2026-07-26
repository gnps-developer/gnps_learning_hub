import '../../config/content_ids.dart';

/// Lesson data for "Spelling".
/// Part of the app's bundled content store (see `lib/data/journey_data.dart`).
///
/// Reviewed & validated: every `letterBank` was checked so its correct pieces
/// concatenate exactly to `targetWord`, and so no bank contains a duplicate tile.
/// Sections expanded to 10 questions each. "Everyday Objects" and "Household
/// Items" merged into one section. New sections added: Clothes, Kitchen,
/// Nature, Birds, Days, Directions, Office, Shopping, Eating.
final Map<String, dynamic> lessonSpelling = {
  'id': ContentIds.spelling,
  'title': 'Spelling',
  'order': 3,
  'shuffleSections': true,
  'shuffleTasks': true,
  'visible': true,
  'sections': [
    {
      'id': 'section_animals',
      'title': 'Animals',
      'tasks': [
        {
          'id': 't3',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐱',
            'targetWord': 'ਬਿੱਲੀ',
            'letterBank': ['ਬਿ', 'ੱ', 'ਲੀ', 'ਮ', 'ਅ'],
          },
        },
        {
          'id': 't6',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦮',
            'targetWord': 'ਕੁੱਤਾ',
            'letterBank': ['ਕੁ', 'ੱ', 'ਤਾ', 'ਬ', 'ਲੀ'],
          },
        },
        {
          'id': 'spelling_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐟',
            'targetWord': 'ਮੱਛੀ',
            'letterBank': ['ਮ', 'ੱ', 'ਛੀ', 'ਕੁ', 'ਤਾ'],
          },
        },
        {
          'id': 'spelling_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐴',
            'targetWord': 'ਘੋੜਾ',
            'letterBank': ['ਘੋ', 'ੜਾ', 'ਬਿ', 'ੱ', 'ਲੀ'],
          },
        },
        {
          'id': 'spelling_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐘',
            'targetWord': 'ਹਾਥੀ',
            'letterBank': ['ਹਾ', 'ਥੀ', 'ਕੁ', 'ੱ', 'ਤਾ'],
          },
        },
        {
          'id': 'animals_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦁',
            'targetWord': 'ਸ਼ੇਰ',
            'letterBank': ['ਸ਼ੇ', 'ਰ', 'ਬਾਂ', 'ਦਰ', 'ਭਾ'],
          },
        },
        {
          'id': 'animals_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐒',
            'targetWord': 'ਬਾਂਦਰ',
            'letterBank': ['ਬਾਂ', 'ਦਰ', 'ਸ਼ੇ', 'ਰ', 'ਊ'],
          },
        },
        {
          'id': 'animals_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦆',
            'targetWord': 'ਬੱਤਖ',
            'letterBank': ['ਬ', 'ੱ', 'ਤਖ', 'ਭਾ', 'ਲੂ'],
          },
        },
        {
          'id': 'animals_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐻',
            'targetWord': 'ਭਾਲੂ',
            'letterBank': ['ਭਾ', 'ਲੂ', 'ਊ', 'ਠ', 'ਬ'],
          },
        },
        {
          'id': 'animals_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐫',
            'targetWord': 'ਊਠ',
            'letterBank': ['ਊ', 'ਠ', 'ਬਾਂ', 'ਦਰ', 'ਸ਼ੇ'],
          },
        },
      ],
    },
    {
      'id': 'section_objects_household',
      'title': 'Everyday Objects & Household',
      'tasks': [
        {
          'id': 'spelling_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📖',
            'targetWord': 'ਕਿਤਾਬ',
            'letterBank': ['ਕਿ', 'ਤਾ', 'ਬ', 'ਸੂ', 'ਰਜ'],
          },
        },
        {
          'id': 'spelling_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '☀️',
            'targetWord': 'ਸੂਰਜ',
            'letterBank': ['ਸੂ', 'ਰਜ', 'ਕਿ', 'ਤਾ', 'ਬ'],
          },
        },
        {
          'id': 'spelling_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⚽',
            'targetWord': 'ਗੇਂਦ',
            'letterBank': ['ਗੇਂ', 'ਦ', 'ਤਾ', 'ਰਾ', 'ਬ'],
          },
        },
        {
          'id': 'spelling_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⭐',
            'targetWord': 'ਤਾਰਾ',
            'letterBank': ['ਤਾ', 'ਰਾ', 'ਗੇਂ', 'ਦ', 'ਸੂ'],
          },
        },
        {
          'id': 'spelling_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌙',
            'targetWord': 'ਚੰਦ',
            'letterBank': ['ਚੰ', 'ਦ', 'ਤਾ', 'ਰਾ', 'ਗੇਂ'],
          },
        },
        {
          'id': 'household_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🪑',
            'targetWord': 'ਕੁਰਸੀ',
            'letterBank': ['ਕੁ', 'ਰ', 'ਸੀ', 'ਵਾ', 'ਜ਼ਾ'],
          },
        },
        {
          'id': 'household_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚪',
            'targetWord': 'ਦਰਵਾਜ਼ਾ',
            'letterBank': ['ਦਰ', 'ਵਾ', 'ਜ਼ਾ', 'ਖਿ', 'ਕੀ'],
          },
        },
        {
          'id': 'household_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🪟',
            'targetWord': 'ਖਿੜਕੀ',
            'letterBank': ['ਖਿ', 'ੜ', 'ਕੀ', 'ਮੰ', 'ਜਾ'],
          },
        },
        {
          'id': 'household_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🛏️',
            'targetWord': 'ਮੰਜਾ',
            'letterBank': ['ਮੰ', 'ਜਾ', 'ਸੋ', 'ਫ਼ਾ', 'ਕੁ'],
          },
        },
        {
          'id': 'household_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🛋️',
            'targetWord': 'ਸੋਫ਼ਾ',
            'letterBank': ['ਸੋ', 'ਫ਼ਾ', 'ਦਰ', 'ਖਿ', 'ੜ'],
          },
        },
      ],
    },
    {
      'id': 'section_fruits',
      'title': 'Fruits',
      'tasks': [
        {
          'id': 'spelling_11',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍎',
            'targetWord': 'ਸੇਬ',
            'letterBank': ['ਸੇ', 'ਬ', 'ਕੇ', 'ਲਾ', 'ਅੰ'],
          },
        },
        {
          'id': 'spelling_12',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍌',
            'targetWord': 'ਕੇਲਾ',
            'letterBank': ['ਕੇ', 'ਲਾ', 'ਸੇ', 'ਬ', 'ਅੰ'],
          },
        },
        {
          'id': 'spelling_13',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🥭',
            'targetWord': 'ਅੰਬ',
            'letterBank': ['ਅੰ', 'ਬ', 'ਸੇ', 'ਕੇ', 'ਲਾ'],
          },
        },
        {
          'id': 'spelling_14',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍊',
            'targetWord': 'ਸੰਤਰਾ',
            'letterBank': ['ਸੰ', 'ਤ', 'ਰਾ', 'ਕੇ', 'ਲਾ'],
          },
        },
        {
          'id': 'spelling_15',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍇',
            'targetWord': 'ਅੰਗੂਰ',
            'letterBank': ['ਅੰ', 'ਗੂ', 'ਰ', 'ਸੇ', 'ਬ'],
          },
        },
        {
          'id': 'fruits_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍉',
            'targetWord': 'ਤਰਬੂਜ਼',
            'letterBank': ['ਤਰ', 'ਬੂ', 'ਜ਼', 'ਅ', 'ਨਾ'],
          },
        },
        {
          'id': 'fruits_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍍',
            'targetWord': 'ਅਨਾਨਾਸ',
            'letterBank': ['ਅ', 'ਨਾ', 'ਨਾਸ', 'ਆ', 'ੜੂ'],
          },
        },
        {
          'id': 'fruits_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍑',
            'targetWord': 'ਆੜੂ',
            'letterBank': ['ਆ', 'ੜੂ', 'ਨਾਸ਼', 'ਪਾ', 'ਤੀ'],
          },
        },
        {
          'id': 'fruits_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍐',
            'targetWord': 'ਨਾਸ਼ਪਾਤੀ',
            'letterBank': ['ਨਾਸ਼', 'ਪਾ', 'ਤੀ', 'ਨਿੰ', 'ਬੂ'],
          },
        },
        {
          'id': 'fruits_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍋',
            'targetWord': 'ਨਿੰਬੂ',
            'letterBank': ['ਨਿੰ', 'ਬੂ', 'ਤਰ', 'ਜ਼', 'ਅ'],
          },
        },
      ],
    },
    {
      'id': 'section_colors',
      'title': 'Colors',
      'tasks': [
        {
          'id': 'spelling_16',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🔴',
            'targetWord': 'ਲਾਲ',
            'letterBank': ['ਲਾ', 'ਲ', 'ਨੀ', 'ਪੀ', 'ਹ'],
          },
        },
        {
          'id': 'spelling_17',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🔵',
            'targetWord': 'ਨੀਲਾ',
            'letterBank': ['ਨੀ', 'ਲਾ', 'ਪੀ', 'ਲ', 'ਹ'],
          },
        },
        {
          'id': 'spelling_18',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🟡',
            'targetWord': 'ਪੀਲਾ',
            'letterBank': ['ਪੀ', 'ਲਾ', 'ਹ', 'ਨੀ', 'ਲ'],
          },
        },
        {
          'id': 'spelling_19',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🟢',
            'targetWord': 'ਹਰਾ',
            'letterBank': ['ਹ', 'ਰਾ', 'ਲਾ', 'ਲ', 'ਨੀ'],
          },
        },
        {
          'id': 'spelling_20',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⚫',
            'targetWord': 'ਕਾਲਾ',
            'letterBank': ['ਕਾ', 'ਲਾ', 'ਚਿ', 'ੱ', 'ਟਾ'],
          },
        },
        {
          'id': 'spelling_21',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⚪',
            'targetWord': 'ਚਿੱਟਾ',
            'letterBank': ['ਚਿ', 'ੱ', 'ਟਾ', 'ਕਾ', 'ਲਾ'],
          },
        },
        {
          'id': 'colors_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🟠',
            'targetWord': 'ਸੰਤਰੀ',
            'letterBank': ['ਸੰ', 'ਤ', 'ਰੀ', 'ਗੁ', 'ਲਾ'],
          },
        },
        {
          'id': 'colors_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🩷',
            'targetWord': 'ਗੁਲਾਬੀ',
            'letterBank': ['ਗੁ', 'ਲਾ', 'ਬੀ', 'ਭੂ', 'ਰਾ'],
          },
        },
        {
          'id': 'colors_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🟤',
            'targetWord': 'ਭੂਰਾ',
            'letterBank': ['ਭੂ', 'ਰਾ', 'ਜਾ', 'ਮ', 'ਨੀ'],
          },
        },
        {
          'id': 'colors_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🟣',
            'targetWord': 'ਜਾਮਨੀ',
            'letterBank': ['ਜਾ', 'ਮ', 'ਨੀ', 'ਸੰ', 'ਰੀ'],
          },
        },
      ],
    },
    {
      'id': 'section_travel',
      'title': 'Travel & Transport',
      'tasks': [
        {
          'id': 'travel_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚗',
            'targetWord': 'ਕਾਰ',
            'letterBank': ['ਕਾ', 'ਰ', 'ਬ', 'ੱ', 'ਸ'],
          },
        },
        {
          'id': 'travel_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚌',
            'targetWord': 'ਬੱਸ',
            'letterBank': ['ਬ', 'ੱ', 'ਸ', 'ਕਾ', 'ਰ'],
          },
        },
        {
          'id': 'travel_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚆',
            'targetWord': 'ਰੇਲਗੱਡੀ',
            'letterBank': ['ਰੇਲ', 'ਗੱ', 'ਡੀ', 'ਜ', 'ਹਾ'],
          },
        },
        {
          'id': 'travel_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '✈️',
            'targetWord': 'ਜਹਾਜ਼',
            'letterBank': ['ਜ', 'ਹਾ', 'ਜ਼', 'ਸਾਈ', 'ਕਲ'],
          },
        },
        {
          'id': 'travel_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚲',
            'targetWord': 'ਸਾਈਕਲ',
            'letterBank': ['ਸਾਈ', 'ਕਲ', 'ਰੇਲ', 'ਗੱ', 'ਡੀ'],
          },
        },
        {
          'id': 'travel_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚤',
            'targetWord': 'ਕਿਸ਼ਤੀ',
            'letterBank': ['ਕਿ', 'ਸ਼', 'ਤੀ', 'ਟੈ', 'ਕ'],
          },
        },
        {
          'id': 'travel_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚕',
            'targetWord': 'ਟੈਕਸੀ',
            'letterBank': ['ਟੈ', 'ਕ', 'ਸੀ', 'ਟਰੱ', 'ਮੋ'],
          },
        },
        {
          'id': 'travel_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚚',
            'targetWord': 'ਟਰੱਕ',
            'letterBank': ['ਟ', 'ਰੱ', 'ਕ', 'ਹੈ', 'ਲੀ'],
          },
        },
        {
          'id': 'travel_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏍️',
            'targetWord': 'ਮੋਟਰਸਾਈਕਲ',
            'letterBank': ['ਮੋ', 'ਟਰ', 'ਸਾਈ', 'ਕਲ', 'ਕਿ'],
          },
        },
        {
          'id': 'travel_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🚁',
            'targetWord': 'ਹੈਲੀਕਾਪਟਰ',
            'letterBank': ['ਹੈ', 'ਲੀ', 'ਕਾਪ', 'ਟਰ', 'ਟੈ'],
          },
        },
      ],
    },
    {
      'id': 'section_school',
      'title': 'School',
      'tasks': [
        {
          'id': 'school_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '✏️',
            'targetWord': 'ਪੈਨਸਿਲ',
            'letterBank': ['ਪੈਨ', 'ਸਿ', 'ਲ', 'ਬ', 'ਤਾ'],
          },
        },
        {
          'id': 'school_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🖊️',
            'targetWord': 'ਕਲਮ',
            'letterBank': ['ਕ', 'ਲ', 'ਮ', 'ਗੁ', 'ਰੂ'],
          },
        },
        {
          'id': 'school_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🎒',
            'targetWord': 'ਬਸਤਾ',
            'letterBank': ['ਬ', 'ਸ', 'ਤਾ', 'ਤ', 'ਖ'],
          },
        },
        {
          'id': 'school_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧑‍🏫',
            'targetWord': 'ਗੁਰੂ',
            'letterBank': ['ਗੁ', 'ਰੂ', 'ਪੈਨ', 'ਸਿ', 'ਬ'],
          },
        },
        {
          'id': 'school_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📝',
            'targetWord': 'ਤਖਤੀ',
            'letterBank': ['ਤ', 'ਖ', 'ਤੀ', 'ਕ', 'ਮ'],
          },
        },
        {
          'id': 'school_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏫',
            'targetWord': 'ਜਮਾਤ',
            'letterBank': ['ਜ', 'ਮਾਤ', 'ਵਿ', 'ਦਿ', 'ਆਰ'],
          },
        },
        {
          'id': 'school_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧑‍🎓',
            'targetWord': 'ਵਿਦਿਆਰਥੀ',
            'letterBank': ['ਵਿ', 'ਦਿ', 'ਆਰ', 'ਥੀ', 'ਰ'],
          },
        },
        {
          'id': 'school_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧼',
            'targetWord': 'ਰਬੜ',
            'letterBank': ['ਰ', 'ਬੜ', 'ਸ', 'ਕੂਲ', 'ਮੇ'],
          },
        },
        {
          'id': 'school_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏢',
            'targetWord': 'ਸਕੂਲ',
            'letterBank': ['ਸ', 'ਕੂਲ', 'ਮੇ', 'ਜ਼', 'ਜ'],
          },
        },
        {
          'id': 'school_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🪑',
            'targetWord': 'ਮੇਜ਼',
            'letterBank': ['ਮੇ', 'ਜ਼', 'ਰ', 'ਬੜ', 'ਸ'],
          },
        },
      ],
    },
    {
      'id': 'section_weather',
      'title': 'Weather',
      'tasks': [
        {
          'id': 'weather_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌧️',
            'targetWord': 'ਮੀਂਹ',
            'letterBank': ['ਮੀਂ', 'ਹ', 'ਬ', 'ੱ', 'ਦਲ'],
          },
        },
        {
          'id': 'weather_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '☁️',
            'targetWord': 'ਬੱਦਲ',
            'letterBank': ['ਬ', 'ੱ', 'ਦਲ', 'ਹ', 'ਵਾ'],
          },
        },
        {
          'id': 'weather_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '💨',
            'targetWord': 'ਹਵਾ',
            'letterBank': ['ਹ', 'ਵਾ', 'ਬ', 'ਰ', 'ਫ਼'],
          },
        },
        {
          'id': 'weather_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '❄️',
            'targetWord': 'ਬਰਫ਼',
            'letterBank': ['ਬ', 'ਰ', 'ਫ਼', 'ਧੁੰ', 'ਦ'],
          },
        },
        {
          'id': 'weather_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌫️',
            'targetWord': 'ਧੁੰਦ',
            'letterBank': ['ਧੁੰ', 'ਦ', 'ਮੀਂ', 'ਹ', 'ਬ'],
          },
        },
        {
          'id': 'weather_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '☀️',
            'targetWord': 'ਧੁੱਪ',
            'letterBank': ['ਧੁੱ', 'ਪ', 'ਗਰ', 'ਮੀ', ' '],
          },
        },
        {
          'id': 'weather_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🥵',
            'targetWord': 'ਗਰਮੀ',
            'letterBank': ['ਗਰ', 'ਮੀ', 'ਸਰ', 'ਦੀ', 'ਧੁੱ'],
          },
        },
        {
          'id': 'weather_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🥶',
            'targetWord': 'ਸਰਦੀ',
            'letterBank': ['ਸਰ', 'ਦੀ', 'ਬਿਜ', 'ਲੀ', 'ਗਰ'],
          },
        },
        {
          'id': 'weather_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⚡',
            'targetWord': 'ਬਿਜਲੀ',
            'letterBank': ['ਬਿਜ', 'ਲੀ', 'ਤੂ', 'ਫ਼ਾਨ', 'ਸਰ'],
          },
        },
        {
          'id': 'weather_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌪️',
            'targetWord': 'ਤੂਫ਼ਾਨ',
            'letterBank': ['ਤੂ', 'ਫ਼ਾਨ', 'ਧੁੱ', 'ਪ', 'ਗਰ'],
          },
        },
      ],
    },
    {
      'id': 'section_clothes',
      'title': 'Clothes',
      'tasks': [
        {
          'id': 'clothes_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '👕',
            'targetWord': 'ਕਮੀਜ਼',
            'letterBank': ['ਕ', 'ਮੀ', 'ਜ਼', 'ਪੈਂ', 'ਟ'],
          },
        },
        {
          'id': 'clothes_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '👖',
            'targetWord': 'ਪੈਂਟ',
            'letterBank': ['ਪੈਂ', 'ਟ', 'ਜੁੱ', 'ਤੀ', 'ਟੋ'],
          },
        },
        {
          'id': 'clothes_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '👟',
            'targetWord': 'ਜੁੱਤੀ',
            'letterBank': ['ਜੁੱ', 'ਤੀ', 'ਟੋ', 'ਪੀ', 'ਜੁ'],
          },
        },
        {
          'id': 'clothes_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧢',
            'targetWord': 'ਟੋਪੀ',
            'letterBank': ['ਟੋ', 'ਪੀ', 'ਜੁ', 'ਰਾਬ', 'ਸ'],
          },
        },
        {
          'id': 'clothes_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧦',
            'targetWord': 'ਜੁਰਾਬ',
            'letterBank': ['ਜੁ', 'ਰਾਬ', 'ਸ', 'ਵੈ', 'ਟਰ'],
          },
        },
        {
          'id': 'clothes_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧥',
            'targetWord': 'ਸਵੈਟਰ',
            'letterBank': ['ਸ', 'ਵੈ', 'ਟਰ', 'ਦਸ', 'ਨੇ'],
          },
        },
        {
          'id': 'clothes_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧤',
            'targetWord': 'ਦਸਤਾਨੇ',
            'letterBank': ['ਦਸ', 'ਤਾ', 'ਨੇ', 'ਕੋ', 'ਟ'],
          },
        },
        {
          'id': 'clothes_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧥',
            'targetWord': 'ਕੋਟ',
            'letterBank': ['ਕੋ', 'ਟ', 'ਰੁ', 'ਮਾਲ', 'ਪ'],
          },
        },
        {
          'id': 'clothes_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧣',
            'targetWord': 'ਰੁਮਾਲ',
            'letterBank': ['ਰੁ', 'ਮਾਲ', 'ਪ', 'ਜਾ', 'ਮਾ'],
          },
        },
        {
          'id': 'clothes_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '👘',
            'targetWord': 'ਪਜਾਮਾ',
            'letterBank': ['ਪ', 'ਜਾ', 'ਮਾ', 'ਕ', 'ਮੀ'],
          },
        },
      ],
    },
    {
      'id': 'section_kitchen',
      'title': 'Kitchen',
      'tasks': [
        {
          'id': 'kitchen_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🥄',
            'targetWord': 'ਚਮਚ',
            'letterBank': ['ਚਮ', 'ਚ', 'ਕਾਂ', 'ਟਾ', 'ਛੁ'],
          },
        },
        {
          'id': 'kitchen_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍴',
            'targetWord': 'ਕਾਂਟਾ',
            'letterBank': ['ਕਾਂ', 'ਟਾ', 'ਛੁ', 'ਰੀ', 'ਭਾਂ'],
          },
        },
        {
          'id': 'kitchen_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🔪',
            'targetWord': 'ਛੁਰੀ',
            'letterBank': ['ਛੁ', 'ਰੀ', 'ਭਾਂ', 'ਡਾ', 'ਗ'],
          },
        },
        {
          'id': 'kitchen_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍲',
            'targetWord': 'ਭਾਂਡਾ',
            'letterBank': ['ਭਾਂ', 'ਡਾ', 'ਗ', 'ਲਾਸ', 'ਪ'],
          },
        },
        {
          'id': 'kitchen_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🥛',
            'targetWord': 'ਗਲਾਸ',
            'letterBank': ['ਗ', 'ਲਾਸ', 'ਪ', 'ਲੇਟ', 'ਫ'],
          },
        },
        {
          'id': 'kitchen_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍽️',
            'targetWord': 'ਪਲੇਟ',
            'letterBank': ['ਪ', 'ਲੇਟ', 'ਫ', 'ਰਿੱ', 'ਜ'],
          },
        },
        {
          'id': 'kitchen_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧊',
            'targetWord': 'ਫਰਿੱਜ',
            'letterBank': ['ਫ', 'ਰਿੱ', 'ਜ', 'ਚੁੱ', 'ਲ੍ਹਾ'],
          },
        },
        {
          'id': 'kitchen_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🔥',
            'targetWord': 'ਚੁੱਲ੍ਹਾ',
            'letterBank': ['ਚੁੱ', 'ਲ੍ਹਾ', 'ਕ', 'ੜਾ', 'ਹੀ'],
          },
        },
        {
          'id': 'kitchen_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍳',
            'targetWord': 'ਕੜਾਹੀ',
            'letterBank': ['ਕ', 'ੜਾ', 'ਹੀ', 'ਥਾ', 'ਲੀ'],
          },
        },
        {
          'id': 'kitchen_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍛',
            'targetWord': 'ਥਾਲੀ',
            'letterBank': ['ਥਾ', 'ਲੀ', 'ਚਮ', 'ਕਾਂ', 'ਟਾ'],
          },
        },
      ],
    },
    {
      'id': 'section_nature',
      'title': 'Nature',
      'tasks': [
        {
          'id': 'nature_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌳',
            'targetWord': 'ਰੁੱਖ',
            'letterBank': ['ਰੁੱ', 'ਖ', 'ਫੁੱ', 'ਲ', 'ਪ'],
          },
        },
        {
          'id': 'nature_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌸',
            'targetWord': 'ਫੁੱਲ',
            'letterBank': ['ਫੁੱ', 'ਲ', 'ਪ', 'ਹਾੜ', 'ਦ'],
          },
        },
        {
          'id': 'nature_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⛰️',
            'targetWord': 'ਪਹਾੜ',
            'letterBank': ['ਪ', 'ਹਾੜ', 'ਦ', 'ਰਿ', 'ਆ'],
          },
        },
        {
          'id': 'nature_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏞️',
            'targetWord': 'ਦਰਿਆ',
            'letterBank': ['ਦ', 'ਰਿ', 'ਆ', 'ਸ', 'ਮੁੰ'],
          },
        },
        {
          'id': 'nature_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌊',
            'targetWord': 'ਸਮੁੰਦਰ',
            'letterBank': ['ਸ', 'ਮੁੰ', 'ਦਰ', 'ਜੰ', 'ਗਲ'],
          },
        },
        {
          'id': 'nature_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌲',
            'targetWord': 'ਜੰਗਲ',
            'letterBank': ['ਜੰ', 'ਗਲ', 'ਪੱ', 'ਤਾ', 'ਘਾ'],
          },
        },
        {
          'id': 'nature_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍃',
            'targetWord': 'ਪੱਤਾ',
            'letterBank': ['ਪੱ', 'ਤਾ', 'ਘਾ', 'ਹ', 'ਅ'],
          },
        },
        {
          'id': 'nature_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌿',
            'targetWord': 'ਘਾਹ',
            'letterBank': ['ਘਾ', 'ਹ', 'ਅ', 'ਸ', 'ਮਾਨ'],
          },
        },
        {
          'id': 'nature_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🌌',
            'targetWord': 'ਅਸਮਾਨ',
            'letterBank': ['ਅ', 'ਸ', 'ਮਾਨ', 'ਰੇ', 'ਤ'],
          },
        },
        {
          'id': 'nature_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏖️',
            'targetWord': 'ਰੇਤ',
            'letterBank': ['ਰੇ', 'ਤ', 'ਰੁੱ', 'ਖ', 'ਫੁੱ'],
          },
        },
      ],
    },
    {
      'id': 'section_birds',
      'title': 'Birds',
      'tasks': [
        {
          'id': 'birds_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦜',
            'targetWord': 'ਤੋਤਾ',
            'letterBank': ['ਤੋ', 'ਤਾ', 'ਕਾ', 'ਂ', 'ਕ'],
          },
        },
        {
          'id': 'birds_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐦‍⬛',
            'targetWord': 'ਕਾਂ',
            'letterBank': ['ਕਾ', 'ਂ', 'ਕ', 'ਬੂ', 'ਤਰ'],
          },
        },
        {
          'id': 'birds_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🕊️',
            'targetWord': 'ਕਬੂਤਰ',
            'letterBank': ['ਕ', 'ਬੂ', 'ਤਰ', 'ਮੋ', 'ਰ'],
          },
        },
        {
          'id': 'birds_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦚',
            'targetWord': 'ਮੋਰ',
            'letterBank': ['ਮੋ', 'ਰ', 'ਬਾ', 'ਜ਼', 'ਉੱ'],
          },
        },
        {
          'id': 'birds_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦅',
            'targetWord': 'ਬਾਜ਼',
            'letterBank': ['ਬਾ', 'ਜ਼', 'ਉੱ', 'ਲੂ', 'ਚਿ'],
          },
        },
        {
          'id': 'birds_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦉',
            'targetWord': 'ਉੱਲੂ',
            'letterBank': ['ਉੱ', 'ਲੂ', 'ਚਿ', 'ੜੀ', 'ਮੁਰ'],
          },
        },
        {
          'id': 'birds_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐦',
            'targetWord': 'ਚਿੜੀ',
            'letterBank': ['ਚਿ', 'ੜੀ', 'ਮੁਰ', 'ਗੀ', 'ਹੰ'],
          },
        },
        {
          'id': 'birds_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐔',
            'targetWord': 'ਮੁਰਗੀ',
            'letterBank': ['ਮੁਰ', 'ਗੀ', 'ਹੰ', 'ਸ', 'ਚਮ'],
          },
        },
        {
          'id': 'birds_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦢',
            'targetWord': 'ਹੰਸ',
            'letterBank': ['ਹੰ', 'ਸ', 'ਚਮ', 'ਗਿੱ', 'ਦੜ'],
          },
        },
        {
          'id': 'birds_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🦇',
            'targetWord': 'ਚਮਗਿੱਦੜ',
            'letterBank': ['ਚਮ', 'ਗਿੱ', 'ਦੜ', 'ਤੋ', 'ਤਾ'],
          },
        },
      ],
    },
    {
      'id': 'section_days',
      'title': 'Days',
      'tasks': [
        {
          'id': 'days_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📅',
            'targetWord': 'ਸੋਮਵਾਰ',
            'letterBank': ['ਸੋਮ', 'ਵਾਰ', 'ਮੰਗਲ', 'ਬੁੱਧ', ' '],
          },
        },
        {
          'id': 'days_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📅',
            'targetWord': 'ਮੰਗਲਵਾਰ',
            'letterBank': ['ਮੰਗਲ', 'ਵਾਰ', 'ਬੁੱਧ', 'ਵੀਰ', 'ਸੋਮ'],
          },
        },
        {
          'id': 'days_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📅',
            'targetWord': 'ਬੁੱਧਵਾਰ',
            'letterBank': ['ਬੁੱਧ', 'ਵਾਰ', 'ਵੀਰ', 'ਸ਼ੁੱਕਰ', 'ਮੰਗਲ'],
          },
        },
        {
          'id': 'days_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📅',
            'targetWord': 'ਵੀਰਵਾਰ',
            'letterBank': ['ਵੀਰ', 'ਵਾਰ', 'ਸ਼ੁੱਕਰ', 'ਸ਼ਨੀ', 'ਬੁੱਧ'],
          },
        },
        {
          'id': 'days_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📅',
            'targetWord': 'ਸ਼ੁੱਕਰਵਾਰ',
            'letterBank': ['ਸ਼ੁੱਕਰ', 'ਵਾਰ', 'ਸ਼ਨੀ', 'ਐਤ', 'ਵੀਰ'],
          },
        },
        {
          'id': 'days_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📅',
            'targetWord': 'ਸ਼ਨੀਵਾਰ',
            'letterBank': ['ਸ਼ਨੀ', 'ਵਾਰ', 'ਐਤ', 'ਸੋਮ', 'ਸ਼ੁੱਕਰ'],
          },
        },
        {
          'id': 'days_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📅',
            'targetWord': 'ਐਤਵਾਰ',
            'letterBank': ['ਐਤ', 'ਵਾਰ', 'ਸੋਮ', 'ਮੰਗਲ', 'ਸ਼ਨੀ'],
          },
        },
        {
          'id': 'days_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '👉',
            'targetWord': 'ਅੱਜ',
            'letterBank': ['ਅੱ', 'ਜ', 'ਕੱ', 'ਲ੍ਹ', 'ਪਰ'],
          },
        },
        {
          'id': 'days_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⏭️',
            'targetWord': 'ਕੱਲ੍ਹ',
            'letterBank': ['ਕੱ', 'ਲ੍ਹ', 'ਪਰ', 'ਸੋਂ', 'ਅੱ'],
          },
        },
        {
          'id': 'days_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⏭️',
            'targetWord': 'ਪਰਸੋਂ',
            'letterBank': ['ਪਰ', 'ਸੋਂ', 'ਅੱ', 'ਜ', 'ਕੱ'],
          },
        },
      ],
    },
    {
      'id': 'section_directions',
      'title': 'Directions',
      'tasks': [
        {
          'id': 'directions_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⬆️',
            'targetWord': 'ਉੱਤਰ',
            'letterBank': ['ਉੱ', 'ਤਰ', 'ਦੱ', 'ਖਣ', 'ਪੂਰ'],
          },
        },
        {
          'id': 'directions_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⬇️',
            'targetWord': 'ਦੱਖਣ',
            'letterBank': ['ਦੱ', 'ਖਣ', 'ਪੂਰ', 'ਬ', 'ਪੱ'],
          },
        },
        {
          'id': 'directions_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '➡️',
            'targetWord': 'ਪੂਰਬ',
            'letterBank': ['ਪੂਰ', 'ਬ', 'ਪੱ', 'ਛਮ', 'ਉੱ'],
          },
        },
        {
          'id': 'directions_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⬅️',
            'targetWord': 'ਪੱਛਮ',
            'letterBank': ['ਪੱ', 'ਛਮ', 'ਉੱ', 'ਪਰ', 'ਹੇ'],
          },
        },
        {
          'id': 'directions_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🔼',
            'targetWord': 'ਉੱਪਰ',
            'letterBank': ['ਉੱ', 'ਪਰ', 'ਹੇ', 'ਠਾਂ', 'ਖੱ'],
          },
        },
        {
          'id': 'directions_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🔽',
            'targetWord': 'ਹੇਠਾਂ',
            'letterBank': ['ਹੇ', 'ਠਾਂ', 'ਖੱ', 'ਬੇ', 'ਸੱ'],
          },
        },
        {
          'id': 'directions_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '◀️',
            'targetWord': 'ਖੱਬੇ',
            'letterBank': ['ਖੱ', 'ਬੇ', 'ਸੱ', 'ਜੇ', 'ਅੱ'],
          },
        },
        {
          'id': 'directions_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '▶️',
            'targetWord': 'ਸੱਜੇ',
            'letterBank': ['ਸੱ', 'ਜੇ', 'ਅੱ', 'ਗੇ', 'ਪਿੱ'],
          },
        },
        {
          'id': 'directions_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⏩',
            'targetWord': 'ਅੱਗੇ',
            'letterBank': ['ਅੱ', 'ਗੇ', 'ਪਿੱ', 'ਛੇ', 'ਉੱ'],
          },
        },
        {
          'id': 'directions_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⏪',
            'targetWord': 'ਪਿੱਛੇ',
            'letterBank': ['ਪਿੱ', 'ਛੇ', 'ਉੱ', 'ਤਰ', 'ਦੱ'],
          },
        },
      ],
    },
    {
      'id': 'section_office',
      'title': 'Office',
      'tasks': [
        {
          'id': 'office_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏢',
            'targetWord': 'ਦਫ਼ਤਰ',
            'letterBank': ['ਦਫ਼', 'ਤਰ', 'ਕੰ', 'ਪਿ', 'ਊ'],
          },
        },
        {
          'id': 'office_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '💻',
            'targetWord': 'ਕੰਪਿਊਟਰ',
            'letterBank': ['ਕੰ', 'ਪਿ', 'ਊ', 'ਟਰ', 'ਫ਼ਾ'],
          },
        },
        {
          'id': 'office_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📁',
            'targetWord': 'ਫ਼ਾਈਲ',
            'letterBank': ['ਫ਼ਾ', 'ਈਲ', 'ਪ੍ਰਿੰ', 'ਟਰ', 'ਫੋ'],
          },
        },
        {
          'id': 'office_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🖨️',
            'targetWord': 'ਪ੍ਰਿੰਟਰ',
            'letterBank': ['ਪ੍ਰਿੰ', 'ਟਰ', 'ਫੋ', 'ਨ', 'ਘ'],
          },
        },
        {
          'id': 'office_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📞',
            'targetWord': 'ਫੋਨ',
            'letterBank': ['ਫੋ', 'ਨ', 'ਘ', 'ੜੀ', 'ਸ'],
          },
        },
        {
          'id': 'office_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '⏰',
            'targetWord': 'ਘੜੀ',
            'letterBank': ['ਘ', 'ੜੀ', 'ਸ', 'ਟੈ', 'ਪ'],
          },
        },
        {
          'id': 'office_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📎',
            'targetWord': 'ਸਟੈਪਲਰ',
            'letterBank': ['ਸ', 'ਟੈ', 'ਪ', 'ਲਰ', 'ਲਿਫ਼ਾ'],
          },
        },
        {
          'id': 'office_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '✉️',
            'targetWord': 'ਲਿਫ਼ਾਫ਼ਾ',
            'letterBank': ['ਲਿਫ਼ਾ', 'ਫ਼ਾ', 'ਡਾ', 'ਇ', 'ਰੀ'],
          },
        },
        {
          'id': 'office_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📔',
            'targetWord': 'ਡਾਇਰੀ',
            'letterBank': ['ਡਾ', 'ਇ', 'ਰੀ', 'ਅਲ', 'ਮਾ'],
          },
        },
        {
          'id': 'office_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🗄️',
            'targetWord': 'ਅਲਮਾਰੀ',
            'letterBank': ['ਅਲ', 'ਮਾ', 'ਰੀ', 'ਦਫ਼', 'ਤਰ'],
          },
        },
      ],
    },
    {
      'id': 'section_shopping',
      'title': 'Shopping',
      'tasks': [
        {
          'id': 'shopping_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '💰',
            'targetWord': 'ਪੈਸਾ',
            'letterBank': ['ਪੈ', 'ਸਾ', 'ਦੁ', 'ਕਾਨ', 'ਬਾ'],
          },
        },
        {
          'id': 'shopping_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏪',
            'targetWord': 'ਦੁਕਾਨ',
            'letterBank': ['ਦੁ', 'ਕਾਨ', 'ਬਾ', 'ਜ਼ਾਰ', 'ਕੀ'],
          },
        },
        {
          'id': 'shopping_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏬',
            'targetWord': 'ਬਾਜ਼ਾਰ',
            'letterBank': ['ਬਾ', 'ਜ਼ਾਰ', 'ਕੀ', 'ਮਤ', 'ਥੈ'],
          },
        },
        {
          'id': 'shopping_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🏷️',
            'targetWord': 'ਕੀਮਤ',
            'letterBank': ['ਕੀ', 'ਮਤ', 'ਥੈ', 'ਲਾ', 'ਗਾ'],
          },
        },
        {
          'id': 'shopping_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '👜',
            'targetWord': 'ਥੈਲਾ',
            'letterBank': ['ਥੈ', 'ਲਾ', 'ਗਾ', 'ਹਕ', 'ਦੁਕਾਨ'],
          },
        },
        {
          'id': 'shopping_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🙋',
            'targetWord': 'ਗਾਹਕ',
            'letterBank': ['ਗਾ', 'ਹਕ', 'ਦੁਕਾਨ', 'ਦਾਰ', 'ਨੋ'],
          },
        },
        {
          'id': 'shopping_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧑‍💼',
            'targetWord': 'ਦੁਕਾਨਦਾਰ',
            'letterBank': ['ਦੁਕਾਨ', 'ਦਾਰ', 'ਨੋ', 'ਟ', 'ਸਿੱ'],
          },
        },
        {
          'id': 'shopping_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '💵',
            'targetWord': 'ਨੋਟ',
            'letterBank': ['ਨੋ', 'ਟ', 'ਸਿੱ', 'ਕਾ', 'ਰ'],
          },
        },
        {
          'id': 'shopping_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🪙',
            'targetWord': 'ਸਿੱਕਾ',
            'letterBank': ['ਸਿੱ', 'ਕਾ', 'ਰ', 'ਸੀਦ', 'ਪੈ'],
          },
        },
        {
          'id': 'shopping_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🧾',
            'targetWord': 'ਰਸੀਦ',
            'letterBank': ['ਰ', 'ਸੀਦ', 'ਪੈ', 'ਸਾ', 'ਦੁ'],
          },
        },
      ],
    },
    {
      'id': 'section_eating',
      'title': 'Eating',
      'tasks': [
        {
          'id': 'eating_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍽️',
            'targetWord': 'ਖਾਣਾ',
            'letterBank': ['ਖਾ', 'ਣਾ', 'ਰੋ', 'ਟੀ', 'ਦਾ'],
          },
        },
        {
          'id': 'eating_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🫓',
            'targetWord': 'ਰੋਟੀ',
            'letterBank': ['ਰੋ', 'ਟੀ', 'ਦਾ', 'ਲ', 'ਚਾ'],
          },
        },
        {
          'id': 'eating_03',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍲',
            'targetWord': 'ਦਾਲ',
            'letterBank': ['ਦਾ', 'ਲ', 'ਚਾ', 'ਵਲ', 'ਦੁੱ'],
          },
        },
        {
          'id': 'eating_04',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍚',
            'targetWord': 'ਚਾਵਲ',
            'letterBank': ['ਚਾ', 'ਵਲ', 'ਦੁੱ', 'ਧ', 'ਪਾ'],
          },
        },
        {
          'id': 'eating_05',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🥛',
            'targetWord': 'ਦੁੱਧ',
            'letterBank': ['ਦੁੱ', 'ਧ', 'ਪਾ', 'ਣੀ', 'ਚਾ'],
          },
        },
        {
          'id': 'eating_06',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '💧',
            'targetWord': 'ਪਾਣੀ',
            'letterBank': ['ਪਾ', 'ਣੀ', 'ਚਾ', 'ਹ', 'ਸ'],
          },
        },
        {
          'id': 'eating_07',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '☕',
            'targetWord': 'ਚਾਹ',
            'letterBank': ['ਚਾ', 'ਹ', 'ਸ', 'ਬ', 'ਜ਼ੀ'],
          },
        },
        {
          'id': 'eating_08',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🥦',
            'targetWord': 'ਸਬਜ਼ੀ',
            'letterBank': ['ਸ', 'ਬ', 'ਜ਼ੀ', 'ਮਿੱ', 'ਠਾ'],
          },
        },
        {
          'id': 'eating_09',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍮',
            'targetWord': 'ਮਿੱਠਾ',
            'letterBank': ['ਮਿੱ', 'ਠਾ', 'ਨਾਸ਼', 'ਤਾ', 'ਖਾ'],
          },
        },
        {
          'id': 'eating_10',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🍳',
            'targetWord': 'ਨਾਸ਼ਤਾ',
            'letterBank': ['ਨਾਸ਼', 'ਤਾ', 'ਖਾ', 'ਣਾ', 'ਰੋ'],
          },
        },
      ],
    },
  ],
};
