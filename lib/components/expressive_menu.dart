import 'package:flutter/material.dart';

class ExpressiveMenu extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    MenuController controller,
    Widget? child,
  )
  builder;
  final List<Widget> menuChildren;
  const ExpressiveMenu({
    super.key,
    required this.builder,
    required this.menuChildren,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      animated: true,
      style: MenuStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          return Theme.of(context).colorScheme.surfaceContainer;
        }),
      ),
      builder: builder,
      menuChildren: menuChildren,
    );
  }
}

class ExpressiveMenuItem extends StatelessWidget {
  final Function onPressed;
  final Widget child;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool active;
  const ExpressiveMenuItem({
    super.key,
    required this.onPressed,
    required this.child,
    this.leadingIcon,
    this.trailingIcon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
      child: MenuItemButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.hovered) && !active) {
              return Theme.of(context).colorScheme.surfaceContainerLow;
            }
            if (active) {
              return Theme.of(context).colorScheme.primaryContainer;
            }
            return null;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            // if (active) {
            //   return Theme.of(context).colorScheme.onPrimaryContainer;
            // }
            // return Theme.of(context).colorScheme.onSurfaceVariant;
            return Theme.of(context).colorScheme.onPrimaryContainer;
          }),
          iconColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            // if (active) {
            //   return Theme.of(context).colorScheme.onPrimaryContainer;
            // }
            // return Theme.of(context).colorScheme.onSurfaceVariant;
            return Theme.of(context).colorScheme.onPrimaryContainer;
          }),
        ),
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        child: child,
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
