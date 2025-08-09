#include "speedlimitreader.h"
#include <QDebug>
#include <QDir>
#include <QCoreApplication>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

SpeedLimitReader::SpeedLimitReader(QObject *parent)
    : QObject(parent), m_speedLimit(240)
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

    // Remonter d'un niveau pour atteindre le répertoire parent (PROJET ALTEN)
    // Cela suppose que l'exécutable est dans 'build' et le fichier JSON dans 'PROJET ALTEN'
    if (!appDir.cdUp()) {
        qWarning() << "Impossible de remonter au répertoire parent.";
        return;
    }

    QString filePath = appDir.absoluteFilePath("vitesse_limite.json");
    QFile file(filePath);
    
    if (!file.exists()) {
        // qWarning() << "Fichier vitesse_limite.json non trouvé à:" << filePath; // Décommenter pour débogage
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