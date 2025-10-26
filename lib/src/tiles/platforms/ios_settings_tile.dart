import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class IOSSettingsTile extends StatefulWidget {
  const IOSSettingsTile({
    required this.tileType,
    this.leading,
    this.title,
    this.titleDescription,
    this.description,
    this.onPressed,
    this.onToggle,
    this.value,
    this.initialValue,
    this.activeSwitchColor,
    this.enabled = true,
    this.trailing,
    this.titlePadding,
    this.leadingPadding,
    this.titleDescriptionPadding,
    super.key,
  });

  final SettingsTileType tileType;
  final Widget? leading;
  final Widget? title;
  final Widget? titleDescription;
  final Widget? description;
  final Function(BuildContext context)? onPressed;
  final Function(bool value)? onToggle;
  final Widget? value;
  final bool? initialValue;
  final bool enabled;
  final Color? activeSwitchColor;
  final Widget? trailing;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? leadingPadding;
  final EdgeInsetsGeometry? titleDescriptionPadding;

  @override
  State<IOSSettingsTile> createState() => _IOSSettingsTileState();
}

class _IOSSettingsTileState extends State<IOSSettingsTile> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);
    final additionalInfo = IOSSettingsTileAdditionalInfo.of(context);

    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Column(
        children: [
          _buildTile(context, theme, additionalInfo),
          if (widget.description != null)
            _buildDescription(context, theme, additionalInfo),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, SettingsTheme theme,
      IOSSettingsTileAdditionalInfo additionalInfo) {
    Widget content = _buildTileContent(context, theme, additionalInfo);

    // Wrap with Material for ripple effect on Android
    if (Theme.of(context).platform != TargetPlatform.iOS) {
      content = Material(color: Colors.transparent, child: content);
    }

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: additionalInfo.enableTopBorderRadius
            ? const Radius.circular(12)
            : Radius.zero,
        bottom: additionalInfo.enableBottomBorderRadius
            ? const Radius.circular(12)
            : Radius.zero,
      ),
      child: content,
    );
  }

  Widget _buildDescription(BuildContext context, SettingsTheme theme,
      IOSSettingsTileAdditionalInfo additionalInfo) {
    final scale = MediaQuery.of(context).textScaleFactor;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 8 * scale,
        bottom: additionalInfo.needToShowDivider ? 24 : 8 * scale,
      ),
      color: theme.themeData.settingsListBackground,
      child: DefaultTextStyle(
        style: TextStyle(
          color: theme.themeData.titleTextColor,
          fontSize: 13 * scale,
        ),
        child: widget.description!,
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, SettingsTheme theme) {
    final scale = MediaQuery.of(context).textScaleFactor;
    final showValue = widget.tileType == SettingsTileType.navigationTile &&
        widget.value != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.trailing != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconTheme(
              data: IconTheme.of(context).copyWith(
                color: widget.enabled
                    ? theme.themeData.leadingIconsColor
                    : theme.themeData.inactiveTitleColor,
              ),
              child: widget.trailing!,
            ),
          ),
        if (widget.tileType == SettingsTileType.switchTile)
          _buildAdaptiveSwitch(context),
        if (showValue)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DefaultTextStyle(
              style: TextStyle(
                color: widget.enabled
                    ? theme.themeData.trailingTextColor
                    : theme.themeData.inactiveTitleColor,
                fontSize: 17 * scale,
              ),
              child: widget.value!,
            ),
          ),
        if (widget.tileType == SettingsTileType.navigationTile)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
            child: Icon(
              PlatformUtils.languageIsRTL(context)
                  ? CupertinoIcons.chevron_back
                  : CupertinoIcons.chevron_forward,
              size: 18 * scale,
              color: theme.themeData.leadingIconsColor,
            ),
          ),
      ],
    );
  }

  Widget _buildAdaptiveSwitch(BuildContext context) {
    final platform = Theme.of(context).platform;
    final switchValue = widget.initialValue ?? true;

    if (platform == TargetPlatform.iOS) {
      return CupertinoSwitch(
        value: switchValue,
        onChanged: widget.onToggle,
        activeColor: widget.enabled
            ? widget.activeSwitchColor
            : SettingsTheme.of(context).themeData.inactiveTitleColor,
      );
    } else {
      return Switch.adaptive(
        value: switchValue,
        onChanged: widget.onToggle,
        activeColor: widget.enabled
            ? widget.activeSwitchColor
            : SettingsTheme.of(context).themeData.inactiveTitleColor,
      );
    }
  }

  Widget _buildTileContent(BuildContext context, SettingsTheme theme,
      IOSSettingsTileAdditionalInfo additionalInfo) {
    final scale = MediaQuery.of(context).textScaleFactor;

    return InkWell(
      onTap: widget.onPressed == null ? null : () => widget.onPressed!(context),
      borderRadius: BorderRadius.vertical(
        top: additionalInfo.enableTopBorderRadius
            ? const Radius.circular(12)
            : Radius.zero,
        bottom: additionalInfo.enableBottomBorderRadius
            ? const Radius.circular(12)
            : Radius.zero,
      ),
      child: Container(
        color: isPressed
            ? theme.themeData.tileHighlightColor
            : theme.themeData.settingsSectionBackground,
        padding: const EdgeInsetsDirectional.only(start: 18),
        child: Row(
          children: [
            if (widget.leading != null)
              Padding(
                padding: widget.leadingPadding ??
                    const EdgeInsetsDirectional.only(end: 12),
                child: IconTheme.merge(
                  data: IconThemeData(
                    color: widget.enabled
                        ? theme.themeData.leadingIconsColor
                        : theme.themeData.inactiveTitleColor,
                  ),
                  child: widget.leading!,
                ),
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.title != null)
                                Padding(
                                  padding: widget.titlePadding ??
                                      EdgeInsets.only(
                                        top: 12.5 * scale,
                                        bottom: widget.titleDescription == null
                                            ? 12.5 * scale
                                            : 3.5 * scale,
                                      ),
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: widget.enabled
                                          ? theme.themeData.settingsTileTextColor
                                          : theme.themeData.inactiveTitleColor,
                                      fontSize: 16 * scale,
                                    ),
                                    child: widget.title!,
                                  ),
                                ),
                              if (widget.titleDescription != null)
                                Padding(
                                  padding: widget.titleDescriptionPadding ??
                                      EdgeInsets.only(bottom: 12.5 * scale),
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: widget.enabled
                                          ? theme.themeData.titleTextColor
                                          : theme.themeData.inactiveTitleColor,
                                      fontSize: 15 * scale,
                                    ),
                                    child: widget.titleDescription!,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        _buildTrailing(context, theme),
                      ],
                    ),
                  ),
                  if (widget.description == null &&
                      additionalInfo.needToShowDivider)
                    Divider(
                      height: 0,
                      thickness: 0.7,
                      color: theme.themeData.dividerColor,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IOSSettingsTileAdditionalInfo extends InheritedWidget {
  final bool needToShowDivider;
  final bool enableTopBorderRadius;
  final bool enableBottomBorderRadius;

  const IOSSettingsTileAdditionalInfo({
    super.key,
    required this.needToShowDivider,
    required this.enableTopBorderRadius,
    required this.enableBottomBorderRadius,
    required super.child,
  });

  @override
  bool updateShouldNotify(IOSSettingsTileAdditionalInfo oldWidget) => true;

  static IOSSettingsTileAdditionalInfo of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<IOSSettingsTileAdditionalInfo>() ??
        const IOSSettingsTileAdditionalInfo(
          needToShowDivider: true,
          enableTopBorderRadius: true,
          enableBottomBorderRadius: true,
          child: SizedBox(),
        );
  }
}
