// Gauge.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Canvas 1.15

Item {
    id: speedGauge
    width: 400
    height: 400

    // --- Propriétés publiques ---
    property real speed: 0
    property real maxSpeed: 260
    property real limitSpeed: -1 // si -1, on n’affiche pas le marqueur
    property color needleColor: "red"
    property color tickColor: "white"
    property color backgroundColor: "#141212"
    property color limitColor: "yellow"

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            const cx = width / 2
            const cy = height / 2
            const radius = Math.min(width, height) / 2 * 0.9

            // Fond
            ctx.beginPath()
            ctx.arc(cx, cy, radius, 0, 2 * Math.PI)
            let grad = ctx.createRadialGradient(cx, cy, 0, cx, cy, radius)
            grad.addColorStop(0, "#333")
            grad.addColorStop(1, speedGauge.backgroundColor)
            ctx.fillStyle = grad
            ctx.fill()

            // Graduations principales
            ctx.lineWidth = 2
            ctx.strokeStyle = speedGauge.tickColor
            ctx.fillStyle = speedGauge.tickColor
            ctx.font = "bold 14px sans-serif"

            for (let i = 0; i <= maxSpeed; i += 20) {
                const angle = Math.PI * (1 + i / maxSpeed)
                const x1 = cx + Math.cos(angle) * (radius - 10)
                const y1 = cy + Math.sin(angle) * (radius - 10)
                const x2 = cx + Math.cos(angle) * (radius - 30)
                const y2 = cy + Math.sin(angle) * (radius - 30)
                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.stroke()

                const tx = cx + Math.cos(angle) * (radius - 45)
                const ty = cy + Math.sin(angle) * (radius - 45) + 5
                ctx.fillText(i.toString(), tx - 10, ty)
            }

            // Graduations secondaires
            ctx.lineWidth = 1
            ctx.strokeStyle = "gray"
            for (let i = 0; i <= maxSpeed; i += 5) {
                if (i % 20 !== 0) {
                    const angle = Math.PI * (1 + i / maxSpeed)
                    const x1 = cx + Math.cos(angle) * (radius - 10)
                    const y1 = cy + Math.sin(angle) * (radius - 10)
                    const x2 = cx + Math.cos(angle) * (radius - 20)
                    const y2 = cy + Math.sin(angle) * (radius - 20)
                    ctx.beginPath()
                    ctx.moveTo(x1, y1)
                    ctx.lineTo(x2, y2)
                    ctx.stroke()
                }
            }

            // Marqueur de limite de vitesse
            if (limitSpeed > 0 && limitSpeed <= maxSpeed) {
                const angleLimit = Math.PI * (1 + limitSpeed / maxSpeed)
                const lx = cx + Math.cos(angleLimit) * (radius - 20)
                const ly = cy + Math.sin(angleLimit) * (radius - 20)
                ctx.beginPath()
                ctx.moveTo(cx, cy)
                ctx.lineTo(lx, ly)
                ctx.strokeStyle = speedGauge.limitColor
                ctx.lineWidth = 2
                ctx.stroke()
            }

            // Aiguille de vitesse
            const angle = Math.PI * (1 + speed / maxSpeed)
            const nx = cx + Math.cos(angle) * (radius - 60)
            const ny = cy + Math.sin(angle) * (radius - 60)

            ctx.beginPath()
            ctx.moveTo(cx, cy)
            ctx.lineTo(nx, ny)
            ctx.strokeStyle = speedGauge.needleColor
            ctx.lineWidth = 4
            ctx.stroke()

            // Centre de l’aiguille
            ctx.beginPath()
            ctx.arc(cx, cy, 8, 0, 2 * Math.PI)
            ctx.fillStyle = "white"
            ctx.fill()
        }

        // Redessiner à chaque changement de vitesse
        Component.onCompleted: canvas.requestPaint()
    }

    // Mise à jour automatique de l’affichage à chaque changement
    onSpeedChanged: canvas.requestPaint()
    onLimitSpeedChanged: canvas.requestPaint()
    onMaxSpeedChanged: canvas.requestPaint()

    // Affichage numérique
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        font.pixelSize: 28
        font.bold: true
        color: "white"
        text: Math.round(speed) + " km/h"
    }
}
