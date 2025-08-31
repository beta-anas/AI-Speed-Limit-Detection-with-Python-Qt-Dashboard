#include "speedlimitreader.h"
#include <QDebug>
#include <QDir>
#include <QCoreApplication>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

SpeedLimitReader::SpeedLimitReader(QObject *parent)
    : QObject(parent), m_speedLimit(240)  // ou 0 si tu préfères
{
    // Timer pour lire le fichier toutes les 500ms
    m_timer.setInterval(500);
    connect(&m_timer, &QTimer::timeout, this, &SpeedLimitReader::readSpeedLimitFile);
    m_timer.start();
}

void SpeedLimitReader::readSpeedLimitFile()
{
    // Obtenir le chemin de l'exécutable
    QString appDirPath = QCoreApplication::applicationDirPath();
    QDir appDir(appDirPath);

    if (!appDir.cdUp()) {
        qWarning() << "Impossible de remonter au répertoire parent.";
        return;
    }

    QString filePath = appDir.absoluteFilePath("vitesse_limite.json");
    QFile file(filePath);
    
    if (!file.exists()) {
        return;
    }
    
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Impossible d'ouvrir le fichier:" << filePath;
        return;
    }
    
    QByteArray data = file.readAll();
    file.close();
    
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(data, &error);
    
    if (error.error != QJsonParseError::NoError) {
        qWarning() << "Erreur de parsing JSON:" << error.errorString();
        return;
    }
    
    QJsonObject obj = doc.object();
    if (obj.contains("vitesse_limite")) {
        int newSpeedLimit = obj["vitesse_limite"].toInt();
        if (newSpeedLimit != m_speedLimit && newSpeedLimit > 0) {
            m_speedLimit = newSpeedLimit;
            qDebug() << "Nouvelle limite de vitesse détectée:" << m_speedLimit << "km/h";
            emit speedLimitChanged();
        }
    }
}

QString SpeedLimitReader::speedLimitImage() const
{
    if (m_speedLimit == 20) return "qrc:/assets/signs/20.svg";
    if (m_speedLimit == 30) return "qrc:/assets/signs/30.svg";
    if (m_speedLimit == 40) return "qrc:/assets/signs/40.svg";
    if (m_speedLimit == 50) return "qrc:/assets/signs/50.svg";
    if (m_speedLimit == 60) return "qrc:/assets/signs/60.svg";
    if (m_speedLimit == 80) return "qrc:/assets/signs/80.svg";
    if (m_speedLimit == 100) return "qrc:/assets/signs/100.svg";
    if (m_speedLimit == 120) return "qrc:/assets/signs/120.svg";
    return "";
}
