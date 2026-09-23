import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/router/route_paths.dart';
import '../../core/constants/store_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/url_validator.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../../core/widgets/update_available_dialog.dart';
import '../../core/widgets/vidzora_logo.dart';
import '../../providers/api_providers.dart';
import '../../providers/update_providers.dart';
import 'widgets/ad_banner_slot.dart';
import 'widgets/url_input_field.dart';

/// Home screen: URL input, supported platforms, info banner, and ad slot.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();
  String _url = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkForUpdate() async {
    final updateService = ref.read(appUpdateServiceProvider);
    final result = await updateService.checkForUpdate();
    if (!mounted || !result.updateAvailable) return;

    await UpdateAvailableDialog.show(
      context,
      storeVersion: result.storeVersion,
      onUpdate: () async {
        if (Platform.isAndroid) {
          if (result.androidImmediateAllowed) {
            await updateService.startAndroidImmediateUpdate();
          } else {
            await updateService.startAndroidFlexibleUpdate();
          }
        } else if (Platform.isIOS) {
          final uri = Uri.parse(result.storeUrl ?? StoreConfig.iosAppStoreUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
        if (mounted) Navigator.of(context).pop();
      },
    );
  }

  Future<void> _fetch() async {
    final notifier = ref.read(mediaFetchControllerProvider.notifier);
    await notifier.fetch(_url.trim());
    if (!mounted) return;
    final state = ref.read(mediaFetchControllerProvider);
    state.when(
      data: (response) {
        if (response != null) {
          context.push(RoutePaths.mediaResult);
        }
      },
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final fetchState = ref.watch(mediaFetchControllerProvider);
    final isLoading = fetchState.isLoading;
    final isValid = UrlValidator.isValidUrl(_url);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const VidzoraLogo(size: 32, glow: false, borderRadius: 8),
            const SizedBox(width: 10),
            const Text('Vidzora'),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: AppColors.surfaceWhite,
              child: Icon(Icons.settings_rounded, color: AppColors.textPrimary, size: 20),
            ),
            onPressed: () => context.go(RoutePaths.settings),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Save videos from your favorite platforms',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Paste a video link below to get available download options.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    UrlInputField(
                      controller: _controller,
                      onChanged: (value) => setState(() => _url = value),
                    ),
                    const SizedBox(height: 14),
                    PrimaryPillButton(
                      label: 'Get Media',
                      enabled: isValid,
                      isLoading: isLoading,
                      onPressed: isValid ? _fetch : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const AdBannerSlot(),
            ],
          ),
        ),
      ),
    );
  }
}
