#ifndef SPEEDLIMITREADER_H
#define SPEEDLIMITREADER_H

#include <QObject>
#include <QTimer>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

class SpeedLimitReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int speedLimit READ speedLimit NOTIFY speedLimitChanged)

public:
    explicit SpeedLimitReader(QObject *parent = nullptr);

    int speedLimit() const { return m_speedLimit; }

    Q_PROPERTY(QString speedLimitImage READ speedLimitImage NOTIFY speedLimitChanged)

    QString speedLimitImage() const;    

signals:
    void speedLimitChanged();

private slots:
    void readSpeedLimitFile();

private:
    int m_speedLimit = 0;
    QTimer m_timer;
};

#endif // SPEEDLIMITREADER_H