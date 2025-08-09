import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: gearMotorGauge
    width: 400
    height: 400

    property real rpm: 0          // RPM actuel
    property real maxRpm: 8000    // RPM maximum
    property real redline: 6500   // Zone rouge

    Canvas {
        id: rpmCanvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            const centerX = width / 2
            const centerY = height / 2
            const radius = Math.min(width, height) / 2 * 0.85

            // Fond du cadran
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
            let grad = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, radius)
            grad.addColorStop(0, "#1a1a1a")
            grad.addColorStop(1, "#000")
            ctx.fillStyle = grad
            ctx.fill()

            // Zone rouge (redline)
            ctx.beginPath()
            const redlineAngle = 0.75 * Math.PI + (redline/maxRpm) * 1.5 * Math.PI
            ctx.arc(centerX, centerY, radius, 0.75 * Math.PI, redlineAngle)
            ctx.lineTo(centerX, centerY)
            ctx.fillStyle = Qt.rgba(1, 0, 0, 0.3)
            ctx.fill()

            // Graduations
            ctx.lineWidth = 2
            ctx.strokeStyle = "white"
            ctx.fillStyle = "white"
            ctx.font = "bold 12px sans-serif"

            for (let i = 0; i <= maxRpm; i += 1000) {
                const angle = 0.75 * Math.PI + (i/maxRpm) * 1.5 * Math.PI
                const x1 = centerX + Math.cos(angle) * (radius - 10)
                const y1 = centerY + Math.sin(angle) * (radius - 10)
                const x2 = centerX + Math.cos(angle) * (radius - 30)
                const y2 = centerY + Math.sin(angle) * (radius - 30)
                
                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.stroke()

                // Affichage des valeurs
                const tx = centerX + Math.cos(angle) * (radius - 50)
                const ty = centerY + Math.sin(angle) * (radius - 50) + 5
                ctx.fillText((i/1000).toString() + "k", tx - 10, ty)
            }

            // Aiguille
            const angle = 0.75 * Math.PI + (rpm/maxRpm) * 1.5 * Math.PI
            const needleX = centerX + Math.cos(angle) * (radius - 60)
            const needleY = centerY + Math.sin(angle) * (radius - 60)

            ctx.beginPath()
            ctx.moveTo(centerX, centerY)
            ctx.lineTo(needleX, needleY)
            ctx.strokeStyle = rpm > redline ? "red" : "#00ff00"
            ctx.lineWidth = 4
            ctx.stroke()

            // Centre de l'aiguille
            ctx.beginPath()
            ctx.arc(centerX, centerY, 8, 0, 2 * Math.PI)
            ctx.fillStyle = "#333"
            ctx.fill()
        }
    }

    // Affichage numérique du RPM
    Text {
        anchors.centerIn: parent
        text: Math.round(rpm) + " RPM"
        color: rpm > redline ? "red" : "white"
        font.pixelSize: 24
        font.bold: true
    }

    // Animation de l'aiguille
    Behavior on rpm {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
}