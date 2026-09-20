import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/onboarding/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository();
});

/// Whether the user has completed onboarding. Notifies listeners (and thus
/// go_router's redirect logic) when it changes.
class HasSeenOnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.read(onboardingRepositoryProvider).hasSeenOnboarding;
  }

  Future<void> markSeen() async {
    await ref.read(onboardingRepositoryProvider).setHasSeenOnboarding(true);
    state = true;
  }
}

final hasSeenOnboardingProvider = NotifierProvider<HasSeenOnboardingNotifier, bool>(
  HasSeenOnboardingNotifier.new,
);
