// library intro;

import 'dart:async';
import 'package:flutter/material.dart';

// part 'src/card.dart';
// part 'src/controller.dart';
// part 'src/decoration.dart';
// part 'src/exception.dart';
// part 'src/intro.dart';
// part 'src/params.dart';
// part 'src/target.dart';
// part 'src/typedef.dart';

class IntroStepCard extends StatelessWidget {
  static IntroCardBuilder _buildDefaultCard(TextSpan contents) {
    return (BuildContext context, IntroParams params,
        IntroCardDecoration decoration) {
      final decoration = params.controller.intro.cardDecoration
          .mergeTo(params._state.widget.cardDecoration);
      final cardAlign = params.actualCardAlign;
      final textAlignToRight = [
        IntroCardAlign.insideTopRight,
        IntroCardAlign.insideBottomRight,
        IntroCardAlign.outsideTopRight,
        IntroCardAlign.outsideBottomRight,
        IntroCardAlign.outsideLeftTop,
        IntroCardAlign.outsideLeftBottom,
      ].contains(cardAlign);
      return IntroStepCard(
        params: params,
        child: Text.rich(
          contents,
          style: decoration.textStyle,
          textAlign: decoration.size == null && textAlignToRight
              ? TextAlign.right
              : TextAlign.left,
        ),
      );
    };
  }

  final IntroParams params;
  final Widget child;

  const IntroStepCard({
    Key? key,
    required this.params,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = params.controller;
    final decoration = controller.intro.cardDecoration
        .mergeTo(params._state.widget.cardDecoration);

    return Container(
      width: decoration.size?.width,
      height: decoration.size?.height,
      padding: decoration.padding,
      decoration: BoxDecoration(
        color: decoration.backgroundColor,
        border: decoration.border,
        borderRadius: decoration.radius,
      ),
      child: Builder(
        builder: (context) {
          final autoHide = decoration.autoHideDisabledButtons ?? true;
          final showPrevious = decoration.showPreviousButton ?? true;
          final showNext = decoration.showNextButton ?? true;
          final showPreviousButton =
              showPrevious && (!autoHide || controller.hasPreviousStep);
          final showNextButton =
              showNext && (!autoHide || controller.hasNextStep);
          final showCloseButton =
              decoration.showCloseButton ?? controller.isLastStep;

          final children = <Widget>[];

          if (showPreviousButton) {
            children.add(ElevatedButton(
              onPressed:
              controller.hasPreviousStep ? controller.previous : null,
              style: decoration.previousButtonStyle,
              child: Text(decoration.previousButtonLabel ?? "Previous"),
            ));
          }
          if (showCloseButton) {
            children.add(ElevatedButton(
              onPressed: controller.close,
              style: decoration.closeButtonStyle,
              child: Text(decoration.closeButtonLabel ??
                  (controller.isLastStep ? "Finish" : "Close")),
            ));
          }
          if (showNextButton) {
            children.add(ElevatedButton(
              onPressed: controller.hasNextStep ? controller.next : null,
              style: decoration.nextButtonStyle,
              child: Text(decoration.nextButtonLabel ?? "Next"),
            ));
          }

          if (children.isEmpty) {
            return child;
          }

          final nonSize = decoration.size == null;
          final alignToRight = [
            IntroCardAlign.insideTopRight,
            IntroCardAlign.insideBottomRight,
            IntroCardAlign.outsideTopRight,
            IntroCardAlign.outsideBottomRight,
            IntroCardAlign.outsideLeftTop,
            IntroCardAlign.outsideLeftBottom,
          ].contains(params.actualCardAlign);
          final alignToBottom = [
            IntroCardAlign.insideBottomLeft,
            IntroCardAlign.insideBottomRight,
            IntroCardAlign.outsideTopLeft,
            IntroCardAlign.outsideTopRight,
            IntroCardAlign.outsideLeftBottom,
            IntroCardAlign.outsideRightBottom,
          ].contains(params.actualCardAlign);

          for (var i = 1; i < children.length; i += 2) {
            children.insert(i, const SizedBox(width: 10));
          }

          return Column(
            crossAxisAlignment: nonSize && alignToRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: nonSize && alignToBottom
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              child,
              const SizedBox(height: 20),
              Row(children: children),
            ],
          );
        },
      ),
    );
  }
}

class _GradualOpacity extends StatefulWidget {
  final Duration duration;
  final double startOpacity;
  final double endOpacity;
  final VoidCallback? onAnimationFinished;
  final Widget child;

