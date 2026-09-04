import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementWebScreen extends StatefulWidget {
  const AgreementWebScreen({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  State<AgreementWebScreen> createState() => _AgreementWebScreenState();
}

class _AgreementWebScreenState extends State<AgreementWebScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  static const String _hideChromeScript = '''
    (function() {
      var style = document.createElement('style');
      style.textContent = `
        footer,
        .TyBUR,
        .LkDMRd,
        [role="contentinfo"],
        a[href*="google.com"],
        img[src*="googlelogo"],
        img[alt*="Google"] {
          display: none !important;
          visibility: hidden !important;
          height: 0 !important;
          overflow: hidden !important;
        }
      `;
      document.head.appendChild(style);
    })();
  ''';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            await _controller.runJavaScript(_hideChromeScript);
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, size: 22),
        ),
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.brandPink,
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }
}
