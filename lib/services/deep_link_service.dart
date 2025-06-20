import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_platform/universal_platform.dart';

// Platform-specific imports
import 'package:universal_html/html.dart' as html;
import 'package:uni_links/uni_links.dart' as uni_links;

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  final StreamController<Uri> _linksController = StreamController<Uri>.broadcast();
  Stream<Uri> get links => _linksController.stream;

  factory DeepLinkService() {
    return _instance;
  }

  DeepLinkService._internal();

  void dispose() {
    _linksController.close();
  }

  /// Initializes deep linking
  Future<void> initDeepLinks() async {
    if (UniversalPlatform.isWeb) {
      _handleWebDeepLinks();
    } else {
      await _handleAppDeepLinks();
    }
  }

  /// Handles deep links for web
  void _handleWebDeepLinks() {
    if (kIsWeb) {
      // Handle initial URL
      final currentUrl = html.window.location.href;
      if (currentUrl.contains('access_token') || currentUrl.contains('error')) {
        _handleDeepLink(Uri.parse(currentUrl));
      }

      // Listen for URL changes
      html.window.onHashChange.listen((event) {
        final url = html.window.location.href;
        _handleDeepLink(Uri.parse(url));
      });
    }
  }

  /// Handles deep links for mobile/desktop
  Future<void> _handleAppDeepLinks() async {
    if (kIsWeb) return; // Skip on web
    
    try {
      // Get the initial link if the app was opened with a deep link
      final initialLink = await _getInitialAppLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }

      // Listen for deep links while the app is running
      final linkStream = _getAppLinksStream();
      linkStream.listen((uri) {
        if (uri != null) {
          _handleDeepLink(uri);
          
          // If the link contains access_token or error, handle it
          if (uri.toString().contains('access_token') || 
              uri.toString().contains('error')) {
            print('Received OAuth callback: $uri');
          }
        }
      });
    } catch (e) {
      print('Error initializing deep links: $e');
    }
  }
  
  /// Helper method to get the initial app link with proper type safety
  Future<Uri?> _getInitialAppLink() async {
    if (kIsWeb) {
      final currentUrl = html.window.location.href;
      return currentUrl.isNotEmpty ? Uri.parse(currentUrl) : null;
    } else {
      try {
        final uri = await uni_links.getInitialUri();
        if (uri != null) return uri;
        
        // Fallback to string-based API
        final link = await uni_links.getInitialLink();
        if (link != null) return Uri.tryParse(link);
        
        return null;
      } catch (e) {
        print('Error getting initial app link: $e');
        return null;
      }
    }
  }
  
  /// Helper method to get the app links stream with proper type safety
  Stream<Uri> _getAppLinksStream() {
    if (kIsWeb) {
      return const Stream<Uri>.empty();
    }
    
    try {
      return uni_links.uriLinkStream
          .where((uri) => uri != null)
          .cast<Uri>();
    } catch (e) {
      print('Error getting app links stream: $e');
      return const Stream<Uri>.empty();
    }
  }

  /// Handles the deep link
  void _handleDeepLink(Uri uri) {
    _linksController.add(uri);
  }

  /// Gets the initial deep link if the app was opened with one
  Future<Uri?> getInitialLink() async {
    try {
      if (kIsWeb) {
        final currentUrl = html.window.location.href;
        return currentUrl.isNotEmpty ? Uri.parse(currentUrl) : null;
      } else {
        return await _getInitialAppLink();
      }
    } catch (e) {
      print('Error getting initial link: $e');
      return null;
    }
  }

  /// Launches a URL in the default browser
  Future<bool> launchUrl(String url, {bool forceWebView = false}) async {
    if (await canLaunchUrlString(url)) {
      return await launchUrlString(
        url,
        mode: forceWebView
            ? LaunchMode.inAppWebView
            : LaunchMode.platformDefault,
      );
    }
    return false;
  }
}
