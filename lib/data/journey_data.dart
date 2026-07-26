import '../models/journey.dart';
import 'lessons/lesson_tracing.dart';
import 'lessons/lesson_spelling.dart';
import 'lessons/lesson_matching_images.dart';
import 'lessons/lesson_matching_words.dart';
import 'lessons/lesson_letter_selection.dart';
import 'lessons/lesson_fill_in_the_blanks.dart';
import 'lessons/lesson_arrange_sentence.dart';
import 'games/bubble_game_data.dart';
import 'games/word_bubble_game_data.dart';

/// The app's bundled lesson content, packaged locally rather than fetched
/// from a backend. This is the real content source — not placeholder data.
///
/// Each lesson lives in its own file under `lib/data/lessons/` for easier
/// review and maintenance (see `lessons/`). This file just assembles them
/// in `Journey` order.
///
/// ## Versioning content updates
/// Since there's no backend, content changes ship via app releases. Bump
/// [version] whenever lesson content changes in a way that matters to the
/// app (new tasks, corrected words, restructured sections, etc.) so that,
/// if `ContentRepository` ever needs to reason about "is this newer than
/// what the user last saw" (e.g. for progress migration or cache busting),
/// there's a single source of truth to check against.
///
/// ## Moving to a backend later
/// This data mirrors the shape lessons will have in Firestore, so swapping
/// the source later (e.g. `ContentRepository` fetching from Firestore
/// instead of reading this file) shouldn't require changes to models or
/// UI — only to how this `Journey` gets constructed.
///
/// NOTE: Gurmukhi spellings/grammar should be reviewed by a native speaker
/// before wider release.
final Journey journeyData = Journey.fromJson({
  'version': 22,
  'lessons': [
    lessonTracing,
    lessonLetterSelection,
    lessonSpelling,
    lessonMatchingImages,
    lessonMatchingWords,
    lessonFillInBlank,
    lessonArrangeSentence,
  ],
  'games': [
    bubbleGameConfig,
    wordBubbleGameConfig,
  ],
});
