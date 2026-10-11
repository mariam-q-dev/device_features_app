import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class BiometricsAudioScreen extends StatefulWidget {
  const BiometricsAudioScreen({super.key});

  @override
  State<BiometricsAudioScreen> createState() => _BiometricsAudioScreenState();
}

class _BiometricsAudioScreenState extends State<BiometricsAudioScreen> {
  // Biometrics Variables
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;

  // Audio Variables
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;

  // 1. ميثود المصادقة بالبصمة

  Future<void> _authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!canAuthenticateWithBiometrics && !isDeviceSupported) {
        _showMessage('الجهاز لا يدعم البصمة أو لم يتم إعدادها');
        return;
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'يرجى إدخال البصمة للتحقق من الهوية',
      );

      if (!mounted) return;
      setState(() {
        _isAuthenticated = didAuthenticate;
      });
    } catch (e) {
      _showMessage('حدث خطأ أثناء التحقق: $e');
    }
  }

  // 2. ميثود لبدء وإيقاف التسجيل الصوتي
  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        if (!mounted) return;
        setState(() {
          _isRecording = false;
          _audioPath = path;
        });
        _showMessage('تم حفظ التسجيل');
      } else {
        if (await _audioRecorder.hasPermission()) {
          final dir = await getApplicationDocumentsDirectory();
          final filePath = '${dir.path}/my_recording.m4a';

          await _audioRecorder.start(const RecordConfig(), path: filePath);
          if (!mounted) return;
          setState(() {
            _isRecording = true;
          });
        }
      }
    } catch (e) {
      _showMessage('خطأ في التسجيل: $e');
    }
  }

  // 3. ميثود لتشغيل وإيقاف الصوت المسجل
  Future<void> _togglePlayAudio() async {
    if (_audioPath == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        if (!mounted) return;
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(DeviceFileSource(_audioPath!));
        if (!mounted) return;
        setState(() {
          _isPlaying = true;
        });

        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
        });
      }
    } catch (e) {
      _showMessage('خطأ في تشغيل الصوت: $e');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometrics & Audio Recorder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // قسم البصمة
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isAuthenticated ? Icons.lock_open : Icons.lock,
                      size: 50,
                      color: _isAuthenticated ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isAuthenticated
                          ? 'تم التحقق بنجاح!'
                          : 'اضغط للتحقق من البصمة',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _authenticate,
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('التحقق بالبصمة'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // قسم التسجيل والتشغيل الصوتي
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'المسجل الصوتي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _toggleRecording,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isRecording
                                ? Colors.red
                                : Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                          label: Text(_isRecording ? 'إيقاف' : 'تسجيل'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _audioPath != null
                              ? _togglePlayAudio
                              : null,
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          label: Text(_isPlaying ? 'إيقاف' : 'تشغيل'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
