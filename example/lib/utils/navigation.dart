import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 1. Define the missing Enum for navigation style
enum NavigationRouteStyle {
  material,
  cupertino,
  // Add other styles like 'fade' or 'slide' if needed
}

// 2. The Fixed Navigation Class
class Navigation {
  // Make the constructor private as this is a utility class
  const Navigation._();

  static Future<T?> navigateTo<T>({
    required BuildContext context,
    required Widget screen,
    required NavigationRouteStyle style,
  }) async {
    // We use Route<T> for safety and guarantee the type.
    final Route<T> route;

    // Use a switch statement to ensure all paths are covered and the 'route'
    // variable is definitely initialized before use.
    switch (style) {
      case NavigationRouteStyle.cupertino:
        route = CupertinoPageRoute<T>(builder: (_) => screen);
        break;
      case NavigationRouteStyle.material:
      default:
      // Default to MaterialPageRoute if the style is unknown or is material
        route = MaterialPageRoute<T>(builder: (_) => screen);
        break;
    }

    // Navigator.push returns a nullable Future<T?>, so we update the signature.
    // We remove 'await' and the type assertion from the method signature.
    return Navigator.push<T>(context, route);
  }
}