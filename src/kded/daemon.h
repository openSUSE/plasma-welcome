/*
 *  SPDX-FileCopyrightText: 2023 Oliver Beard <olib141@outlook.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include <KConfigGroup>
#include <QVersionNumber>
#include <kdedmodule.h>

class PlasmaWelcomeDaemon : public KDEDModule
{
    Q_OBJECT

public:
    PlasmaWelcomeDaemon(QObject *parent, const QList<QVariant> &);

private:
    bool isSignificantUpgrade();
    void launch(const QStringList &args);

    KConfigGroup m_config;
    const QVersionNumber m_currentVersion;
    const QVersionNumber m_previousVersion;
};