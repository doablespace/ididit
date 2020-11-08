import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkListener extends StatefulWidget {
  @override
  _DeepLinkListenerState createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) _subscription.cancel();
  }

  void _init() async {
    // Listen for incoming links.
    _subscription = getLinksStream().listen(_handleLink);

    // Try pending link.
    String initialLink;
    try {
      initialLink = await getInitialLink();
    } on PlatformException {}
    if (initialLink != null) _handleLink(initialLink);
  }

  void _handleLink(String link) {
    // Try to parse the link.
    final uri = Uri.tryParse(link);
    if (uri == null) return;

    // Verify URI.
    if (uri.scheme != 'ididit' || uri.host != 'challenge') return;

    showDialog(
        context: context,
        child: AlertDialog(content: Text('link received: ${uri.query}')));
  }
}
