import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The active tab index in the main [JourneyScreen].
/// 0: Journey, 1: Shop, 2: Profile
final mainNavigationProvider = StateProvider<int>((ref) => 0);