  _GradualOpacity({
    Key? key,
    required this.duration,
    this.startOpacity = 0.0,
    this.endOpacity = 1.0,
    required this.child,
    this.onAnimationFinished,
  })  : assert(startOpacity >= 0.0 && startOpacity <= 1.0),
        assert(endOpacity >= 0.0 && endOpacity <= 1.0),
        assert(!duration.isNegative),
        super(key: key);

  @override
  State<_GradualOpacity> createState() => _GradualOpacityState();
}

class _GradualOpacityState extends State<_GradualOpacity> {
  late double opacity;
  late Duration duration;

  @override
  void initState() {
    super.initState();
    opacity = widget.startOpacity;
    duration = widget.duration;
    if (widget.endOpacity != widget.startOpacity) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() => opacity = widget.endOpacity);
      });
    }
  }

  @override
  void didUpdateWidget(_GradualOpacity oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      duration = Duration.zero;
      opacity = widget.startOpacity;
    });
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          duration = widget.duration;
          opacity = widget.endOpacity;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: duration,
      onEnd: widget.onAnimationFinished,
      child: widget.child,
    );
  }
}

typedef WillDoCallback = bool? Function(int currentStep);

/// The controller of demo flow.
class IntroController {
  /// The total number of steps.
  final int stepCount;

  /// This callback is called when the demo flow is about to jump to the previous step.
  ///
  /// You can return `false` if you want to prevent it from taking effect.
  final WillDoCallback? onWillPrevious;

  /// This callback is called when the demo flow is about to jump to the next step.
  ///
  /// You can return `false` if you want to prevent it from taking effect.
  final WillDoCallback? onWillNext;

  /// This callback is called when the demo flow is about to close.
  ///
  /// You can return `false` if you want to prevent it from taking effect.
  final WillDoCallback? onWillClose;

  Intro? _intro;
  late final Map<int, GlobalKey> _keys;
  final Map<int, IntroParams> _targets = {};
  int _currentStep = 0;
  bool _isOpened = false;
  bool _opening = false;
  bool _closing = false;
  bool _switching = false;
  OverlayEntry? _overlayEntry;

  IntroController({
    required this.stepCount,
    this.onWillPrevious,
    this.onWillNext,
    this.onWillClose,
  }) {
    assert(stepCount > 0, "The [stepCount] argument must be greater than 0.");
    _keys = Map.fromEntries(List.generate(stepCount,
            (i) => MapEntry(i + 1, GlobalObjectKey("$hashCode-${i + 1}"))));
  }

  bool get mounted => stepCount > 0 && _keys.length == stepCount;

  /// The `Intro` instance it's attached to.
  Intro get intro {
    if (_intro == null) {
      throw IntroException("Can not get identity of this controller. "
          "Please check whether this controller is bound to the `Intro` widget.");
    }
    return _intro!;
  }

  /// Whether the demo flow is running.
  bool get isOpened => _isOpened;

  /// The code of current step.
  int get currentStep {
    assert(_debugAssertNotDisposed());
    return _currentStep;
  }

  /// Whether has next step.
  bool get hasNextStep {
    assert(_debugAssertNotDisposed());
    return currentStep < stepCount;
  }

  /// Whether has previous step.
  bool get hasPreviousStep {
    assert(_debugAssertNotDisposed());
    return currentStep > 1;
  }

  /// Whether the current step is the first step.
  bool get isFirstStep {
    assert(_debugAssertNotDisposed());
    return currentStep == 1;
  }

  /// Whether the current step is the last step.
  bool get isLastStep {
    assert(_debugAssertNotDisposed());
    return currentStep == stepCount;
  }

