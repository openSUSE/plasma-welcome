/*
 *  SPDX-FileCopyrightText: 2023 Oliver Beard <olib141@outlook.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import org.kde.kirigami 2.15 as Kirigami

import org.kde.plasma.welcome 1.0

GenericPage {
    id: root

    property bool installerAvailable: Config.liveInstaller.length !== 0

    heading: i18nc("@title:window %1 is the name of the user's distro", "Welcome to %1!", Controller.distroName())
    description: installerAvailable
                 ? xi18nc("@info:usagetip %1 is the name of the user's distro",
                          "Pressing the icon below will begin installing %1. Alternatively, you can close the window to explore the live environment or continue here to find out about KDE Plasma.", Controller.distroName())
                 : xi18nc("@info:usagetip %1 is the name of the user's distro",
                          "You can close the window to explore the live environment or continue here to find out about KDE Plasma.")

    topContent: [
        Kirigami.UrlButton {
            id: link
            Layout.topMargin: Kirigami.Units.largeSpacing
            text: i18nc("@action:button", "Visit home page")
            url: Controller.distroUrl()
            visible: url.length !== 0
        }
    ]

    Kirigami.Icon {
        anchors.centerIn: parent
        width: Math.min(parent.height, Kirigami.Units.gridUnit * 16)
        height: width

        layer.enabled: installerAvailable
        layer.effect: GaussianBlur {
            radius: 10
            samples: 16
            cached: true
        }
        opacity: installerAvailable ? 0.1 : 1

        source: Controller.distroIcon()
        fallback: ""
    }

    ApplicationIcon {
        anchors.centerIn: parent

        application: Config.liveInstaller
        size: Kirigami.Units.gridUnit * 10
        visible: root.installerAvailable
    }
}
