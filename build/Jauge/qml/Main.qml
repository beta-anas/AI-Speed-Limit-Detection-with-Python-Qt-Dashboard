import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: root
    visible: true
    width: 500
    height: 590
    title: "Jauge avec Limiteur Dynamique"
    color: "black"

    // --- Propriétés globales ---
    property real speed: 0
    property real maxSpeedGauge: 240
    property real currentSpeedLimit: 240
    property bool limiterEnabled: false
    property bool accelerating: false
    property bool braking: false
    property real overrideThreshold: 1.0
    property real overrideTimer: 0

    // --- Connexion à l'objet C++ ---
    Connections {
        target: speedLimitReader
        onSpeedLimitChanged: {
            root.currentSpeedLimit = speedLimitReader.speedLimit;
            console.log("Limite dynamique reçue: " + root.currentSpeedLimit);
        }
        onLimiterEnabledChanged: {
            root.limiterEnabled = speedLimitReader.limiterEnabled;
            console.log("Limiteur " + (root.limiterEnabled ? "activé" : "désactivé"));
        }
    }

    FocusScope {
        anchors.fill: parent
        focus: true

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Up) {
                root.accelerating = true;
            } else if (event.key === Qt.Key_Down) {
                root.braking = true;
            } else if (event.key === Qt.Key_L) {
                // Optionnel : activer/désactiver localement (peut aussi venir du C++)
                root.limiterEnabled = !root.limiterEnabled;
                console.log("Limiteur togglé manuellement: " + root.limiterEnabled);
            }
        }

        Keys.onReleased: event => {
            if (event.key === Qt.Key_Up) {
                root.accelerating = false;
                root.overrideTimer = 0;
            } else if (event.key === Qt.Key_Down) {
                root.braking = false;
            }
        }
    }

    Timer {
        interval: 30
        running: true
        repeat: true

        onTriggered: {
            if (root.accelerating) {
                if (root.limiterEnabled && root.speed >= root.currentSpeedLimit) {
                    root.overrideTimer += interval / 1000.0;
                } else {
                    root.overrideTimer = 0;
                }
                var isOverride = root.overrideTimer >= root.overrideThreshold;

                var speedLimit = (root.limiterEnabled && !isOverride) ? root.currentSpeedLimit : root.maxSpeedGauge;
                root.speed = Math.min(root.speed + 1.5, speedLimit);
            } else if (root.braking) {
                root.speed = Math.max(root.speed - 2, 0);
            } else {
                if (root.limiterEnabled) {
                    if (root.speed > root.currentSpeedLimit) {
                        root.speed = Math.max(root.speed - 1, root.currentSpeedLimit);
                    } else if (root.speed < root.currentSpeedLimit) {
                        root.speed = Math.min(root.speed + 0.5, root.currentSpeedLimit);
                    }
                } else {
                    if (root.speed > 0) {
                        root.speed = Math.max(root.speed - 0.5, 0);
                    }
                }
            }
        }
    }

    Canvas {
        id: dial
        anchors.centerIn: parent
        width: 400
        height: 400

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var centerX = width / 2;
            var centerY = height / 2;
            var radius = 180;

            // Fond
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
            ctx.fillStyle = "#222";
            ctx.fill();

            // Dégradé radial (optionnel)
            var grad = ctx.createRadialGradient(centerX, centerY, 10, centerX, centerY, radius);
            grad.addColorStop(0, "#444");
            grad.addColorStop(1, "#ad020202");
            ctx.fillStyle = grad;
            ctx.fill();

            // Graduations
            ctx.strokeStyle = "white";
            ctx.lineWidth = 2;
            ctx.font = "bold 13px sans-serif";
            ctx.fillStyle = "white";

            for (var i = 0; i <= root.maxSpeedGauge; i += 20) {
                var angle = Math.PI * (0.75 + (i / root.maxSpeedGauge) * 1.5);
                var x1 = centerX + Math.cos(angle) * (radius - 10);
                var y1 = centerY + Math.sin(angle) * (radius - 10);
                var x2 = centerX + Math.cos(angle) * (radius - 30);
                var y2 = centerY + Math.sin(angle) * (radius - 30);

                ctx.beginPath();
                ctx.moveTo(x1, y1);
                ctx.lineTo(x2, y2);
                ctx.stroke();

                var tx = centerX + Math.cos(angle) * (radius - 45);
                var ty = centerY + Math.sin(angle) * (radius - 45) + 5;
                ctx.fillText(i.toString(), tx - (i.toString().length * 4), ty);
            }

            // 🔹 Graduations mineures (ex: tous les 10 km/h)
            ctx.strokeStyle = "lightgray";
            ctx.lineWidth = 1;

            for (var j = 10; j < root.maxSpeedGauge; j += 20) {
                var angleMinor = Math.PI * (0.75 + (j / root.maxSpeedGauge) * 1.5);
                var mx1 = centerX + Math.cos(angleMinor) * (radius - 10);
                var my1 = centerY + Math.sin(angleMinor) * (radius - 10);
                var mx2 = centerX + Math.cos(angleMinor) * (radius - 20);
                var my2 = centerY + Math.sin(angleMinor) * (radius - 20);

                ctx.beginPath();
                ctx.moveTo(mx1, my1);
                ctx.lineTo(mx2, my2);
                ctx.stroke();
            }

            // Aiguille
            var needleAngle = Math.PI * (0.75 + (root.speed / root.maxSpeedGauge) * 1.5);
            var needleX = centerX + Math.cos(needleAngle) * (radius - 60);
            var needleY = centerY + Math.sin(needleAngle) * (radius - 60);

            ctx.beginPath();
            ctx.moveTo(centerX, centerY);
            ctx.lineTo(needleX, needleY);
            ctx.strokeStyle = "red";
            ctx.lineWidth = 4;
            ctx.stroke();

            // Centre aiguille
            ctx.beginPath();
            ctx.arc(centerX, centerY, 8, 0, 2 * Math.PI);
            ctx.fillStyle = "white";
            ctx.fill();
        }

        Connections {
            target: root
            onSpeedChanged: dial.requestPaint()
            onCurrentSpeedLimitChanged: dial.requestPaint()
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70
        text: root.limiterEnabled ? "Limiteur actif (" + Math.round(root.currentSpeedLimit) + " km/h)" : "Limiteur désactivé"
        color: root.limiterEnabled ? "orange" : "gray"
        font.pixelSize: 18
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        text: Math.round(root.speed) + " km/h"
        color: (root.speed > root.currentSpeedLimit && root.limiterEnabled) ? "red" : "white"
        font.pixelSize: 32
        font.bold: true
    }

    Behavior on speed {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
    }

    Image {
        id: svgLogo
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: 350
        height: 350
        fillMode: Image.PreserveAspectFit

        // Par défaut, aucune image
        source: ""

        Connections {
            target: root
            onCurrentSpeedLimitChanged: {
                var validSpeeds = [20, 30, 40, 50, 60, 80, 100, 120];
                if (validSpeeds.indexOf(root.currentSpeedLimit) !== -1) {
                    svgLogo.source = "qrc:/assets/signs/" + root.currentSpeedLimit + ".svg";
                } else {
                    svgLogo.source = ""; // aucune image si vitesse invalide
                }
            }
        }
    }
}
