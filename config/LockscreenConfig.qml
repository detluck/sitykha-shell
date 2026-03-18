import Quickshell.Io

JsonObject {

    property General general: General{}
    property LockSurface lockSurface: LockSurface{}
    property Clock clock: Clock{}
    property Date date: Date{}
    property Message message: Message{}
    property LoginScreen loginScreen: LoginScreen{}
    property LoginArea loginArea: LoginArea{}
    property Avatar avatar: Avatar{}
    property PasswordInput input: PasswordInput{}
    property LoginButton loginButton: LoginButton{}
    property Tooltips tooltips: Tooltips{}

    component General: JsonObject {
        property double scale: 1.0
        property bool enableAnimations: true
        property string animatedBackgroundPlaceholder: ""
        property string backgroundFillMode: "fill"
    }

    component LockSurface: JsonObject {
        property bool display: true
        property int paddingTop: 0
        property int paddingRight: 0
        property int paddingBottom: 0
        property int paddingLeft: 0
        property string background: ""
        property bool useBackgroundColor: true
        property string backgroundColor: "#1e1e2e"
        property int blur: 0
        property double brightness: 0.0
        property double saturation: 0.0
    }


    component Clock: JsonObject {
        property bool display: true
        property string position: "center"
        property string align: "center"
        property string format: "hh:mm"
        property string fontFamily: "JetBrainsMono"
        property int fontSize: 70
        property int fontWeight: 900
        property string color: "#cdd6f4"
    }

    component Date: JsonObject {
        property bool display: true
        property string format: "dddd, MMMM dd, yyyy"
        property string locale: "en_US"
        property string fontFamily: "JetBrainsMono"
        property int fontSize: 14
        property int fontWeight: 600
        property string color: "#cdd6f4"
        property int marginTop: -15
    }

    component Message: JsonObject {
        property bool display: true
        property string position: "bottom-center"
        property string align: "center"
        property string text: "Press any key"
        property string fontFamily: "JetBrainsMono"
        property int fontSize: 12
        property int fontWeight: 400
        property bool displayIcon: true
        property string icon: "catppuccin.png"
        property string iconFontFamily: "NerdFont"
        property int iconSize: 16
        property string color: "#cdd6f4"
        property bool paintIcon: false
        property int spacing: 0
    }

    component LoginScreen: JsonObject {
        property string background: ""
        property bool useBackgroundColor: true
        property string backgroundColor: "#1e1e2e"
        property int blur: 0
        property double brightness: 0.0
        property double saturation: 0.0
    }

    component LoginArea: JsonObject {
        property string position: "center"
        property int margin: -1
    }

    component Avatar: JsonObject {
        property string shape: "circle"
        property int borderRadius: 35
        property int activeSize: 120
        property int inactiveSize: 80
        property double inactiveOpacity: 0.35
        property int activeBorderSize: 0
        property int inactiveBorderSize: 0
        property string activeBorderColor: "#89dceb"
        property string inactiveBorderColor: "#89dceb"
    }

    component PasswordInput: JsonObject {
        property int width: 200
        property int height: 30
        property bool displayIcon: false
        property string fontFamily: "JetBrainsMono"
        property int fontSize: 12
        property string icon: "password.svg"
        property string iconFontFamily: "NerdFont"
        property int iconSize: 16
        property string contentColor: "#cdd6f4"
        property string backgroundColor: "#313244"
        property double backgroundOpacity: 1.0
        property int borderSize: 0
        property string borderColor: "#89dceb"
        property int borderRadiusLeft: 10
        property int borderRadiusRight: 10
        property int marginTop: 10
        property string maskedCharacter: "●"
    }

    component LoginButton: JsonObject {
        property string backgroundColor: "#313244"
        property double backgroundOpacity: 1.0
        property string activeBackgroundColor: "#74c7ec"
        property double activeBackgroundOpacity: 1.0
        property string icon: "arrow-right.svg"
        property string iconFontFamily: "NerdFont"
        property int iconSize: 18
        property string contentColor: "#74c7ec"
        property string activeContentColor: "#1e1e2e"
        property int borderSize: 0
        property string borderColor: "#89dceb"
        property int borderRadiusLeft: 10
        property int borderRadiusRight: 10
        property int marginLeft: 5
        property bool showTextIfNoPassword: true
        property bool hideIfNotNeeded: false
        property string fontFamily: "JetBrainsMono"
        property int fontSize: 12
        property int fontWeight: 600
    }

    component Tooltips: JsonObject {
        property bool enable: true
        property string fontFamily: "JetBrainsMono"
        property int fontSize: 11
        property string contentColor: "#cdd6f4"
        property string backgroundColor: "#313244"
        property double backgroundOpacity: 1.0
        property int borderRadius: 10
        property bool disableUser: false
        property bool disableLoginButton: false
    }
}
