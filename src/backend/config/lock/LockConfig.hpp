#pragma once
#include "../ConfigObject.hpp"
#include <QString>
#include <QtQmlIntegration>

namespace sitykha::config {

// ==========================================
// 1. LEAF CLASSES (Deepest nested objects)
// ==========================================

class ClockConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(
      bool, display,
      true) // @desc:Whether or not to display the clock in the lock screen.
  CONFIG_PROPERTY(
      QString, position,
      "top-center") // @possible:'top-left' | 'top-center' | 'top-right' |
                    // 'center-left' | 'center' | 'center-right' | 'bottom-left'
                    // | 'bottom-center' | 'bottom-right' @desc:Position of the
                    // clock and date in the lock screen.
  CONFIG_PROPERTY(QString, align,
                  "center") // @possible:'left' | 'center' | 'right'
                            // @desc:Relative alignment of the clock and date.
  CONFIG_PROPERTY(QString, format,
                  "hh:mm") // @desc:Format string used for the clock.
  CONFIG_PROPERTY(QString, fontFamily,
                  "RedHatDisplay")      // @desc:Font family used for the clock.
  CONFIG_PROPERTY(int, fontSize, 70)    // @desc:Font size of the clock.
  CONFIG_PROPERTY(int, fontWeight, 900) // @desc:Font weight of the clock. 400 =
                                        // regular, 600 = bold, 800 = black
  CONFIG_PROPERTY(QString, color, "#FFFFFF") // @desc:Color of the clock.
public:
  explicit ClockConfig(QObject *parent = nullptr);
};

class DateConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(
      bool, display,
      true) // @desc:Whether or not to display the date in the lock screen.
  CONFIG_PROPERTY(
      QString, format,
      "dddd, MMMM dd, yyyy") // @desc:Format string used for the date.
  CONFIG_PROPERTY(
      QString, locale,
      "en_US") // @desc:Language of the date defined by lang_COUNTRY.
  CONFIG_PROPERTY(QString, fontFamily,
                  "RedHatDisplay")      // @desc:Font family used for the date.
  CONFIG_PROPERTY(int, fontSize, 14)    // @desc:Font size of the date.
  CONFIG_PROPERTY(int, fontWeight, 400) // @desc:Font weight of the date.
  CONFIG_PROPERTY(QString, color, "#FFFFFF") // @desc:Color of the date.
  CONFIG_PROPERTY(int, marginTop, 0)         // @desc:Top margin from the clock
public:
  explicit DateConfig(QObject *parent = nullptr);
};

class MessageConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(bool, display,
                  true) // @desc:Whether or not to display the custom message.
  CONFIG_PROPERTY(QString, position,
                  "bottom-center") // @desc:Position of the custom message.
  CONFIG_PROPERTY(
      QString, align,
      "center") // @desc:Relative alignment of the custom message and its icon.
  CONFIG_PROPERTY(QString, text,
                  "Press any key") // @desc:Text of the custom message.
  CONFIG_PROPERTY(
      QString, fontFamily,
      "RedHatDisplay") // @desc:Font family used for the custom message.
  CONFIG_PROPERTY(int, fontSize, 12) // @desc:Font size of the custom message.
  CONFIG_PROPERTY(int, fontWeight, 400) // @desc:Font weight of the message.
  CONFIG_PROPERTY(bool, displayIcon,
                  true) // @desc:Show or hide the icon above the message.
  CONFIG_PROPERTY(QString, icon,
                  "enter.svg")       // @desc:Icon above the custom message.
  CONFIG_PROPERTY(int, iconSize, 16) // @desc:Size of the custom message's icon.
  CONFIG_PROPERTY(QString, color,
                  "#FFFFFF") // @desc:Color of the custom message.
  CONFIG_PROPERTY(bool, paintIcon,
                  true) // @desc:Whether or not to paint the icon with the same
                        // color as the text.
  CONFIG_PROPERTY(int, spacing,
                  0) // @desc:Spacing between the icon and the text.
public:
  explicit MessageConfig(QObject *parent = nullptr);
};

class AvatarConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(bool, display,
                  true) // @desc:Whether or not to display user avatars.
  CONFIG_PROPERTY(
      QString, shape,
      "circle") // @possible:'circle' || 'square' @desc:Shape of the avatar.
  CONFIG_PROPERTY(int, borderRadius,
                  0) // @desc:Border radius of the 'square' avatar.
  CONFIG_PROPERTY(int, activeSize,
                  120) // @desc:Size of the selected user's avatar.
  CONFIG_PROPERTY(int, inactiveSize,
                  80) // @desc:Size of the non-selected user avatars.
  CONFIG_PROPERTY(double, inactiveOpacity,
                  0.35) // @desc:Opacity of the non-selected avatars.
  CONFIG_PROPERTY(int, activeBorderSize,
                  0) // @desc:Border size of the selected user's avatar.
  CONFIG_PROPERTY(int, inactiveBorderSize,
                  0) // @desc:Border size of the non-selected avatars.
  CONFIG_PROPERTY(
      QString, activeBorderColor,
      "#FFFFFF") // @desc:Border color of the selected user's avatar.
  CONFIG_PROPERTY(QString, inactiveBorderColor,
                  "#FFFFFF") // @desc:Border color of the non-selected avatars.
public:
  explicit AvatarConfig(QObject *parent = nullptr);
};

class UsernameConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(QString, fontFamily,
                  "RedHatDisplay")   // @desc:Font family used for the username.
  CONFIG_PROPERTY(int, fontSize, 16) // @desc:Font size of the username.
  CONFIG_PROPERTY(int, fontWeight, 900) // @desc:Font weight of the username.
  CONFIG_PROPERTY(QString, color, "#FFFFFF") // @desc:Color of the username.
  CONFIG_PROPERTY(int, margin,
                  0) // @desc:Distance of the username from the avatar.
public:
  explicit UsernameConfig(QObject *parent = nullptr);
};

class PasswordInputConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(int, width, 200) // @desc:Width of the password field.
  CONFIG_PROPERTY(int, height, 30) // @desc:Height of the password field.
  CONFIG_PROPERTY(bool, displayIcon,
                  true) // @desc:Whether or not to display the icon.
  CONFIG_PROPERTY(QString, fontFamily,
                  "RedHatDisplay")   // @desc:Font family of the password field.
  CONFIG_PROPERTY(int, fontSize, 12) // @desc:Font size of the password field.
  CONFIG_PROPERTY(QString, icon,
                  "password.svg") // @desc:Icon in the password field.
  CONFIG_PROPERTY(int, iconSize,
                  16) // @desc:Size of the icon inside the password field.
  CONFIG_PROPERTY(QString, contentColor, "#FFFFFF") // @desc:Color of text/icon.
  CONFIG_PROPERTY(QString, backgroundColor,
                  "#FFFFFF") // @desc:Background color.
  CONFIG_PROPERTY(double, backgroundOpacity,
                  0.15)               // @desc:Opacity of the background.
  CONFIG_PROPERTY(int, borderSize, 1) // @desc:Size of the border.
  CONFIG_PROPERTY(QString, borderColor, "#FFFFFF") // @desc:Color of the border.
  CONFIG_PROPERTY(int, borderRadiusLeft, 8)        // @desc:Left border radius.
  CONFIG_PROPERTY(int, borderRadiusRight, 8)       // @desc:Right border radius.
  CONFIG_PROPERTY(int, marginTop, 15) // @desc:Distance from the username.
  CONFIG_PROPERTY(QString, maskedCharacter,
                  "●") // @desc:Customized masked character.
public:
  explicit PasswordInputConfig(QObject *parent = nullptr);
};

class LoginButtonConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(QString, backgroundColor,
                  "#FFFFFF") // @desc:Background color of the login button.
  CONFIG_PROPERTY(double, backgroundOpacity,
                  0.15) // @desc:Opacity of the background.
  CONFIG_PROPERTY(QString, activeBackgroundColor,
                  "#FFFFFF") // @desc:Background color when hovered/focused.
  CONFIG_PROPERTY(double, activeBackgroundOpacity,
                  0.3) // @desc:Opacity when hovered/focused.
  CONFIG_PROPERTY(QString, icon,
                  "arrow-right.svg") // @desc:Icon in the login button
  CONFIG_PROPERTY(int, iconSize, 18) // @desc:Size of the icon.
  CONFIG_PROPERTY(QString, contentColor,
                  "#FFFFFF") // @desc:Color of the icon/text.
  CONFIG_PROPERTY(
      QString, activeContentColor,
      "#FFFFFF") // @desc:Color of the icon/text when hovered/focused.
  CONFIG_PROPERTY(int, borderSize, 1)              // @desc:Border size.
  CONFIG_PROPERTY(QString, borderColor, "#FFFFFF") // @desc:Border color.
  CONFIG_PROPERTY(int, borderRadiusLeft, 8)        // @desc:Left border radius.
  CONFIG_PROPERTY(int, borderRadiusRight, 8)       // @desc:Right border radius.
  CONFIG_PROPERTY(int, marginLeft,
                  10) // @desc:Distance from the password field.
  CONFIG_PROPERTY(bool, showTextIfNoPassword,
                  true) // @desc:Show label when password field is not visible.
  CONFIG_PROPERTY(bool, hideIfNotNeeded,
                  false) // @desc:Hide if password field is visible.
  CONFIG_PROPERTY(QString, fontFamily, "RedHatDisplay") // @desc:Font family.
  CONFIG_PROPERTY(int, fontSize, 12)                    // @desc:Font size.
  CONFIG_PROPERTY(int, fontWeight, 600)                 // @desc:Font weight.
public:
  explicit LoginButtonConfig(QObject *parent = nullptr);
};

class SpinnerConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(bool, displayText,
                  true) // @desc:Display text with spinning icon.
  CONFIG_PROPERTY(QString, text, "Logging in") // @desc:Text to be displayed.
  CONFIG_PROPERTY(QString, fontFamily, "RedHatDisplay") // @desc:Font family.
  CONFIG_PROPERTY(int, fontWeight, 600)                 // @desc:Font weight.
  CONFIG_PROPERTY(int, fontSize, 12)                    // @desc:Font size.
  CONFIG_PROPERTY(int, iconSize, 32)            // @desc:Size of spinning icon.
  CONFIG_PROPERTY(QString, icon, "spinner.svg") // @desc:Spinning icon.
  CONFIG_PROPERTY(QString, color, "#FFFFFF")    // @desc:Color of icon and text.
  CONFIG_PROPERTY(int, spacing, 0) // @desc:Spacing between icon and text.
public:
  explicit SpinnerConfig(QObject *parent = nullptr);
};

class WarningMessageConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(QString, fontFamily, "RedHatDisplay") // @desc:Font family.
  CONFIG_PROPERTY(int, fontSize, 11)                    // @desc:Font size.
  CONFIG_PROPERTY(int, fontWeight, 400)                 // @desc:Font weight.
  CONFIG_PROPERTY(QString, normalColor,
                  "#FFFFFF") // @desc:Color for normal messages.
  CONFIG_PROPERTY(QString, warningColor, "#FFFFFF") // @desc:Color for warnings.
  CONFIG_PROPERTY(QString, errorColor,
                  "#FFFFFF")         // @desc:Color for error messages.
  CONFIG_PROPERTY(int, marginTop, 0) // @desc:Distance from password field.
public:
  explicit WarningMessageConfig(QObject *parent = nullptr);
};

class MenuButtonsConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(int, marginTop, 0)    // @desc:Top margin of the menu buttons.
  CONFIG_PROPERTY(int, marginRight, 0)  // @desc:Right margin.
  CONFIG_PROPERTY(int, marginBottom, 0) // @desc:Bottom margin.
  CONFIG_PROPERTY(int, marginLeft, 0)   // @desc:Left margin.
  CONFIG_PROPERTY(int, size, 30)        // @desc:Size of buttons.
  CONFIG_PROPERTY(int, borderRadius, 0) // @desc:Border radius.
  CONFIG_PROPERTY(int, spacing, 0)      // @desc:Spacing between buttons.
  CONFIG_PROPERTY(QString, fontFamily, "RedHatDisplay") // @desc:Font family.
