/*
 *  SPDX-FileCopyrightText: 2023 Oliver Beard <olib141@outlook.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import org.kde.plasma.networkmanagement as PlasmaNM

Item {
    readonly property alias statusNetworkStatus: networkStatus.networkStatus
    readonly property alias iconConnecting: connectionIconProvider.connecting
    readonly property alias iconConnectionIcon: connectionIconProvider.connectionIcon

    PlasmaNM.NetworkStatus {
        id: networkStatus
    }

    PlasmaNM.ConnectionIcon {
        id: connectionIconProvider
    }
}
