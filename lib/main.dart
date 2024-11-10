import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' hide VoidCallback;

/// Registers [effect] to be run in
/// WidgetsBinding.instance.addPostFrameCallback.
void usePostFrameEffect(VoidCallback effect, [List<Object?>? keys]) {
  useEffect(
    () {
      WidgetsBinding.instance.addPostFrameCallback((_) => effect());
      return null;
    },
    keys,
  );
}

void main() {
  mainCommon();
}

Future<void> mainCommon() async {
  final prefs = await SharedPreferences.getInstance();
  final response = await HttpRequest.getString(
    'version.txt?${DateTime.now().millisecondsSinceEpoch}',
  );
  final currentVersion = response.trim();
  final savedVersion = prefs.getString('version');

  runApp(
    MaterialApp(
      home: MainApp(
        shouldReload: currentVersion != savedVersion,
      ),
    ),
  );
}

class MainApp extends HookWidget {
  const MainApp({
    super.key,
    required this.shouldReload,
  });

  final bool shouldReload;

  @override
  Widget build(BuildContext context) {
    usePostFrameEffect(() {
      if (shouldReload) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('New version available!'),
            content:
                const Text('Please reload the page to get the latest version.'),
            actions: [
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final response = await HttpRequest.getString(
                    'version.txt?${DateTime.now().millisecondsSinceEpoch}',
                  );
                  final currentVersion = response.trim();
                  prefs.setString('version', currentVersion);
                  window.location.reload();
                },
                child: const Text('Reload'),
              ),
            ],
          ),
        );
      }
    });

    return const Scaffold(
      body: Center(
        child: Text('Hello World! 22'),
      ),
    );
  }
}