public:
  explicit MenuButtonsConfig(QObject *parent = nullptr);
};

class MenuPopupsConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(int, maxHeight, 300)          // @desc:Max height of popups.
  CONFIG_PROPERTY(int, itemHeight, 30)          // @desc:Height of items.
  CONFIG_PROPERTY(int, spacing, 0)              // @desc:Spacing between items.
  CONFIG_PROPERTY(int, padding, 0)              // @desc:Padding of popups.
  CONFIG_PROPERTY(bool, displayScrollbar, true) // @desc:Display a scrollbar.
  CONFIG_PROPERTY(int, margin, 0)               // @desc:Distance from button.
  CONFIG_PROPERTY(QString, backgroundColor,
                  "#FFFFFF") // @desc:Background color.
  CONFIG_PROPERTY(double, backgroundOpacity,
                  0.0) // @desc:Opacity of background.
  CONFIG_PROPERTY(QString, activeOptionBackgroundColor,
                  "#FFFFFF") // @desc:Background color of hovered item.
  CONFIG_PROPERTY(double, activeOptionBackgroundOpacity,
                  0.0) // @desc:Opacity of hovered item.
  CONFIG_PROPERTY(QString, contentColor,
                  "#FFFFFF") // @desc:Color of non-selected text.
  CONFIG_PROPERTY(QString, activeContentColor,
                  "#FFFFFF") // @desc:Color of hovered text.
  CONFIG_PROPERTY(QString, fontFamily, "RedHatDisplay") // @desc:Font family.
  CONFIG_PROPERTY(int, borderSize, 0)                   // @desc:Border size.
  CONFIG_PROPERTY(QString, borderColor, "#FFFFFF")      // @desc:Border color.
  CONFIG_PROPERTY(int, fontSize, 11)                    // @desc:Font size.
  CONFIG_PROPERTY(int, iconSize, 16)                    // @desc:Icon size.
public:
  explicit MenuPopupsConfig(QObject *parent = nullptr);
};

class MenuSessionConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(bool, display, true) // @desc:Display session button.
  CONFIG_PROPERTY(QString, position, "bottom-left") // @desc:Position.
  CONFIG_PROPERTY(int, index, 0)                    // @desc:Sort order.
  CONFIG_PROPERTY(QString, popupDirection, "up")    // @desc:Direction to open.
  CONFIG_PROPERTY(QString, popupAlign, "center")    // @desc:Alignment of popup.
  CONFIG_PROPERTY(bool, displaySessionName,
                  true)                  // @desc:Display current session name.
  CONFIG_PROPERTY(int, buttonWidth, 200) // @desc:Width. Set to -1 for auto.
  CONFIG_PROPERTY(int, popupWidth, 200)  // @desc:Popup width.
  CONFIG_PROPERTY(QString, backgroundColor,
                  "#FFFFFF")                      // @desc:Background color.
  CONFIG_PROPERTY(double, backgroundOpacity, 0.0) // @desc:Opacity.
  CONFIG_PROPERTY(double, activeBackgroundOpacity,
                  0.0) // @desc:Hovered opacity.
  CONFIG_PROPERTY(QString, contentColor,
                  "#FFFFFF") // @desc:Icon and text color.
  CONFIG_PROPERTY(QString, activeContentColor,
                  "#FFFFFF")          // @desc:Hovered text color.
  CONFIG_PROPERTY(QString, btnContentHoveredColor,
                  "#FFFFFF")          // @desc:Hovered button icon color.
  CONFIG_PROPERTY(int, borderSize, 0) // @desc:Border size.
  CONFIG_PROPERTY(int, fontSize, 10)  // @desc:Font size.
  CONFIG_PROPERTY(int, iconSize, 16)  // @desc:Icon size.
public:
  explicit MenuSessionConfig(QObject *parent = nullptr);
};

class MenuLayoutConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(bool, display, true) // @desc:Display layout button.
  CONFIG_PROPERTY(QString, position, "bottom-right") // @desc:Position.
  CONFIG_PROPERTY(int, index, 1)                     // @desc:Sort order.
  CONFIG_PROPERTY(QString, popupDirection, "up")     // @desc:Direction to open.
  CONFIG_PROPERTY(QString, popupAlign, "center") // @desc:Alignment of popup.
  CONFIG_PROPERTY(int, popupWidth, 180)          // @desc:Popup width.
  CONFIG_PROPERTY(bool, displayLayoutName, true) // @desc:Display country code.
  CONFIG_PROPERTY(QString, backgroundColor,
                  "#FFFFFF")                      // @desc:Background color.
  CONFIG_PROPERTY(double, backgroundOpacity, 0.0) // @desc:Opacity.
  CONFIG_PROPERTY(double, activeBackgroundOpacity,
                  0.0)                              // @desc:Hovered opacity.
  CONFIG_PROPERTY(QString, contentColor, "#FFFFFF") // @desc:Text color.
  CONFIG_PROPERTY(QString, activeContentColor,
                  "#FFFFFF")                     // @desc:Hovered text color.
  CONFIG_PROPERTY(QString, btnContentHoveredColor,
                  "#FFFFFF")                     // @desc:Hovered button icon color.
  CONFIG_PROPERTY(int, borderSize, 0)            // @desc:Border size.
  CONFIG_PROPERTY(int, fontSize, 10)             // @desc:Font size.
  CONFIG_PROPERTY(QString, icon, "language.svg") // @desc:Icon.
  CONFIG_PROPERTY(int, iconSize, 16)             // @desc:Icon size.
public:
  explicit MenuLayoutConfig(QObject *parent = nullptr);
};

class MenuPowerConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(bool, display, true) // @desc:Display power button.
  CONFIG_PROPERTY(QString, position, "bottom-right") // @desc:Position.
  CONFIG_PROPERTY(int, index, 3)                     // @desc:Sort order.
  CONFIG_PROPERTY(QString, popupDirection, "up")     // @desc:Direction to open.
  CONFIG_PROPERTY(QString, popupAlign, "center") // @desc:Alignment of popup.
  CONFIG_PROPERTY(int, popupWidth, 90)           // @desc:Popup width.
  CONFIG_PROPERTY(QString, backgroundColor,
                  "#FFFFFF")                      // @desc:Background color.
  CONFIG_PROPERTY(double, backgroundOpacity, 0.0) // @desc:Opacity.
  CONFIG_PROPERTY(double, activeBackgroundOpacity,
                  0.0)                              // @desc:Hovered opacity.
  CONFIG_PROPERTY(QString, contentColor, "#FFFFFF") // @desc:Icon color.
  CONFIG_PROPERTY(QString, activeContentColor,
                  "#FFFFFF")                  // @desc:Hovered icon color.
  CONFIG_PROPERTY(QString, btnContentHoveredColor,
                  "#FFFFFF")                  // @desc:Hovered button icon color.
  CONFIG_PROPERTY(int, borderSize, 0)         // @desc:Border size.
  CONFIG_PROPERTY(QString, icon, "power.svg") // @desc:Icon.
  CONFIG_PROPERTY(int, iconSize, 16)          // @desc:Icon size.
public:
  explicit MenuPowerConfig(QObject *parent = nullptr);
};

class TooltipsConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(bool, enable, true) // @desc:Show tooltips on hover.
  CONFIG_PROPERTY(QString, fontFamily, "RedHatDisplay") // @desc:Font family.
  CONFIG_PROPERTY(int, fontSize, 11)                    // @desc:Font size.
  CONFIG_PROPERTY(QString, contentColor, "#FFFFFF")     // @desc:Text color.
  CONFIG_PROPERTY(QString, backgroundColor,
                  "#FFFFFF")                      // @desc:Background color.
  CONFIG_PROPERTY(double, backgroundOpacity, 0.0) // @desc:Background opacity.
  CONFIG_PROPERTY(int, borderRadius, 5)           // @desc:Border radius.
  CONFIG_PROPERTY(bool, disableUser,
                  false) // @desc:Disables only user selector tooltip.
  CONFIG_PROPERTY(bool, disableLoginButton,
                  false) // @desc:Disables only login button tooltip.
