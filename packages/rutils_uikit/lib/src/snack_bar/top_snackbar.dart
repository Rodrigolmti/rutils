import 'package:flutter/material.dart';

const Color _success = Color(0xFF18A957);
const Color _error = Color(0xFFDF1642);
const Color _tertiary = Color(0xFFFFFFFF);

class CustomSnackBar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final TextStyle textStyle;
  final IconData icon;

  const CustomSnackBar.success({
    required this.message,
    this.icon = Icons.check,
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.backgroundColor = _success,
  });

  const CustomSnackBar.error({
    required this.message,
    this.icon = Icons.error,
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.backgroundColor = _error,
  });

  @override
  _CustomSnackBarState createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 8),
            spreadRadius: 1,
            blurRadius: 30,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      width: double.infinity,
      child: Row(
        children: [
          Icon(widget.icon, color: _tertiary),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              widget.message,
              style: theme.textTheme.bodyMedium?.merge(
                widget.textStyle,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          )
        ],
      ),
    );
  }
}

class TapBounceContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const TapBounceContainer({
    required this.child,
    this.onTap,
  });

  @override
  _TapBounceContainerState createState() => _TapBounceContainerState();
}

class _TapBounceContainerState extends State<TapBounceContainer>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  final animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
      lowerBound: 0,
      upperBound: 0.04,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onPanEnd: _onPanEnd,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    await _closeSnackBar();
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    await _closeSnackBar();
  }

  Future _closeSnackBar() async {
    await _controller.reverse();
    await Future.delayed(animationDuration);
    widget.onTap?.call();
  }
}

void showTopSnackBar(
  BuildContext context,
  Widget child, {
  Duration showOutAnimationDuration = const Duration(milliseconds: 1200),
  Duration hideOutAnimationDuration = const Duration(milliseconds: 550),
  Duration displayDuration = const Duration(milliseconds: 3000),
  double additionalTopPadding = 16.0,
  VoidCallback? onTap,
  OverlayState? overlayState,
}) {
  overlayState ??= Overlay.of(context);
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => TopSnackBar(
      onDismissed: () => overlayEntry?.remove(),
      showOutAnimationDuration: showOutAnimationDuration,
      hideOutAnimationDuration: hideOutAnimationDuration,
      displayDuration: displayDuration,
      additionalTopPadding: additionalTopPadding,
      onTap: () {
        onTap?.call();
      },
      child: child,
    ),
  );

  overlayState.insert(overlayEntry);
}

class TopSnackBar extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismissed;
  final Duration showOutAnimationDuration;
  final Duration hideOutAnimationDuration;
  final Duration displayDuration;
  final double additionalTopPadding;
  final VoidCallback? onTap;

  const TopSnackBar({
    required this.child,
    required this.onDismissed,
    required this.showOutAnimationDuration,
    required this.hideOutAnimationDuration,
    required this.displayDuration,
    required this.additionalTopPadding,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _TopSnackBarState createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  late Animation offsetAnimation;
  late AnimationController animationController;
  double? topPosition;

  @override
  void initState() {
    topPosition = widget.additionalTopPadding;
    _setupAndStartAnimation();
    super.initState();
  }

  void _setupAndStartAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.showOutAnimationDuration,
      reverseDuration: widget.hideOutAnimationDuration,
    );

    final offsetTween = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    );

    offsetAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.linearToEaseOut,
      ),
    )..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(widget.displayDuration);
          await animationController.reverse();
          if (mounted) {
            setState(() {
              topPosition = 0;
            });
          }
        }

        if (status == AnimationStatus.dismissed) {
          widget.onDismissed.call();
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedPositioned(
        duration: widget.hideOutAnimationDuration * 1.5,
        curve: Curves.linearToEaseOut,
        top: topPosition,
        left: 16,
        right: 16,
        child: SlideTransition(
          position: offsetAnimation as Animation<Offset>,
          child: SafeArea(
            child: TapBounceContainer(
              onTap: () {
                widget.onTap?.call();
                animationController.reverse();
              },
              child: widget.child,
            ),
          ),
        ),
      );
}
