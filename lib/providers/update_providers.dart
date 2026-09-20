import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/review/review_prompt_repository.dart';
import '../services/review/review_service.dart';
import '../services/update/app_update_service.dart';

final appUpdateServiceProvider = Provider<AppUpdateService>((ref) => AppUpdateService());

final reviewServiceProvider = Provider<ReviewService>((ref) => ReviewService());

final reviewPromptRepositoryProvider = Provider<ReviewPromptRepository>(
  (ref) => ReviewPromptRepository(),
);