public:
  explicit TooltipsConfig(QObject *parent = nullptr);
};

// ==========================================
// 2. MID-LEVEL BRANCH CLASSES
// ==========================================

class LockScreenConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(bool, display, true)
  CONFIG_PROPERTY(int, paddingTop, 0)
  CONFIG_PROPERTY(int, paddingRight, 0)
  CONFIG_PROPERTY(int, paddingBottom, 0)
  CONFIG_PROPERTY(int, paddingLeft, 0)
  CONFIG_PROPERTY(QString, background, "default.jpg")
  CONFIG_PROPERTY(bool, useBackgroundColor, false)
  CONFIG_PROPERTY(QString, backgroundColor, "#000000")
  CONFIG_PROPERTY(int, blur, 0)
  CONFIG_PROPERTY(double, brightness, 0.0)
  CONFIG_PROPERTY(double, saturation, 0.0)

  // Sub-objects
  CONFIG_SUBOBJECT(ClockConfig, clock)
  CONFIG_SUBOBJECT(DateConfig, date)
  CONFIG_SUBOBJECT(MessageConfig, message)
public:
  explicit LockScreenConfig(QObject *parent = nullptr);
};

class LoginAreaConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(QString, position, "center")
  CONFIG_PROPERTY(int, margin, 0)

  // Sub-objects
  CONFIG_SUBOBJECT(AvatarConfig, avatar)
  CONFIG_SUBOBJECT(UsernameConfig, username)
  CONFIG_SUBOBJECT(PasswordInputConfig, passwordInput)
  CONFIG_SUBOBJECT(LoginButtonConfig, loginButton)
  CONFIG_SUBOBJECT(SpinnerConfig, spinner)
  CONFIG_SUBOBJECT(WarningMessageConfig, warningMessage)
public:
  explicit LoginAreaConfig(QObject *parent = nullptr);
};

class MenuAreaConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_SUBOBJECT(MenuButtonsConfig, buttons)
  CONFIG_SUBOBJECT(MenuPopupsConfig, popups)
  CONFIG_SUBOBJECT(MenuSessionConfig, session)
  CONFIG_SUBOBJECT(MenuLayoutConfig, layout)
  CONFIG_SUBOBJECT(MenuPowerConfig, power)
public:
  explicit MenuAreaConfig(QObject *parent = nullptr);
};

// ==========================================
// 3. HIGH-LEVEL BRANCH CLASSES
// ==========================================

class LoginScreenConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS
  CONFIG_PROPERTY(QString, background, "default.jpg")
  CONFIG_PROPERTY(bool, useBackgroundColor, false)
  CONFIG_PROPERTY(QString, backgroundColor, "#000000")
  CONFIG_PROPERTY(int, blur, 0)
  CONFIG_PROPERTY(double, brightness, 0.0)
  CONFIG_PROPERTY(double, saturation, 0.0)

  // Sub-objects
  CONFIG_SUBOBJECT(LoginAreaConfig, loginArea)
  CONFIG_SUBOBJECT(MenuAreaConfig, menuArea)
public:
  explicit LoginScreenConfig(QObject *parent = nullptr);
};

// ==========================================
// 4. ROOT CLASS (LockConfig)
// ==========================================

class LockConfig : public ConfigObject {
  Q_OBJECT
  QML_ANONYMOUS

  // General properties
  CONFIG_PROPERTY(double, generalScale, 1.0)
  CONFIG_PROPERTY(bool, enableAnimations, true)
  CONFIG_PROPERTY(QString, animatedBackgroundPlaceholder, "")
  CONFIG_PROPERTY(QString, backgroundFillMode, "fill")

  // The major sections
  CONFIG_SUBOBJECT(LockScreenConfig, lockScreen)
  CONFIG_SUBOBJECT(LoginScreenConfig, loginScreen)
  CONFIG_SUBOBJECT(TooltipsConfig, tooltips)

public:
  explicit LockConfig(QObject *parent = nullptr);
};

} // namespace sitykha::config
