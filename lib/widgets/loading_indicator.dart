import 'package:flutter/material.dart';
import 'package:cina/core/theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.size = 40.0,
    this.strokeWidth = 4.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class FullScreenLoading extends StatelessWidget {
  final String? message;
  final bool showBackground;

  const FullScreenLoading({
    Key? key,
    this.message,
    this.showBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: showBackground
          ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8)
          : Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LoadingIndicator(size: 48.0, strokeWidth: 3.0),
            if (message != null) ...[
              const SizedBox(height: 16.0),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ButtonLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const ButtonLoadingIndicator({
    Key? key,
    this.size = 16.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
