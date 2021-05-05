import 'dart:math' as math;
import 'dart:ui';

import 'package:quantify_app/customWidgets/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:quantify_app/screens/addActivityScreen.dart';
import 'package:quantify_app/screens/addMealScreen.dart';
import 'package:quantify_app/screens/scanScreen.dart';

@immutable
class ExampleExpandableFab extends StatelessWidget {
  const ExampleExpandableFab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 180.0,
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key key,
    this.initialOpen,
    @required this.distance,
  }) : super(key: key);

  final bool initialOpen;
  final double distance;
  //final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _expandAnimation;
  bool _open = false;
  double _sigmaX;
  double _sigmaY;
  List<Widget> children;

  @override
  void initState() {
    super.initState();
    _sigmaX = 0.001;
    _sigmaY = 0.001;
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ignore: sdk_version_async_exported_from_core
  Future<void> _toggle() async {
    setState(() {
      _open = !_open;
    });

    if (_open) {
      _sigmaX = 5.0;
      _sigmaY = 10.0;
      globals.screenDisabled = true;
      await _controller.forward();
    } else {
      _sigmaX = 0.001;
      _sigmaY = 0.001;
      await _controller.reverse();
      globals.screenDisabled = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    children = [
      Visibility(
        visible: globals.screenDisabled,
        child: Container(
          height: 70,
          width: 70,
          child: RawMaterialButton(
            shape: new CircleBorder(),
            fillColor: Colors.white.withOpacity(0.8),
            onPressed: () {
              //Navigator.pop(context);
              _toggle();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddActivityScreen()),
              );
            },
            child: const Icon(Icons.directions_run,
                size: 50, color: Color(0xFF99163D)),
          ),
        ),
      ),
      Visibility(
        visible: globals.screenDisabled,
        child: Container(
          height: 70,
          width: 70,
          child: RawMaterialButton(
            shape: new CircleBorder(),
            fillColor: Colors.white.withOpacity(0.8),
            onPressed: () {
              //Navigator.pop(context);
              _toggle();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanScreen()),
              );
            },
            child: const Icon(Icons.nfc, size: 50, color: Color(0xFF99163D)),
          ),
        ),
      ),
      Visibility(
        visible: globals.screenDisabled,
        child: Container(
          height: 70,
          width: 70,
          child: RawMaterialButton(
            shape: new CircleBorder(),
            fillColor: Colors.white.withOpacity(0.8),
            onPressed: () {
              //Navigator.pop(context);
              _toggle();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMealScreen()),
              );
            },
            child:
                const Icon(Icons.fastfood, size: 50, color: Color(0xFF99163D)),
          ),
        ),
      ),
    ];
    return Stack(fit: StackFit.expand, children: [
      Center(
          child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _sigmaX,
          sigmaY: _sigmaY,
        ),
        child: SizedBox.expand(
            child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            _buildContainerToDisableTouch(),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.075),
                child: _buildTapToCloseFab()),
            // ignore: sdk_version_ui_as_code
            ..._buildExpandingActionButtons(),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.075),
                child: _buildTapToOpenFab()),
          ],
        )),
      ))
    ]);
  }

  Widget _buildContainerToDisableTouch() {
    return Container(
        height: _open ? MediaQuery.of(context).size.height : 0,
        width: _open ? MediaQuery.of(context).size.width : 0,
        color: Colors.black.withOpacity(0.75));
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = this.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: this.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: IgnorePointer(
        ignoring: _open,
        child: AnimatedContainer(
          transformAlignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            _open ? 0.7 : 1.0,
            _open ? 0.7 : 1.0,
            1.0,
          ),
          duration: const Duration(milliseconds: 250),
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          child: AnimatedOpacity(
            opacity: _open ? 0.0 : 1.0,
            curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
            duration: const Duration(milliseconds: 250),
            child: FloatingActionButton(
              child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[100], width: 4),
                      shape: BoxShape.circle,
                      color: Color(0xFF99163D)),
                  child: Icon(Icons.add_outlined, color: Colors.white)),
              onPressed: _toggle,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key key,
    @required this.directionInDegrees,
    @required this.maxDistance,
    @required this.progress,
    @required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 90.0),
          progress.value * maxDistance,
        );

        return Positioned(
          right: (MediaQuery.of(context).size.width * 0.5) - 35 + offset.dx / 3,
          bottom: 80.0 + offset.dy / 2,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    this.onPressed,
    @required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Color(0xFF99163D),
      //color: theme.accentColor,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
