import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementWebScreen extends StatefulWidget {
  const AgreementWebScreen({
    super.key,
    required this.title,
    this.url,
    this.assetPath,
  }) : assert(url != null || assetPath != null, 'url or assetPath is required');

  final String title;
  final String? url;
  final String? assetPath;

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

  static const String _replaceBrandScript = '''
    (function() {
      function replaceText(node) {
        if (node.nodeType === 3) {
          node.textContent = node.textContent.replace(/相恋|陪伴/g, '陌缘');
        } else if (node.nodeType === 1 && node.tagName !== 'SCRIPT' && node.tagName !== 'STYLE') {
          node.childNodes.forEach(replaceText);
        }
      }
      replaceText(document.body);
    })();
  ''';

  @override
  void initState() {
    super.initState();
    final useAsset = widget.assetPath != null;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            if (!useAsset) {
              await _controller.runJavaScript(_hideChromeScript);
              await _controller.runJavaScript(_replaceBrandScript);
            }
            if (mounted) setState(() => _loading = false);
          },
        ),
      );

    if (useAsset) {
      _controller.loadFlutterAsset(widget.assetPath!);
    } else {
      _controller.loadRequest(Uri.parse(widget.url!));
    }
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
