import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../game/application/game_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _musicEnabled;
  late bool _sfxEnabled;
  late bool _vibrationEnabled;
  String _locale = 'en';

  @override
  void initState() {
    super.initState();
    final saveService = ref.read(saveServiceProvider);
    _musicEnabled = saveService.musicEnabled;
    _sfxEnabled = saveService.sfxEnabled;
    _vibrationEnabled = saveService.vibrationEnabled;
    _locale = saveService.locale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('Audio', [
            _buildToggle(
              'Music',
              Icons.music_note,
              _musicEnabled,
              (v) {
                setState(() => _musicEnabled = v);
                ref.read(audioServiceProvider).setMusicEnabled(v);
                ref.read(saveServiceProvider).saveSetting('musicEnabled', v);
              },
            ),
            _buildToggle(
              'Sound Effects',
              Icons.volume_up,
              _sfxEnabled,
              (v) {
                setState(() => _sfxEnabled = v);
                ref.read(audioServiceProvider).setSfxEnabled(v);
                ref.read(saveServiceProvider).saveSetting('sfxEnabled', v);
              },
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('General', [
            _buildToggle(
              'Vibration',
              Icons.vibration,
              _vibrationEnabled,
              (v) {
                setState(() => _vibrationEnabled = v);
                ref.read(hapticsServiceProvider).setEnabled(v);
                ref
                    .read(saveServiceProvider)
                    .saveSetting('vibrationEnabled', v);
              },
            ),
            _buildLanguageSelector(),
          ]),
          const SizedBox(height: 16),
          _buildSection('About', [
            _buildInfo('Version', '1.0.0'),
            _buildInfo('Made with', 'Flutter & Chaos'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(
    String label,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      leading:
          const Icon(Icons.language, color: AppColors.primary, size: 22),
      title: const Text('Language'),
      trailing: DropdownButton<String>(
        value: _locale,
        underline: const SizedBox.shrink(),
        items: const [
          DropdownMenuItem(value: 'en', child: Text('English')),
          DropdownMenuItem(value: 'ar', child: Text('العربية')),
        ],
        onChanged: (v) {
          if (v != null) {
            setState(() => _locale = v);
            ref.read(saveServiceProvider).saveSetting('locale', v);
          }
        },
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
