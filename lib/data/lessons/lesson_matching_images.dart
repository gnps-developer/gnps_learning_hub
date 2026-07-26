import '../../config/content_ids.dart';

/// Lesson data for "Match the Word".
/// Part of the app's bundled content store (see `lib/data/journey_data.dart`).
///
/// Expanded to match the vocabulary introduced in lessonSpelling. Existing
/// tasks/ids were preserved as-is; new tasks were appended to reach 10 per
/// section. Sections mirror lessonSpelling except "Days", which was omitted —
/// days of the week have no visually distinct emoji, so word-to-emoji
/// matching doesn't work for them (see chat note).
final Map<String, dynamic> lessonMatchingImages = {
  'id': ContentIds.matchingPictures,
  'title': 'Match the Picture',
  'order': 4,
  'shuffleSections': true,
  'shuffleTasks': true,
  'visible': true,
  'sections': [
    {
      'id': 'section_matching_animals',
      'title': 'Animals',
      'tasks': [
        {
          'id': 'wordSelect_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਿੱਲੀ',
            'correctEmoji': '🐱',
            'distractorEmojis': ['🦮', '📖', '☀️'],
          },
        },
        {
          'id': 'wordSelect_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੁੱਤਾ',
            'correctEmoji': '🦮',
            'distractorEmojis': ['🐱', '🐟', '🐴'],
          },
        },
        {
          'id': 'wordSelect_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮੱਛੀ',
            'correctEmoji': '🐟',
            'distractorEmojis': ['🐘', '🐱', '🦮'],
          },
        },
        {
          'id': 'animals_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਘੋੜਾ',
            'correctEmoji': '🐴',
            'distractorEmojis': ['🐘', '🐒', '🐫'],
          },
        },
        {
          'id': 'animals_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਹਾਥੀ',
            'correctEmoji': '🐘',
            'distractorEmojis': ['🦁', '🦆', '🐱'],
          },
        },
        {
          'id': 'animals_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸ਼ੇਰ',
            'correctEmoji': '🦁',
            'distractorEmojis': ['🐒', '🐻', '🦮'],
          },
        },
        {
          'id': 'animals_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਾਂਦਰ',
            'correctEmoji': '🐒',
            'distractorEmojis': ['🦆', '🐫', '🐟'],
          },
        },
        {
          'id': 'animals_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬੱਤਖ',
            'correctEmoji': '🦆',
            'distractorEmojis': ['🐻', '🐱', '🐴'],
          },
        },
        {
          'id': 'animals_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਭਾਲੂ',
            'correctEmoji': '🐻',
            'distractorEmojis': ['🐫', '🦮', '🐘'],
          },
        },
        {
          'id': 'animals_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਊਠ',
            'correctEmoji': '🐫',
            'distractorEmojis': ['🐱', '🐟', '🦁'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_objects_household',
      'title': 'Everyday Objects & Household',
      'tasks': [
        {
          'id': 'objhh_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਿਤਾਬ',
            'correctEmoji': '📖',
            'distractorEmojis': ['☀️', '⭐', '🚪'],
          },
        },
        {
          'id': 'objhh_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸੂਰਜ',
            'correctEmoji': '☀️',
            'distractorEmojis': ['⚽', '🌙', '🪟'],
          },
        },
        {
          'id': 'objhh_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਗੇਂਦ',
            'correctEmoji': '⚽',
            'distractorEmojis': ['⭐', '🪑', '🛏️'],
          },
        },
        {
          'id': 'objhh_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਤਾਰਾ',
            'correctEmoji': '⭐',
            'distractorEmojis': ['🌙', '🚪', '🛋️'],
          },
        },
        {
          'id': 'objhh_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚੰਦ',
            'correctEmoji': '🌙',
            'distractorEmojis': ['🪑', '🪟', '📖'],
          },
        },
        {
          'id': 'objhh_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੁਰਸੀ',
            'correctEmoji': '🪑',
            'distractorEmojis': ['🚪', '🛏️', '☀️'],
          },
        },
        {
          'id': 'objhh_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦਰਵਾਜ਼ਾ',
            'correctEmoji': '🚪',
            'distractorEmojis': ['🪟', '🛋️', '⚽'],
          },
        },
        {
          'id': 'objhh_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਖਿੜਕੀ',
            'correctEmoji': '🪟',
            'distractorEmojis': ['🛏️', '📖', '⭐'],
          },
        },
        {
          'id': 'objhh_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮੰਜਾ',
            'correctEmoji': '🛏️',
            'distractorEmojis': ['🛋️', '☀️', '🌙'],
          },
        },
        {
          'id': 'objhh_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸੋਫ਼ਾ',
            'correctEmoji': '🛋️',
            'distractorEmojis': ['📖', '⚽', '🪑'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_fruits',
      'title': 'Fruits',
      'tasks': [
        {
          'id': 'fruits_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸੇਬ',
            'correctEmoji': '🍎',
            'distractorEmojis': ['🍌', '🍊', '🍍'],
          },
        },
        {
          'id': 'fruits_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੇਲਾ',
            'correctEmoji': '🍌',
            'distractorEmojis': ['🥭', '🍇', '🍑'],
          },
        },
        {
          'id': 'fruits_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਅੰਬ',
            'correctEmoji': '🥭',
            'distractorEmojis': ['🍊', '🍉', '🍐'],
          },
        },
        {
          'id': 'fruits_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸੰਤਰਾ',
            'correctEmoji': '🍊',
            'distractorEmojis': ['🍇', '🍍', '🍋'],
          },
        },
        {
          'id': 'fruits_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਅੰਗੂਰ',
            'correctEmoji': '🍇',
            'distractorEmojis': ['🍉', '🍑', '🍎'],
          },
        },
        {
          'id': 'fruits_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਤਰਬੂਜ਼',
            'correctEmoji': '🍉',
            'distractorEmojis': ['🍍', '🍐', '🍌'],
          },
        },
        {
          'id': 'fruits_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਅਨਾਨਾਸ',
            'correctEmoji': '🍍',
            'distractorEmojis': ['🍑', '🍋', '🥭'],
          },
        },
        {
          'id': 'fruits_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਆੜੂ',
            'correctEmoji': '🍑',
            'distractorEmojis': ['🍐', '🍎', '🍊'],
          },
        },
        {
          'id': 'fruits_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਨਾਸ਼ਪਾਤੀ',
            'correctEmoji': '🍐',
            'distractorEmojis': ['🍋', '🍌', '🍇'],
          },
        },
        {
          'id': 'fruits_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਨਿੰਬੂ',
            'correctEmoji': '🍋',
            'distractorEmojis': ['🍎', '🥭', '🍉'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_colors',
      'title': 'Colors',
      'tasks': [
        {
          'id': 'wordSelect_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਲਾਲ',
            'correctEmoji': '🔴',
            'distractorEmojis': ['🔵', '🟡', '🟢'],
          },
        },
        {
          'id': 'wordSelect_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਹਰਾ',
            'correctEmoji': '🟢',
            'distractorEmojis': ['⚫', '⚪', '🔵'],
          },
        },
        {
          'id': 'colors_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਨੀਲਾ',
            'correctEmoji': '🔵',
            'distractorEmojis': ['🟡', '⚫', '🩷'],
          },
        },
        {
          'id': 'colors_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪੀਲਾ',
            'correctEmoji': '🟡',
            'distractorEmojis': ['🟢', '⚪', '🟤'],
          },
        },
        {
          'id': 'colors_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਾਲਾ',
            'correctEmoji': '⚫',
            'distractorEmojis': ['⚪', '🩷', '🔴'],
          },
        },
        {
          'id': 'colors_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚਿੱਟਾ',
            'correctEmoji': '⚪',
            'distractorEmojis': ['🟠', '🟤', '🔵'],
          },
        },
        {
          'id': 'colors_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸੰਤਰੀ',
            'correctEmoji': '🟠',
            'distractorEmojis': ['🩷', '🟣', '🟡'],
          },
        },
        {
          'id': 'colors_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਗੁਲਾਬੀ',
            'correctEmoji': '🩷',
            'distractorEmojis': ['🟤', '🔴', '🟢'],
          },
        },
        {
          'id': 'colors_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਭੂਰਾ',
            'correctEmoji': '🟤',
            'distractorEmojis': ['🟣', '🔵', '⚫'],
          },
        },
        {
          'id': 'colors_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਜਾਮਨੀ',
            'correctEmoji': '🟣',
            'distractorEmojis': ['🔴', '🟡', '⚪'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_travel',
      'title': 'Travel & Transport',
      'tasks': [
        {
          'id': 'travel_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਾਰ',
            'correctEmoji': '🚗',
            'distractorEmojis': ['🚌', '✈️', '🚕'],
          },
        },
        {
          'id': 'travel_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬੱਸ',
            'correctEmoji': '🚌',
            'distractorEmojis': ['🚆', '🚲', '🚚'],
          },
        },
        {
          'id': 'travel_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਰੇਲਗੱਡੀ',
            'correctEmoji': '🚆',
            'distractorEmojis': ['✈️', '🚤', '🏍️'],
          },
        },
        {
          'id': 'travel_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਜਹਾਜ਼',
            'correctEmoji': '✈️',
            'distractorEmojis': ['🚲', '🚕', '🚁'],
          },
        },
        {
          'id': 'travel_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸਾਈਕਲ',
            'correctEmoji': '🚲',
            'distractorEmojis': ['🚤', '🚚', '🚗'],
          },
        },
        {
          'id': 'travel_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਿਸ਼ਤੀ',
            'correctEmoji': '🚤',
            'distractorEmojis': ['🚕', '🏍️', '🚌'],
          },
        },
        {
          'id': 'travel_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਟੈਕਸੀ',
            'correctEmoji': '🚕',
            'distractorEmojis': ['🚚', '🚁', '🚆'],
          },
        },
        {
          'id': 'travel_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਟਰੱਕ',
            'correctEmoji': '🚚',
            'distractorEmojis': ['🏍️', '🚗', '✈️'],
          },
        },
        {
          'id': 'travel_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮੋਟਰਸਾਈਕਲ',
            'correctEmoji': '🏍️',
            'distractorEmojis': ['🚁', '🚌', '🚲'],
          },
        },
        {
          'id': 'travel_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਹੈਲੀਕਾਪਟਰ',
            'correctEmoji': '🚁',
            'distractorEmojis': ['🚗', '🚆', '🚤'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_school',
      'title': 'School',
      'tasks': [
        {
          'id': 'school_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪੈਨਸਿਲ',
            'correctEmoji': '✏️',
            'distractorEmojis': ['🖊️', '🧑‍🏫', '🧑‍🎓'],
          },
        },
        {
          'id': 'school_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਲਮ',
            'correctEmoji': '🖊️',
            'distractorEmojis': ['🎒', '📝', '🧼'],
          },
        },
        {
          'id': 'school_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਸਤਾ',
            'correctEmoji': '🎒',
            'distractorEmojis': ['🧑‍🏫', '🏫', '🏢'],
          },
        },
        {
          'id': 'school_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਗੁਰੂ',
            'correctEmoji': '🧑‍🏫',
            'distractorEmojis': ['📝', '🧑‍🎓', '🪑'],
          },
        },
        {
          'id': 'school_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਤਖਤੀ',
            'correctEmoji': '📝',
            'distractorEmojis': ['🏫', '🧼', '✏️'],
          },
        },
        {
          'id': 'school_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਜਮਾਤ',
            'correctEmoji': '🏫',
            'distractorEmojis': ['🧑‍🎓', '🏢', '🖊️'],
          },
        },
        {
          'id': 'school_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਵਿਦਿਆਰਥੀ',
            'correctEmoji': '🧑‍🎓',
            'distractorEmojis': ['🧼', '🪑', '🎒'],
          },
        },
        {
          'id': 'school_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਰਬੜ',
            'correctEmoji': '🧼',
            'distractorEmojis': ['🏢', '✏️', '🧑‍🏫'],
          },
        },
        {
          'id': 'school_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸਕੂਲ',
            'correctEmoji': '🏢',
            'distractorEmojis': ['🪑', '🖊️', '📝'],
          },
        },
        {
          'id': 'school_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮੇਜ਼',
            'correctEmoji': '🪑',
            'distractorEmojis': ['✏️', '🎒', '🏫'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_weather',
      'title': 'Weather',
      'tasks': [
        {
          'id': 'weather_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮੀਂਹ',
            'correctEmoji': '🌧️',
            'distractorEmojis': ['☁️', '❄️', '🥵'],
          },
        },
        {
          'id': 'weather_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬੱਦਲ',
            'correctEmoji': '☁️',
            'distractorEmojis': ['💨', '🌫️', '🥶'],
          },
        },
        {
          'id': 'weather_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਹਵਾ',
            'correctEmoji': '💨',
            'distractorEmojis': ['❄️', '☀️', '⚡'],
          },
        },
        {
          'id': 'weather_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਰਫ਼',
            'correctEmoji': '❄️',
            'distractorEmojis': ['🌫️', '🥵', '🌪️'],
          },
        },
        {
          'id': 'weather_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਧੁੰਦ',
            'correctEmoji': '🌫️',
            'distractorEmojis': ['☀️', '🥶', '🌧️'],
          },
        },
        {
          'id': 'weather_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਧੁੱਪ',
            'correctEmoji': '☀️',
            'distractorEmojis': ['🥵', '⚡', '☁️'],
          },
        },
        {
          'id': 'weather_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਗਰਮੀ',
            'correctEmoji': '🥵',
            'distractorEmojis': ['🥶', '🌪️', '💨'],
          },
        },
        {
          'id': 'weather_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸਰਦੀ',
            'correctEmoji': '🥶',
            'distractorEmojis': ['⚡', '🌧️', '❄️'],
          },
        },
        {
          'id': 'weather_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਿਜਲੀ',
            'correctEmoji': '⚡',
            'distractorEmojis': ['🌪️', '☁️', '🌫️'],
          },
        },
        {
          'id': 'weather_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਤੂਫ਼ਾਨ',
            'correctEmoji': '🌪️',
            'distractorEmojis': ['🌧️', '💨', '☀️'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_clothes',
      'title': 'Clothes',
      'tasks': [
        {
          'id': 'clothes_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਮੀਜ਼',
            'correctEmoji': '👕',
            'distractorEmojis': ['👖', '🧢', '🧤'],
          },
        },
        {
          'id': 'clothes_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪੈਂਟ',
            'correctEmoji': '👖',
            'distractorEmojis': ['👟', '🧦', '🧥'],
          },
        },
        {
          'id': 'clothes_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਜੁੱਤੀ',
            'correctEmoji': '👟',
            'distractorEmojis': ['🧢', '🧥', '🧣'],
          },
        },
        {
          'id': 'clothes_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਟੋਪੀ',
            'correctEmoji': '🧢',
            'distractorEmojis': ['🧦', '🧤', '👘'],
          },
        },
        {
          'id': 'clothes_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਜੁਰਾਬ',
            'correctEmoji': '🧦',
            'distractorEmojis': ['🧥', '👟', '👕'],
          },
        },
        {
          'id': 'clothes_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸਵੈਟਰ',
            'correctEmoji': '🧥',
            'distractorEmojis': ['🧤', '🧣', '👖'],
          },
        },
        {
          'id': 'clothes_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦਸਤਾਨੇ',
            'correctEmoji': '🧤',
            'distractorEmojis': ['🧥', '👘', '👟'],
          },
        },
        {
          'id': 'clothes_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੋਟ',
            'correctEmoji': '🧥',
            'distractorEmojis': ['🧣', '👕', '🧢'],
          },
        },
        {
          'id': 'clothes_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਰੁਮਾਲ',
            'correctEmoji': '🧣',
            'distractorEmojis': ['👘', '👖', '🧦'],
          },
        },
        {
          'id': 'clothes_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪਜਾਮਾ',
            'correctEmoji': '👘',
            'distractorEmojis': ['👕', '👟', '🧥'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_kitchen',
      'title': 'Kitchen',
      'tasks': [
        {
          'id': 'kitchen_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚਮਚ',
            'correctEmoji': '🥄',
            'distractorEmojis': ['🍴', '🍲', '🧊'],
          },
        },
        {
          'id': 'kitchen_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਾਂਟਾ',
            'correctEmoji': '🍴',
            'distractorEmojis': ['🔪', '🥛', '🔥'],
          },
        },
        {
          'id': 'kitchen_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਛੁਰੀ',
            'correctEmoji': '🔪',
            'distractorEmojis': ['🍲', '🍽️', '🍳'],
          },
        },
        {
          'id': 'kitchen_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਭਾਂਡਾ',
            'correctEmoji': '🍲',
            'distractorEmojis': ['🥛', '🧊', '🍛'],
          },
        },
        {
          'id': 'kitchen_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਗਲਾਸ',
            'correctEmoji': '🥛',
            'distractorEmojis': ['🍽️', '🔥', '🥄'],
          },
        },
        {
          'id': 'kitchen_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪਲੇਟ',
            'correctEmoji': '🍽️',
            'distractorEmojis': ['🧊', '🍳', '🍴'],
          },
        },
        {
          'id': 'kitchen_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਫਰਿੱਜ',
            'correctEmoji': '🧊',
            'distractorEmojis': ['🔥', '🍛', '🔪'],
          },
        },
        {
          'id': 'kitchen_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚੁੱਲ੍ਹਾ',
            'correctEmoji': '🔥',
            'distractorEmojis': ['🍳', '🥄', '🍲'],
          },
        },
        {
          'id': 'kitchen_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੜਾਹੀ',
            'correctEmoji': '🍳',
            'distractorEmojis': ['🍛', '🍴', '🥛'],
          },
        },
        {
          'id': 'kitchen_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਥਾਲੀ',
            'correctEmoji': '🍛',
            'distractorEmojis': ['🥄', '🔪', '🍽️'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_nature',
      'title': 'Nature',
      'tasks': [
        {
          'id': 'nature_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਰੁੱਖ',
            'correctEmoji': '🌳',
            'distractorEmojis': ['🌸', '🏞️', '🍃'],
          },
        },
        {
          'id': 'nature_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਫੁੱਲ',
            'correctEmoji': '🌸',
            'distractorEmojis': ['⛰️', '🌊', '🌿'],
          },
        },
        {
          'id': 'nature_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪਹਾੜ',
            'correctEmoji': '⛰️',
            'distractorEmojis': ['🏞️', '🌲', '🌌'],
          },
        },
        {
          'id': 'nature_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦਰਿਆ',
            'correctEmoji': '🏞️',
            'distractorEmojis': ['🌊', '🍃', '🏖️'],
          },
        },
        {
          'id': 'nature_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸਮੁੰਦਰ',
            'correctEmoji': '🌊',
            'distractorEmojis': ['🌲', '🌿', '🌳'],
          },
        },
        {
          'id': 'nature_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਜੰਗਲ',
            'correctEmoji': '🌲',
            'distractorEmojis': ['🍃', '🌌', '🌸'],
          },
        },
        {
          'id': 'nature_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪੱਤਾ',
            'correctEmoji': '🍃',
            'distractorEmojis': ['🌿', '🏖️', '⛰️'],
          },
        },
        {
          'id': 'nature_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਘਾਹ',
            'correctEmoji': '🌿',
            'distractorEmojis': ['🌌', '🌳', '🏞️'],
          },
        },
        {
          'id': 'nature_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਅਸਮਾਨ',
            'correctEmoji': '🌌',
            'distractorEmojis': ['🏖️', '🌸', '🌊'],
          },
        },
        {
          'id': 'nature_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਰੇਤ',
            'correctEmoji': '🏖️',
            'distractorEmojis': ['🌳', '⛰️', '🌲'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_birds',
      'title': 'Birds',
      'tasks': [
        {
          'id': 'birds_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਤੋਤਾ',
            'correctEmoji': '🦜',
            'distractorEmojis': ['🐦‍⬛', '🦚', '🐦'],
          },
        },
        {
          'id': 'birds_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਾਂ',
            'correctEmoji': '🐦‍⬛',
            'distractorEmojis': ['🕊️', '🦅', '🐔'],
          },
        },
        {
          'id': 'birds_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਬੂਤਰ',
            'correctEmoji': '🕊️',
            'distractorEmojis': ['🦚', '🦉', '🦢'],
          },
        },
        {
          'id': 'birds_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮੋਰ',
            'correctEmoji': '🦚',
            'distractorEmojis': ['🦅', '🐦', '🦇'],
          },
        },
        {
          'id': 'birds_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਾਜ਼',
            'correctEmoji': '🦅',
            'distractorEmojis': ['🦉', '🐔', '🦜'],
          },
        },
        {
          'id': 'birds_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਉੱਲੂ',
            'correctEmoji': '🦉',
            'distractorEmojis': ['🐦', '🦢', '🐦‍⬛'],
          },
        },
        {
          'id': 'birds_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚਿੜੀ',
            'correctEmoji': '🐦',
            'distractorEmojis': ['🐔', '🦇', '🕊️'],
          },
        },
        {
          'id': 'birds_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮੁਰਗੀ',
            'correctEmoji': '🐔',
            'distractorEmojis': ['🦢', '🦜', '🦚'],
          },
        },
        {
          'id': 'birds_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਹੰਸ',
            'correctEmoji': '🦢',
            'distractorEmojis': ['🦇', '🐦‍⬛', '🦅'],
          },
        },
        {
          'id': 'birds_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚਮਗਿੱਦੜ',
            'correctEmoji': '🦇',
            'distractorEmojis': ['🦜', '🕊️', '🦉'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_directions',
      'title': 'Directions',
      'tasks': [
        {
          'id': 'directions_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਉੱਤਰ',
            'correctEmoji': '⬆️',
            'distractorEmojis': ['⬇️', '⬅️', '◀️'],
          },
        },
        {
          'id': 'directions_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦੱਖਣ',
            'correctEmoji': '⬇️',
            'distractorEmojis': ['➡️', '🔼', '▶️'],
          },
        },
        {
          'id': 'directions_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪੂਰਬ',
            'correctEmoji': '➡️',
            'distractorEmojis': ['⬅️', '🔽', '⏩'],
          },
        },
        {
          'id': 'directions_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪੱਛਮ',
            'correctEmoji': '⬅️',
            'distractorEmojis': ['🔼', '◀️', '⏪'],
          },
        },
        {
          'id': 'directions_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਉੱਪਰ',
            'correctEmoji': '🔼',
            'distractorEmojis': ['🔽', '▶️', '⬆️'],
          },
        },
        {
          'id': 'directions_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਹੇਠਾਂ',
            'correctEmoji': '🔽',
            'distractorEmojis': ['◀️', '⏩', '⬇️'],
          },
        },
        {
          'id': 'directions_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਖੱਬੇ',
            'correctEmoji': '◀️',
            'distractorEmojis': ['▶️', '⏪', '➡️'],
          },
        },
        {
          'id': 'directions_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸੱਜੇ',
            'correctEmoji': '▶️',
            'distractorEmojis': ['⏩', '⬆️', '⬅️'],
          },
        },
        {
          'id': 'directions_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਅੱਗੇ',
            'correctEmoji': '⏩',
            'distractorEmojis': ['⏪', '⬇️', '🔼'],
          },
        },
        {
          'id': 'directions_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪਿੱਛੇ',
            'correctEmoji': '⏪',
            'distractorEmojis': ['⬆️', '➡️', '🔽'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_office',
      'title': 'Office',
      'tasks': [
        {
          'id': 'office_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦਫ਼ਤਰ',
            'correctEmoji': '🏢',
            'distractorEmojis': ['💻', '🖨️', '📎'],
          },
        },
        {
          'id': 'office_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੰਪਿਊਟਰ',
            'correctEmoji': '💻',
            'distractorEmojis': ['📁', '📞', '✉️'],
          },
        },
        {
          'id': 'office_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਫ਼ਾਈਲ',
            'correctEmoji': '📁',
            'distractorEmojis': ['🖨️', '⏰', '📔'],
          },
        },
        {
          'id': 'office_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪ੍ਰਿੰਟਰ',
            'correctEmoji': '🖨️',
            'distractorEmojis': ['📞', '📎', '🗄️'],
          },
        },
        {
          'id': 'office_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਫੋਨ',
            'correctEmoji': '📞',
            'distractorEmojis': ['⏰', '✉️', '🏢'],
          },
        },
        {
          'id': 'office_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਘੜੀ',
            'correctEmoji': '⏰',
            'distractorEmojis': ['📎', '📔', '💻'],
          },
        },
        {
          'id': 'office_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸਟੈਪਲਰ',
            'correctEmoji': '📎',
            'distractorEmojis': ['✉️', '🗄️', '📁'],
          },
        },
        {
          'id': 'office_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਲਿਫ਼ਾਫ਼ਾ',
            'correctEmoji': '✉️',
            'distractorEmojis': ['📔', '🏢', '🖨️'],
          },
        },
        {
          'id': 'office_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਡਾਇਰੀ',
            'correctEmoji': '📔',
            'distractorEmojis': ['🗄️', '💻', '📞'],
          },
        },
        {
          'id': 'office_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਅਲਮਾਰੀ',
            'correctEmoji': '🗄️',
            'distractorEmojis': ['🏢', '📁', '⏰'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_shopping',
      'title': 'Shopping',
      'tasks': [
        {
          'id': 'shopping_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪੈਸਾ',
            'correctEmoji': '💰',
            'distractorEmojis': ['🏪', '🏷️', '🧑‍💼'],
          },
        },
        {
          'id': 'shopping_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦੁਕਾਨ',
            'correctEmoji': '🏪',
            'distractorEmojis': ['🏬', '👜', '💵'],
          },
        },
        {
          'id': 'shopping_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਾਜ਼ਾਰ',
            'correctEmoji': '🏬',
            'distractorEmojis': ['🏷️', '🙋', '🪙'],
          },
        },
        {
          'id': 'shopping_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੀਮਤ',
            'correctEmoji': '🏷️',
            'distractorEmojis': ['👜', '🧑‍💼', '🧾'],
          },
        },
        {
          'id': 'shopping_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਥੈਲਾ',
            'correctEmoji': '👜',
            'distractorEmojis': ['🙋', '💵', '💰'],
          },
        },
        {
          'id': 'shopping_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਗਾਹਕ',
            'correctEmoji': '🙋',
            'distractorEmojis': ['🧑‍💼', '🪙', '🏪'],
          },
        },
        {
          'id': 'shopping_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦੁਕਾਨਦਾਰ',
            'correctEmoji': '🧑‍💼',
            'distractorEmojis': ['💵', '🧾', '🏬'],
          },
        },
        {
          'id': 'shopping_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਨੋਟ',
            'correctEmoji': '💵',
            'distractorEmojis': ['🪙', '💰', '🏷️'],
          },
        },
        {
          'id': 'shopping_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸਿੱਕਾ',
            'correctEmoji': '🪙',
            'distractorEmojis': ['🧾', '🏪', '👜'],
          },
        },
        {
          'id': 'shopping_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਰਸੀਦ',
            'correctEmoji': '🧾',
            'distractorEmojis': ['💰', '🏬', '🙋'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_eating',
      'title': 'Eating',
      'tasks': [
        {
          'id': 'eating_01',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਖਾਣਾ',
            'correctEmoji': '🍽️',
            'distractorEmojis': ['🫓', '🍚', '☕'],
          },
        },
        {
          'id': 'eating_02',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਰੋਟੀ',
            'correctEmoji': '🫓',
            'distractorEmojis': ['🍲', '🥛', '🥦'],
          },
        },
        {
          'id': 'eating_03',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦਾਲ',
            'correctEmoji': '🍲',
            'distractorEmojis': ['🍚', '💧', '🍮'],
          },
        },
        {
          'id': 'eating_04',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚਾਵਲ',
            'correctEmoji': '🍚',
            'distractorEmojis': ['🥛', '☕', '🍳'],
          },
        },
        {
          'id': 'eating_05',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਦੁੱਧ',
            'correctEmoji': '🥛',
            'distractorEmojis': ['💧', '🥦', '🍽️'],
          },
        },
        {
          'id': 'eating_06',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਪਾਣੀ',
            'correctEmoji': '💧',
            'distractorEmojis': ['☕', '🍮', '🫓'],
          },
        },
        {
          'id': 'eating_07',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚਾਹ',
            'correctEmoji': '☕',
            'distractorEmojis': ['🥦', '🍳', '🍲'],
          },
        },
        {
          'id': 'eating_08',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸਬਜ਼ੀ',
            'correctEmoji': '🥦',
            'distractorEmojis': ['🍮', '🍽️', '🍚'],
          },
        },
        {
          'id': 'eating_09',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮਿੱਠਾ',
            'correctEmoji': '🍮',
            'distractorEmojis': ['🍳', '🫓', '🥛'],
          },
        },
        {
          'id': 'eating_10',
          'type': 'matchingPictures',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਨਾਸ਼ਤਾ',
            'correctEmoji': '🍳',
            'distractorEmojis': ['🍽️', '🍲', '💧'],
          },
        },
      ],
    },
  ],
};