  /// The [GlobalKey] of the highlighted widget for this step.
  GlobalKey? get currentStepKey {
    assert(_debugAssertNotDisposed());
    return currentStep == 0 ? null : _keys[currentStep - 1];
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (!mounted) {
        throw IntroException(
            "The instance of IntroController has been destroyed, "
                "you shouldn't call any method of it.");
      }
      return true;
    }());
    return true;
  }

  bool _debugAssertOpened() {
    assert(() {
      if (!_isOpened) {
        throw IntroException(
            "Please call [start] method to launch the introduction process first.");
      }
      return true;
    }());
    return true;
  }

  bool _debugAssertStepRange(int step) {
    assert(() {
      if (step <= 0 || step > stepCount) {
        throw IntroException(
            "The [step] value `$step` out of range [1..$stepCount].");
      }
      return true;
    }());
    return true;
  }

  /// Get the [GlobalKey] of the specified [step].
  GlobalKey getStepKey(int step) {
    assert(_debugAssertNotDisposed());
    if (!_keys.containsKey(step)) {
      throw IntroException("Make sure the [step] your given is valid. "
          "Note: the step range of this controller is [1..$stepCount].");
    }
    return _keys[step]!;
  }

  void _setTarget(_IntroStepTargetState target) {
    assert(_debugAssertNotDisposed());
    assert(identical(target.widget.controller, this));

    final step = target.widget.step;
    final context = getStepKey(step).currentContext;
    if (context == null) {
      throw IntroException(
        'The current context is null, because there is no widget in the tree that matches this step.'
            ' Please check your code. If you think you have encountered a bug, please let me know.',
      );
    }

    _targets[step] = IntroParams._(target);
  }

  void _unsetTarget(_IntroStepTargetState target) {
    assert(_debugAssertNotDisposed());
    assert(identical(target.widget.controller, this));

    final step = target.widget.step;
    _targets.remove(step);
  }

  void _onOverlayAnimationFinished() {
    if (_opening) {
      _opening = false;
    }
    if (_closing) {
      _closing = false;
      _isOpened = false;
      _overlayEntry?.remove();
      _overlayEntry = null;
      _currentStep = 0;
    }
  }

  IntroParams? _getCurrentStepParams() {
    if (_currentStep == 0) {
      return null;
    }

    final params = _targets[_currentStep];
    if (params == null) {
      throw IntroException(
          "Can not build introduction overlay for step `$_currentStep`. "
              "It means a [IntroStepTarget] widget using this step has not been rendered. "
              "Please check whether the `IntroStepTarget(step: $_currentStep)` widget has been created "
              "and make sure it has in the widget tree.");
    }
    return params;
  }

  Widget _buildOverlay(BuildContext context) {
    return _GradualOpacity(
      duration: intro.animationDuration,
      startOpacity: _opening ? 0.0 : 1.0,
      endOpacity: _closing ? 0.0 : 1.0,
      onAnimationFinished: _onOverlayAnimationFinished,
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              _buildBorder(context),
              _buildHighlight(context),
              _buildCard(context),
              ...intro.topLayerBuilder == null
                  ? []
                  : [
                intro.topLayerBuilder!(context, this),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBorder(BuildContext context) {
    final params = _getCurrentStepParams();
    if (params == null) {
      return Container();
    }

    final widget = params._state.widget;
    final rect = params.highlightRect;
    final decoration =
    intro.highlightDecoration.mergeTo(widget.highlightDecoration);
    return AnimatedPositioned(
      duration: intro.animationDuration,
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: AnimatedContainer(
        duration: intro.animationDuration,
        width: rect.width,
        height: rect.height,
        padding: decoration.padding,
        decoration: BoxDecoration(
          border: decoration.border,
          borderRadius: decoration.radius,
        ),
      ),
    );
  }

  Widget _buildHighlight(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        intro.barrierColor,
        BlendMode.srcOut,
      ),
      child: Builder(
        builder: (context) {
          final params = _getCurrentStepParams();
          if (params == null) {
            return Container();
          }

          final rect = params.highlightRect;
          final widget = params._state.widget;
          final decoration =
          intro.highlightDecoration.mergeTo(widget.highlightDecoration);
          return Stack(
            children: [
              AnimatedPositioned(
                duration: intro.animationDuration,
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: intro.animationDuration,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      final decoration = _intro?.cardDecoration.mergeTo(
                          _getCurrentStepParams()
                              ?._state
                              .widget
                              .cardDecoration);
                      if (decoration?.tapBarrierToContinue == true) {
                        next();
                      }
                    },
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: intro.animationDuration,
                left: rect.left,
                top: rect.top,
                width: rect.width,
                height: rect.height,
                child: MouseRegion(
                  cursor: decoration.cursor ?? MouseCursor.defer,
                  child: GestureDetector(
                    onTap: widget.onHighlightTap,
                    child: AnimatedContainer(
                      duration: intro.animationDuration,
                      width: rect.width,
                      height: rect.height,
                      decoration: BoxDecoration(
                        border: decoration.border,
                        borderRadius: decoration.radius,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final params = _getCurrentStepParams();
    if (_closing || params == null) {
      return Container();
    }

    final widget = params._state.widget;
    final rect = params.cardRect;

    final screen = MediaQuery.of(context).size;
    final left = rect.left.isInfinite ? null : rect.left;
    final right = rect.right.isInfinite ? null : (screen.width - rect.right);
    final top = rect.top.isInfinite ? null : rect.top;
    final bottom =
    rect.bottom.isInfinite ? null : (screen.height - rect.bottom);

    final decoration = intro.cardDecoration
        .mergeTo(widget.cardDecoration)
        .mergeTo(IntroCardDecoration(align: params.actualCardAlign));
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: _GradualOpacity(
        duration: intro.animationDuration,
        startOpacity: _switching ? 1.0 : 0.0,
        child: widget.cardBuilder(context, params, decoration),
      ),
    );
  }

  /// Destroy this demo flow.
  ///
  /// When it destroyed, it can never be used again.
  void dispose() {
    if (!mounted) return;

    close().then((_) {
      _keys.clear();
      _targets.clear();
      _opening = false;
      _closing = false;
      _switching = false;
    });
  }

  Future<void> _switchStep(int fromStep, int toStep,
      [bool needRefresh = true]) async {
    _switching = true;
    if (fromStep != 0) {
      await _targets[fromStep]
          ?._state
          .widget
          .onStepWillDeactivate
          ?.call(toStep);
    }
    if (toStep != 0) {
      await _targets[toStep]?._state.widget.onStepWillActivate?.call(fromStep);
    }
    _switching = false;

    if (needRefresh && _isOpened && _currentStep == fromStep) {
      _currentStep = toStep;
      refresh();
    }
  }

  /// Start this demo flow.
  ///
  /// It begin from step 1 by default. But you can specify the initial step through the [initStep].
  ///
  /// Note that the [context] you give must be the context of a widget after the [Intro] is defined.
  Future<void> start(
      BuildContext context, {
        int initStep = 1,
      }) async {
    assert(_debugAssertNotDisposed());
    assert(_debugAssertStepRange(initStep));

    if (_intro == null) {
      throw IntroException("Can not start this introduction. "
          "Please check whether this controller is bound to the `Intro` widget.");
    }

    if (_isOpened) {
      if (initStep != _currentStep) {
        jumpTo(initStep);
      }
      return;
    }

    assert(_currentStep == 0);
    _isOpened = true;
    _opening = true;
    await _switchStep(0, initStep, false);
    _currentStep = initStep;

    _overlayEntry = OverlayEntry(builder: _buildOverlay);
    await Future(() => Overlay.of(context)!.insert(_overlayEntry!));
  }

  /// Close the demo flow.
  Future<void> close() async {
    assert(_debugAssertNotDisposed());
    if (!_isOpened) return;

    if (onWillClose?.call(currentStep) ?? true) {
      await _switchStep(_currentStep, 0, false);
      _closing = true;
      refresh();
    }
  }

  /// Jump this demo flow to the [step].
  Future<void> jumpTo(int step) async {
    assert(_debugAssertNotDisposed());
    assert(_debugAssertOpened());
    assert(_debugAssertStepRange(step));

    if (step == _currentStep) return;
    await _switchStep(_currentStep, step);
  }

  /// Jump this demo flow to next step.
  ///
  /// It's equivalent to [close] if called at the last step.
  Future<void> next() async {
    assert(_debugAssertNotDisposed());
    assert(_debugAssertOpened());

    if (onWillNext?.call(currentStep) ?? true) {
      if (isLastStep) {
        return close();
      }
      await _switchStep(_currentStep, _currentStep + 1);
    }
  }

  /// Jump this demo flow to previous step if not at the first step.
  Future<void> previous() async {
    assert(_debugAssertNotDisposed());
    assert(_debugAssertOpened());
    if (isFirstStep) return;

    if (onWillPrevious?.call(currentStep) ?? true) {
      await _switchStep(_currentStep, _currentStep - 1);
    }
  }

  void refresh() {
    assert(_debugAssertNotDisposed());
    assert(_debugAssertOpened());
    _overlayEntry?.markNeedsBuild();
  }
}

/// The decoration for highlighted widget.
class IntroHighlightDecoration {
  /// Specify the border of highlighted widget.
  final Border? border;

  /// Specify the border radius of highlighted widget.
  final BorderRadiusGeometry? radius;

  /// Specify that the highlighted widget exceeds the margin of the target widget.
  final EdgeInsets? padding;

  /// Specify the mouse cursor that moving on the highlighted widget.
  final MouseCursor? cursor;

  const IntroHighlightDecoration({
    this.border,
    this.radius,
    this.padding,
    this.cursor,
  });

  /// Returns a new decoration that is a combination of this decoration
  /// and the given [other] decoration.
  ///
  /// The null properties of the given [other] decoration are replaced
  /// with the non-null properties of this decoration.
  IntroHighlightDecoration mergeTo(IntroHighlightDecoration? other) {
    if (other == null) {
      return this;
    }

    return IntroHighlightDecoration(
      border: other.border ?? border,
      radius: other.radius ?? radius,
      padding: other.padding ?? padding,
      cursor: other.cursor ?? cursor,
    );
  }
}

/// The decoration for intro card.
class IntroCardDecoration {
  /// Specify the alignment of intro card widget relative to highlighted widget.
  ///
  /// By default, it automatically estimates where the intro card should be displayed
  /// based on the location and size of the target widget.
  final IntroCardAlign? align;

  /// Specify the size of intro card.
  final Size? size;

  /// Specify the distance between the intro card and the highlighted widget.
  final EdgeInsets? margin;

  /// Specify the padding of contents of intro card.
  final EdgeInsets? padding;

  /// Specify the border of intro card.
  final Border? border;

  /// Specify the border radius of intro card.
  final BorderRadiusGeometry? radius;

  /// Specify the background color of intro card.
  final Color? backgroundColor;

  /// Specify the contents style of intro card.
  final TextStyle? textStyle;

  /// Whether to display the previous button.
  final bool? showPreviousButton;

  /// Whether to display the next button.
  final bool? showNextButton;

  /// Whether to display the close button.
  ///
  /// If it's null, the close button will be displayed at the last step and be hidden at other step.
  final bool? showCloseButton;

  /// Specify the label of previous button.
  final String? previousButtonLabel;

  /// Specify the label of next button.
  final String? nextButtonLabel;

  /// Specify the label of close button.
  final String? closeButtonLabel;

  /// Whether to hide disabled buttons automatically.
  ///
  /// When it set to `true`, the previous button is not be displayed in the first step
  /// because no step can be back, and the next button is also not be displayed in the
  /// last step because no step can to continue.
  final bool? autoHideDisabledButtons;

  /// Specify the style of previous button.
  final ButtonStyle? previousButtonStyle;

  /// Specify the style of next button.
  final ButtonStyle? nextButtonStyle;

  /// Specify the style of close button.
  final ButtonStyle? closeButtonStyle;

  /// Whether can be continue when tap the mask area.
  final bool? tapBarrierToContinue;

  const IntroCardDecoration({
    this.align,
    this.size,
    this.margin,
    this.padding,
    this.border,
    this.radius,
    this.backgroundColor,
    this.textStyle,
    this.showPreviousButton,
    this.showNextButton,
    this.showCloseButton,
    this.previousButtonLabel,
    this.nextButtonLabel,
    this.closeButtonLabel,
    this.autoHideDisabledButtons,
    this.previousButtonStyle,
    this.nextButtonStyle,
    this.closeButtonStyle,
    this.tapBarrierToContinue,
  });

  /// Returns a new decoration that is a combination of this decoration
  /// and the given [other] decoration.
  ///
  /// The null properties of the given [other] decoration are replaced
  /// with the non-null properties of this decoration.
  IntroCardDecoration mergeTo(IntroCardDecoration? other) {
    if (other == null) {
      return this;
    }

    return IntroCardDecoration(
      align: other.align ?? align,
      size: other.size ?? size,
      margin: other.margin ?? margin,
      padding: other.padding ?? padding,
      border: other.border ?? border,
      radius: other.radius ?? radius,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      showPreviousButton: other.showPreviousButton ?? showPreviousButton,
      showNextButton: other.showNextButton ?? showNextButton,
      showCloseButton: other.showCloseButton ?? showCloseButton,
      previousButtonLabel: other.previousButtonLabel ?? previousButtonLabel,
      nextButtonLabel: other.nextButtonLabel ?? nextButtonLabel,
      closeButtonLabel: other.closeButtonLabel ?? closeButtonLabel,
      autoHideDisabledButtons:
      other.autoHideDisabledButtons ?? autoHideDisabledButtons,
      previousButtonStyle:
      other.previousButtonStyle?.merge(previousButtonStyle) ??
          previousButtonStyle,
      nextButtonStyle:
      other.nextButtonStyle?.merge(nextButtonStyle) ?? nextButtonStyle,
      closeButtonStyle:
      other.closeButtonStyle?.merge(closeButtonStyle) ?? closeButtonStyle,
      tapBarrierToContinue: other.tapBarrierToContinue ?? tapBarrierToContinue,
    );
  }
}

class IntroException implements Exception {
  final dynamic message;

  IntroException([this.message]);

  @override
  String toString() => "$runtimeType${message == null ? '' : ': $message'}";
}

typedef TopLayerBuilder = Widget Function(BuildContext, IntroController);

/// Demo flow widget.
///
/// Please register this widget at the earliest possible widget tree node.
class Intro extends InheritedWidget {
  static Intro of(BuildContext context) {
    final instance = context.dependOnInheritedWidgetOfExactType<Intro>();
    if (instance == null) {
      throw IntroException("Can't get instance of Intro. "
          "Make sure you have defined a `Intro` widget in the widget tree "
          "before the widget related to this context.");
    }
    return instance;
  }

  static const _defaultBarrierColor = Color(0xC6000000);

  static const _defaultAnimationDuration = Duration(milliseconds: 300);

  static const _defaultHighlightDecoration = IntroHighlightDecoration(
    padding: EdgeInsets.all(2),
    border: Border.fromBorderSide(BorderSide(
      color: Colors.white,
      width: 2.0,
    )),
    radius: BorderRadius.all(Radius.circular(5)),
  );

  static const _defaultCardDecoration = IntroCardDecoration(
    margin: EdgeInsets.all(10),
    radius: BorderRadius.all(Radius.circular(5)),
    textStyle: TextStyle(
      color: Color(0xDCFFFFFF),
      fontSize: 16.0,
      height: 1.2,
    ),
  );

  /// The controller of this demo flow.
  final IntroController controller;

  final Color barrierColor;
  final Duration animationDuration;
  final IntroHighlightDecoration highlightDecoration;
  final IntroCardDecoration cardDecoration;
  final TopLayerBuilder? topLayerBuilder;

  Intro({
    Key? key,
    required Widget child,
    required this.controller,
    Color? barrierColor,
    this.topLayerBuilder,
    Duration? animationDuration,
    IntroHighlightDecoration? highlightDecoration,
    IntroCardDecoration? cardDecoration,
  })  : assert(animationDuration == null || !animationDuration.isNegative),
        barrierColor = barrierColor ?? _defaultBarrierColor,
        animationDuration = animationDuration ?? _defaultAnimationDuration,
        highlightDecoration =
        _defaultHighlightDecoration.mergeTo(highlightDecoration),
        cardDecoration = _defaultCardDecoration.mergeTo(cardDecoration),
        super(key: key, child: child) {
    controller._intro = this;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      child != oldWidget.child;

  void dispose() {
    controller.dispose();
    controller._intro = null;
  }
}

/// Describes the alignment of introduction card widget relative to highlighted widget.
enum IntroCardAlign {
  /// The card widget is aligned to the top left corner inside the target widget.
  insideTopLeft,

  /// The card widget is aligned to the top right corner inside the target widget.
  insideTopRight,

  /// The card widget is aligned to the bottom left corner inside the target widget.
  insideBottomLeft,

  /// The card widget is aligned to the bottom right corner inside the target widget.
  insideBottomRight,

  /// The card widget is located to the left of the top of the target widget.
  outsideTopLeft,

  /// The card widget is located to the right of the top of the target widget.
  outsideTopRight,

  /// The card widget is located to the left of the bottom of the target widget.
  outsideBottomLeft,

  /// The card widget is located to the right of the bottom of the target widget.
  outsideBottomRight,

  /// The card widget is located to the top of the left of the target widget.
  outsideLeftTop,

  /// The card widget is located to the bottom of the left of the target widget.
  outsideLeftBottom,

  /// The card widget is located to the top of the right of the target widget.
  outsideRightTop,

  /// The card widget is located to the bottom of the right of the target widget.
  outsideRightBottom,
}

/// Parameters about a step.
class IntroParams {
  final _IntroStepTargetState _state;
  IntroCardAlign? _cardAlign;

  IntroParams._(this._state);

  /// The step number for this `IntroStepTarget`.
  int get step => _state.widget.step;

  /// The controller for this demo flow.
  IntroController get controller => _state.widget.controller;

  /// The context for the `IntroStepTarget` widget of this step.
  BuildContext get context => controller.getStepKey(step).currentContext!;

  /// The geometry for the target widget of this step.
  Rect get targetRect {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;
    return Rect.fromPoints(offset, size.bottomRight(offset));
  }

  /// The geometry for the highlighted area of this step.
  Rect get highlightRect {
    final rect = targetRect;
    final padding = _state.widget.highlightDecoration?.padding ??
        controller.intro.highlightDecoration.padding ??
        EdgeInsets.zero;
    final startPoint = rect.topLeft - Offset(padding.left, padding.top);
    final endPoint = rect.bottomRight + Offset(padding.right, padding.bottom);
    return Rect.fromPoints(startPoint, endPoint);
  }

  /// The geometry for the intro card widget of this step.
  Rect get cardRect {
    final highlight = highlightRect;
    final screen = MediaQuery.of(context).size;
    final margin = _state.widget.cardDecoration?.margin ??
        controller.intro.cardDecoration.margin ??
        const EdgeInsets.all(10);
    var align = _state.widget.cardDecoration?.align ??
        controller.intro.cardDecoration.align;

    final mLeft = margin.left;
    final mRight = margin.right;
    final mTop = margin.top;
    final mBottom = margin.bottom;

    final hLeft = highlight.left;
    final hRight = highlight.right;
    final hTop = highlight.top;
    final hBottom = highlight.bottom;

    if (align == null) {
      final leftBlank = hLeft;
      final topBlank = hTop;
      final rightBlank = screen.width - hRight;
      final bottomBlank = screen.height - hBottom;
      const minimum = 120.0;
      if (leftBlank < minimum &&
          topBlank < minimum &&
          rightBlank < minimum &&
          bottomBlank < minimum) {
        align = IntroCardAlign.insideTopLeft;
      } else {
        final hWidth = highlight.width;
        final hHeight = highlight.height;
        final areaMap = {
          IntroCardAlign.outsideBottomLeft: bottomBlank * (hWidth + rightBlank),
          IntroCardAlign.outsideBottomRight: bottomBlank * (leftBlank + hWidth),
          IntroCardAlign.outsideTopLeft: topBlank * (hWidth + rightBlank),
          IntroCardAlign.outsideTopRight: topBlank * (leftBlank + hWidth),
          IntroCardAlign.outsideRightTop: rightBlank * (hHeight + bottomBlank),
          IntroCardAlign.outsideRightBottom: rightBlank * (topBlank + hHeight),
          IntroCardAlign.outsideLeftTop: leftBlank * (hHeight + bottomBlank),
          IntroCardAlign.outsideLeftBottom: leftBlank * (topBlank + hHeight),
        };
        final sortedKey = areaMap.keys.toList()
          ..sort((k1, k2) => areaMap[k2]!.compareTo(areaMap[k1]!));
        align = sortedKey.first;
        _cardAlign = align;
      }
    }

    buildRect({double? left, double? right, double? top, double? bottom}) {
      assert(left != null || right != null);
      assert(top != null || bottom != null);
      return Rect.fromLTRB(
          left ?? double.negativeInfinity,
          top ?? double.negativeInfinity,
          right ?? double.infinity,
          bottom ?? double.infinity);
    }

    switch (align) {
      case IntroCardAlign.insideTopLeft:
        return buildRect(top: hTop + mTop, left: hLeft + mLeft);
      case IntroCardAlign.insideTopRight:
        return buildRect(top: hTop + mTop, right: hRight - mRight);
      case IntroCardAlign.insideBottomLeft:
        return buildRect(bottom: hBottom - mBottom, left: hLeft + mLeft);
      case IntroCardAlign.insideBottomRight:
        return buildRect(bottom: hBottom - mBottom, right: hRight - mRight);
      case IntroCardAlign.outsideTopLeft:
        return buildRect(bottom: hTop - mBottom, left: hLeft);
      case IntroCardAlign.outsideTopRight:
        return buildRect(bottom: hTop - mBottom, right: hRight);
      case IntroCardAlign.outsideBottomLeft:
        return buildRect(top: hBottom + mTop, left: hLeft);
      case IntroCardAlign.outsideBottomRight:
        return buildRect(top: hBottom + mTop, right: hRight);
      case IntroCardAlign.outsideLeftTop:
        return buildRect(right: hLeft - mRight, top: hTop);
      case IntroCardAlign.outsideLeftBottom:
        return buildRect(right: hLeft - mRight, bottom: hBottom);
      case IntroCardAlign.outsideRightTop:
        return buildRect(left: hRight + mLeft, top: hTop);
      case IntroCardAlign.outsideRightBottom:
        return buildRect(left: hRight + mLeft, bottom: hBottom);
    }
  }

  /// The final alignment of the intro card widget that relative to the highlighted widget.
  ///
  /// If you don't specific it when you build the [IntroStepTarget] or [Intro] widget,
  /// it will be computed automatically after you access the [cardRect] attribute.
  IntroCardAlign? get actualCardAlign =>
      _state.widget.cardDecoration?.align ??
          controller.intro.cardDecoration.align ??
          _cardAlign;

  @override
  String toString() {
    rect2Str(Rect rect) {
      final left = rect.left.toStringAsFixed(1);
      final top = rect.top.toStringAsFixed(1);
      final right = rect.right.toStringAsFixed(1);
      final bottom = rect.bottom.toStringAsFixed(1);
      final width = rect.width.toStringAsFixed(0);
      final height = rect.height.toStringAsFixed(0);
      return "(L=$left, T=$top, R=$right, B=$bottom; $width×$height)";
    }

    return "$runtimeType { step: $step, target rect: ${rect2Str(targetRect)}, "
        "highlight rect: ${rect2Str(highlightRect)}, card rect: ${rect2Str(cardRect)}, "
        "actual card alignment: ${actualCardAlign?.name} }";
  }
}

/// A widget that wraps the target widget for a step.
class IntroStepTarget extends StatefulWidget {
  /// The code of target step.
  final int step;

  /// The controller of this demo flow.
  final IntroController controller;

  /// The target widget will be warped.
  final Widget child;

  /// A builder to build the intro card widget.
  final IntroCardBuilder cardBuilder;

  /// Decoration for highlighted widget.
  final IntroHighlightDecoration? highlightDecoration;

  /// Decoration for intro card.
  final IntroCardDecoration? cardDecoration;

  /// A callback that will be called when the demo flow reaches the current step.
  ///
  /// The current step is finally activated only when this callback execution is complete.
  ///
  /// The `fromStep` tells you from which step it jumped to the current step.
  /// In particular, the value of `fromStep` is '0' means that this is the beginning.
  final IntroStepWillActivateCallback? onStepWillActivate;

  /// A callback that will be called when the demo flow leaves the current step.
  ///
  /// The current step is finally deactivated only when this callback execution is complete.
  ///
  /// The `willToStep` tells you which step it will to jump to.
  /// In particular, the value of `willToStep` is '0' means that this is the ending.
  final IntroStepWillDeactivateCallback? onStepWillDeactivate;

  /// It will be called when tap the highlighted widget.
  final VoidCallback? onHighlightTap;

  /// It will be called when the target widget was built.
  final VoidCallback? onTargetLoad;

  /// It will be called when the target widget was disposed.
  final VoidCallback? onTargetDispose;

  IntroStepTarget({
    Key? key,
    required this.step,
    this.onStepWillActivate,
    this.onStepWillDeactivate,
    required this.controller,
    required TextSpan cardContents,
    this.cardDecoration,
    this.highlightDecoration,
    this.onTargetLoad,
    this.onTargetDispose,
    this.onHighlightTap,
    required this.child,
  })  : assert(step > 0 && step <= controller.stepCount,
  "The [step: $step] out of range 1..${controller.stepCount}"),
        cardBuilder = IntroStepCard._buildDefaultCard(cardContents),
        super(key: key);

  IntroStepTarget.custom({
    Key? key,
    required this.step,
    this.onStepWillActivate,
    this.onStepWillDeactivate,
    required this.controller,
    required this.cardBuilder,
    this.cardDecoration,
    this.highlightDecoration,
    this.onTargetLoad,
    this.onTargetDispose,
    this.onHighlightTap,
    required this.child,
  })  : assert(step > 0 && step <= controller.stepCount,
  "The [step: $step] out of range 1..${controller.stepCount}"),
        super(key: key);

  @override
  State<IntroStepTarget> createState() => _IntroStepTargetState();
}

class _IntroStepTargetState extends State<IntroStepTarget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.controller._setTarget(this);
      widget.onTargetLoad?.call();
    });
  }

  @override
  void dispose() {
    widget.onTargetDispose?.call();
    WidgetsBinding.instance!.removeObserver(this);
    widget.controller._unsetTarget(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(IntroStepTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTarget();
  }

  @override
  void didChangeMetrics() {
    _updateTarget();
  }

  void _updateTarget() {
    widget.controller._setTarget(this);
    if (widget.controller._isOpened &&
        widget.controller.currentStep == widget.step) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        widget.controller.refresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.controller.getStepKey(widget.step),
      child: widget.child,
    );
  }
}
typedef IntroCardBuilder = Widget Function(
    BuildContext context, IntroParams params, IntroCardDecoration decoration);

typedef IntroStepWillActivateCallback = FutureOr<void> Function(int fromStep);

typedef IntroStepWillDeactivateCallback = FutureOr<void> Function(
    int willToStep);
