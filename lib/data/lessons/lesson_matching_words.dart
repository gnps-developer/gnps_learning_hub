import '../../config/content_ids.dart';

/// Lesson data for "Match the Words (Translation)".
final Map<String, dynamic> lessonMatchingWords = {
  'id': ContentIds.matchingWords,
  'title': 'Match the Words',
  'order': 5,
  'shuffleSections': true,
  'shuffleTasks': true,
  'visible': true,
  'sections': [
    {
      'id': 'section_match_months',
      'title': 'Months of the Year',
      'tasks': [
        {
          'id': 'mw_months_01',
          'type': 'matchingWords',
          'pointsAwarded': 25,
          'content': {
            'pairs': {
              'ਜਨਵਰੀ': 'January',
              'ਫ਼ਰਵਰੀ': 'February',
              'ਮਾਰਚ': 'March',
              'ਅਪ੍ਰੈਲ': 'April',
            },
          },
        },
        {
          'id': 'mw_months_02',
          'type': 'matchingWords',
          'pointsAwarded': 25,
          'content': {
            'pairs': {
              'ਮਈ': 'May',
              'ਜੂਨ': 'June',
              'ਜੁਲਾਈ': 'July',
              'ਅਗਸਤ': 'August',
            },
          },
        },
        {
          'id': 'mw_months_03',
          'type': 'matchingWords',
          'pointsAwarded': 25,
          'content': {
            'pairs': {
              'ਸਤੰਬਰ': 'September',
              'ਅਕਤੂਬਰ': 'October',
              'ਨਵੰਬਰ': 'November',
              'ਦਸੰਬਰ': 'December',
            },
          },
        },
      ],
    },
    {
      'id': 'section_match_colors',
      'title': 'Colors',
      'tasks': [
        {
          'id': 'mw_colors_01',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਲਾਲ': 'Red',
              'ਨੀਲਾ': 'Blue',
              'ਪੀਲਾ': 'Yellow',
              'ਹਰਾ': 'Green',
            },
          },
        },
        {
          'id': 'mw_colors_02',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਕਾਲਾ': 'Black',
              'ਚਿੱਟਾ': 'White',
              'ਸੰਤਰੀ': 'Orange',
              'ਗੁਲਾਬੀ': 'Pink',
            },
          },
        },
      ],
    },
    {
      'id': 'section_match_animals',
      'title': 'Animals',
      'tasks': [
        {
          'id': 'mw_animals_01',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਬਿੱਲੀ': 'Cat',
              'ਕੁੱਤਾ': 'Dog',
              'ਹਾਥੀ': 'Elephant',
              'ਸ਼ੇਰ': 'Lion',
            },
          },
        },
        {
          'id': 'mw_animals_02',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਘੋੜਾ': 'Horse',
              'ਮੱਛੀ': 'Fish',
              'ਬਾਂਦਰ': 'Monkey',
              'ਊਠ': 'Camel',
            },
          },
        },
      ],
    },
    {
      'id': 'section_match_food',
      'title': 'Food & Drink',
      'tasks': [
        {
          'id': 'mw_food_01',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਰੋਟੀ': 'Bread',
              'ਪਾਣੀ': 'Water',
              'ਦੁੱਧ': 'Milk',
              'ਚਾਵਲ': 'Rice',
            },
          },
        },
        {
          'id': 'mw_food_02',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਸੇਬ': 'Apple',
              'ਕੇਲਾ': 'Banana',
              'ਅੰਬ': 'Mango',
              'ਅਨਾਰ': 'Pomegranate',
            },
          },
        },
      ],
    },
    {
      'id': 'section_match_days',
      'title': 'Days of the Week',
      'tasks': [
        {
          'id': 'mw_days_01',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਸੋਮਵਾਰ': 'Monday',
              'ਮੰਗਲਵਾਰ': 'Tuesday',
              'ਬੁੱਧਵਾਰ': 'Wednesday',
              'ਵੀਰਵਾਰ': 'Thursday',
            },
          },
        },
        {
          'id': 'mw_days_02',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਸ਼ੁੱਕਰਵਾਰ': 'Friday',
              'ਸ਼ਨੀਵਾਰ': 'Saturday',
              'ਐਤਵਾਰ': 'Sunday',
              'ਅੱਜ': 'Today',
            },
          },
        },
      ],
    },
    {
      'id': 'section_match_directions',
      'title': 'Directions',
      'tasks': [
        {
          'id': 'mw_dir_01',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਉੱਤਰ': 'North',
              'ਦੱਖਣ': 'South',
              'ਪੂਰਬ': 'East',
              'ਪੱਛਮ': 'West',
            },
          },
        },
        {
          'id': 'mw_dir_02',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਉੱਪਰ': 'Up',
              'ਹੇਠਾਂ': 'Down',
              'ਖੱਬੇ': 'Left',
              'ਸੱਜੇ': 'Right',
            },
          },
        },
      ],
    },
    {
      'id': 'section_match_nature',
      'title': 'Nature',
      'tasks': [
        {
          'id': 'mw_nature_01',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਰੁੱਖ': 'Tree',
              'ਫੁੱਲ': 'Flower',
              'ਪਹਾੜ': 'Mountain',
              'ਦਰਿਆ': 'River',
            },
          },
        },
        {
          'id': 'mw_nature_02',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਸਮੁੰਦਰ': 'Sea',
              'ਜੰਗਲ': 'Forest',
              'ਅਸਮਾਨ': 'Sky',
              'ਰੇਤ': 'Sand',
            },
          },
        },
      ],
    },
    {
      'id': 'section_match_objects',
      'title': 'Common Objects',
      'tasks': [
        {
          'id': 'mw_obj_01',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਕਿਤਾਬ': 'Book',
              'ਕਲਮ': 'Pen',
              'ਮੇਜ਼': 'Table',
              'ਕੁਰਸੀ': 'Chair',
            },
          },
        },
        {
          'id': 'mw_obj_02',
          'type': 'matchingWords',
          'pointsAwarded': 20,
          'content': {
            'pairs': {
              'ਬਸਤਾ': 'Bag',
              'ਘੜੀ': 'Clock',
              'ਘਰ': 'House',
              'ਪਾਣੀ': 'Water',
            },
          },
        },
      ],
    },
  ],
};
