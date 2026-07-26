import 'package:flutter/material.dart';
import '../../config/content_ids.dart';

/// Configuration for the "Word Bubbles" game.
final Map<String, dynamic> wordBubbleGameConfig = {
  'id': ContentIds.bubblePopWords,
  'title': 'Word Bubbles',
  'unlockAfterLessonId': ContentIds.matchingWords,
  'type': 'bubble_pop',
  'mapXOffset': -110.0, // Tucked into the left tree line
  'mapYOffset': -20.0, // Slightly above the lesson node to avoid bottom edge
  'icon': 'menu_book',
  'color': const Color(0xFF9C27B0),
  'content': {
    'spawnRateMs': 1200,
    'minSpeed': 0.0,
    'maxSpeed': 2.0,
    'bubbleSize': 180.0, // Larger for words
    'letters': [
      'ਸਕੂਲ',
      'ਕਿਤਾਬ',
      'ਸੇਬ',
      'ਦੁੱਧ',
      'ਬਿੱਲੀ',
      'ਗੇਂਦ',
      'ਖਾਣਾ',
      'ਮਾਂ',
      'ਪਿਤਾ',
      'ਭਰਾ',
      'ਪਾਣੀ',
      'ਰੋਟੀ',
      'ਫੁੱਲ',
      'ਘਰ',
      'ਕੁੱਤਾ',
      'ਭੈਣ',
      'ਅੰਬ',
      'ਕੇਲਾ',
      'ਚਿੜੀ',
      'ਹਾਥੀ',
      'ਸ਼ੇਰ',
      'ਤੋਤਾ',
      'ਮੋਰ',
      'ਕੁਰਸੀ',
      'ਮੇਜ਼',
      'ਕਲਮ',
      'ਬਾਗ',
      'ਸੂਰਜ',
      'ਚੰਦ',
      'ਤਾਰੇ',
      'ਪਪੀਤਾ',
      'ਗਾਜਰ',
      'ਟਮਾਟਰ',
      'ਸੰਤਰਾ',
      'ਅਨਾਰ',
    ],
  },
};
