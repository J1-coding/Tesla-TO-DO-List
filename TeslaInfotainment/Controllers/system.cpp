#include "system.h"
#include <QDateTime>
#include <QDebug>
#include <QSqlError>
#include <QTimer>

#include <QtSql/QSqlQuery>

System::System(QObject *parent)
    : QObject{parent}
    , m_carLocked( true )
    , m_outdoorTemp( 64 )
    , m_userName("Jaewon Kim")
    , m_currentTime("12:34am")
{
    m_currentTimeTimer = new QTimer( this );
    m_currentTimeTimer->setInterval( 500 );
    m_currentTimeTimer->setSingleShot( true );
    connect(m_currentTimeTimer, &QTimer::timeout, this, &System::currentTimeTimerTimeout);

    currentTimeTimerTimeout();

    initializeDatabase();


}

bool System::carLocked() const
{
    return m_carLocked;
}

void System::setCarLocked(bool carLocked)
{
    if (m_carLocked == carLocked)
        return;

    m_carLocked = carLocked;
    emit carLockedChanged (m_carLocked);
}

int System::outdoorTemp() const
{
    return m_outdoorTemp;
}

void System::setOutdoorTemp(int outdoorTemp)
{
    if(m_outdoorTemp == outdoorTemp)
        return;

    m_outdoorTemp = outdoorTemp;
    emit outdoorTempChanged(m_outdoorTemp);
}

QString System::userName() const
{
    return m_userName;
}

QString System::currentTime() const
{
    return m_currentTime;
}

void System::setUserName(QString userName)
{
    if (m_userName == userName)
        return;
    m_userName = userName;
    emit userNameChanged(m_userName);
}

void System::setCurrentTime(QString currentTime)
{
    if (m_currentTime == currentTime)
        return;

    m_currentTime = currentTime;
    emit currentTimeChanged(m_currentTime);
}

void System::currentTimeTimerTimeout()
{
    QDateTime dateTime;
    QString currentTime = dateTime.currentDateTime().toString("hh:mm ap");

    setCurrentTime(currentTime);

    m_currentTimeTimer->start();
}


void System::initializeDatabase() {
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("todo.db");
    if (!db.open()) {
        qDebug() << "Cannot open database"; // Correct usage
        return;
    }
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT)");
}


QVariantList System::loadTasks() {
    QVariantList tasks;
    QSqlQuery query("SELECT id, task FROM tasks ORDER BY id DESC");
    while (query.next()) {
        int id = query.value(0).toInt();
        QString task = query.value(1).toString();
        tasks << QVariantMap{{"id", id}, {"task", task}};
    }
    return tasks;
}

int System::addTask(const QString &task) {
    if (!task.trimmed().isEmpty()) {
        QSqlQuery query;
        query.prepare("INSERT INTO tasks (task) VALUES (:task)");
        query.bindValue(":task", task);
        if (query.exec()) {
            return query.lastInsertId().toInt();
        } else {
            qDebug() << "Error adding task:" << query.lastError().text();
            return -1;
        }
    }
    return -1;
}


bool System::deleteTask(int id) {
    QSqlQuery query;
    query.prepare("DELETE FROM tasks WHERE id = :id");
    query.bindValue(":id", id);
    if (query.exec()) {
        return true;
    } else {
        qDebug() << "Error deleting task:" << query.lastError().text();
        return false;
    }
}

