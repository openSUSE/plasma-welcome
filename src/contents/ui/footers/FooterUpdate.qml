/*
 *  SPDX-FileCopyrightText: 2023 Oliver Beard <olib141@outlook.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import org.kde.plasma.welcome

RowLayout {
    spacing: Kirigami.Units.smallSpacing

    QQC2.Button {
        id: okButton
        Layout.alignment: Qt.AlignRight

        action: Kirigami.Action {
            text: i18nc("@action:button", "&OK")
            icon.name: "dialog-ok-apply-symbolic"
            shortcut: "Right"

            onTriggered: Qt.quit()
        }
    }
}
