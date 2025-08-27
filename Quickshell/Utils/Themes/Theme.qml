// Theme.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Utils
import qs.Services

Singleton {
    id: root

    // Accent Colors
    property color accentPrimary: themeData.accentPrimary
    property color accentSecondary: themeData.accentSecondary
    property color accentTertiary: themeData.accentTertiary

    // Backgrounds
    property color backgroundPrimary: themeData.backgroundPrimary
    property color backgroundSecondary: themeData.backgroundSecondary
    property color backgroundTertiary: themeData.backgroundTertiary
    property real borderWidth: 4
    property real defaultRadius: 50

    // Error/Warning
    property color error: themeData.error

    // Font Properties
    property string fontFamily: Settings.settings.general.fontFamily
    property int fontSizeBody: Math.round(16 * fontSizeMultiplier)       // Body text and general content
    property int fontSizeCaption: Math.round(12 * fontSizeMultiplier)    // Captions and fine print

    // Base font sizes (multiplied by fontSizeMultiplier)
    property int fontSizeHeader: Math.round(32 * fontSizeMultiplier)     // Headers and titles

    // Font size multiplier - adjust this in Settings.json to scale all fonts
    property real fontSizeMultiplier: Settings.settings.fontSizeMultiplier || 1.0
    property int fontSizeSmall: Math.round(14 * fontSizeMultiplier)      // Small text like clock, labels

    // Highlights & Focus
    property color highlight: themeData.highlight
    property real modHeight: 200
    property real modWidth: 70

    // Additional Theme Properties
    property color onAccent: themeData.onAccent
    property color outline: themeData.outline
    property color overlay: applyOpacity(themeData.overlay, "66")
    property variant palette: ["#FF383C", "#FF8D28", "#ffCC00", "#34C759", "#00C8B3", "#0cb0a9", "#00C3D0", "#0088FF", "#6155F5", "#CB30E0", "#FF2D55"]
    property color rippleEffect: themeData.rippleEffect

    // Shadows & Overlays
    property color shadow: applyOpacity(themeData.shadow, "B3")

    // Surfaces & Elevation
    property color surface: themeData.surface
    property color surfaceVariant: themeData.surfaceVariant
    property color textDisabled: themeData.textDisabled

    // Text Colors
    property color textPrimary: themeData.textPrimary
    property color textSecondary: themeData.textSecondary
    property color warning: themeData.warning

    function applyOpacity(color, opacity) {
        return color.replace("#", "#" + opacity);
    }

    function scale(currentScreen) {
        return 1.0;
        // Per-monitor override from settings
        try {
            const overrides = Settings.settings.monitorScaleOverrides || {};
            if (currentScreen && currentScreen.name && overrides[currentScreen.name] !== undefined) {
                return overrides[currentScreen.name];
            }
        } catch (e) {}
        return 1.0;
    }

    // FileView to load theme data from JSON file
    FileView {
        id: themeFile

        path: Paths.themeFile
        watchChanges: true

        onAdapterUpdated: writeAdapter()
        onFileChanged: reload()
        onLoadFailed: function (error) {
            if (error.toString().includes("No such file") || error === 2) {
                // File doesn't exist, create it with default values
                writeAdapter();
            }
        }

        JsonAdapter {
            id: themeData

            // Accent Colors
            property string accentPrimary: "#A8AEFF"
            property string accentSecondary: "#9EA0FF"
            property string accentTertiary: "#8EABFF"

            // Backgrounds
            property string backgroundPrimary: "#0C0D11"
            property string backgroundSecondary: "#151720"
            property string backgroundTertiary: "#1D202B"

            // Error/Warning
            property string error: "#FF6B81"

            // Highlights & Focus
            property string highlight: "#E3C2FF"

            // Additional Theme Properties
            property string onAccent: "#1A1A1A"
            property string outline: "#44485A"
            property string overlay: "#11121A"
            property string rippleEffect: "#F3DEFF"

            // Shadows & Overlays
            property string shadow: "#000000"

            // Surfaces & Elevation
            property string surface: "#1A1C26"
            property string surfaceVariant: "#2A2D3A"
            property string textDisabled: "#6B718A"

            // Text Colors
            property string textPrimary: "#CACEE2"
            property string textSecondary: "#B7BBD0"
            property string warning: "#FFBB66"
        }
    }
}
