#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "speedlimitreader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Créer l'instance de SpeedLimitReader
    SpeedLimitReader speedLimitReader;
    
    // Exposer l'objet au contexte QML
    engine.rootContext()->setContextProperty("speedLimitReader", &speedLimitReader);

    // Charger Main.qml depuis le système de fichiers (pour le débogage)
    // Assurez-vous que Main.qml est dans le même répertoire que l'exécutable ou dans un sous-répertoire 'qml'
    engine.load(QUrl("qrc:/qml/Main.qml"));

    // Si le chargement échoue, sortir
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
