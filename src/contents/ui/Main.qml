/*
 *  SPDX-FileCopyrightText: 2021 Felipe Kinoshita <kinofhek@gmail.com>
 *  SPDX-FileCopyrightText: 2022 Nate Graham <nate@kde.org>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import org.kde.plasma.welcome

Kirigami.ApplicationWindow {
    id: root

    readonly property bool showingPlasmaUpdate: Controller.mode === Controller.Update

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 32
    width: Kirigami.Units.gridUnit * 36
    height: Kirigami.Units.gridUnit * 32

    pageStack.globalToolBar.showNavigationButtons: Kirigami.ApplicationHeaderStyle.NoNavigationButtons
    pageStack.defaultColumnWidth: width

    footer: Item {
        width: root.width
        height: footerLayout.implicitHeight + (footerLayout.anchors.margins * 2)

        visible: !root.showingPlasmaUpdate

        Kirigami.Separator {
            id: footerSeparator

            anchors.bottom: parent.top
            width: parent.width
        }

        // Not using QQC2.Toolbar so that the window is draggable
        // from the footer, both appear identical
        Kirigami.AbstractApplicationHeader {
            id: footerToolbar

            height: parent.height
            width: parent.width

            separatorVisible: false

            contentItem: RowLayout {
                id: footerLayout

                anchors.fill: parent
                anchors.margins: Kirigami.Units.smallSpacing

                spacing: Kirigami.Units.smallSpacing

                QQC2.Button {
                    Layout.alignment: Qt.AlignLeft
                    id: prevButton
                    enabled: footerToolbar.visible
                    action: Kirigami.Action {
                        text: pageStack.currentIndex === 0 && pageStack.layers.depth === 1 ? i18nc("@action:button", "&Skip") : i18nc("@action:button", "&Back")
                        icon.name: pageStack.currentIndex === 0 && pageStack.layers.depth === 1 ? "dialog-cancel" : "arrow-left"
                        shortcut: "Left"
                        enabled: prevButton.enabled
                        onTriggered: {
                            if (pageStack.layers.depth > 1) {
                                pageStack.layers.pop()
                            } else if (pageStack.currentIndex != 0) {
                                pageStack.currentIndex -= 1
                            } else {
                                Qt.quit();
                            }
                        }
                    }
                }

                QQC2.PageIndicator {
                    Layout.alignment: Qt.AlignHCenter
                    count: pageStack.depth
                    currentIndex: pageStack.currentIndex
                    interactive: true
                    onCurrentIndexChanged: { pageStack.currentIndex = currentIndex; }
                }

                QQC2.Button {
                    Layout.alignment: Qt.AlignRight
                    id: nextButton
                    enabled: footerToolbar.visible && pageStack.layers.depth === 1
                    action: Kirigami.Action {
                        text: pageStack.currentIndex === pageStack.depth - 1 ? i18nc("@action:button", "&Finish") : i18nc("@action:button", "&Next")
                        icon.name: pageStack.currentIndex === pageStack.depth - 1 ? "dialog-ok-apply" : "arrow-right"
                        shortcut: "Right"
                        enabled: nextButton.enabled
                        onTriggered: {
                            if (pageStack.currentIndex < pageStack.depth - 1) {
                                pageStack.currentIndex += 1
                            } else {
                                Qt.quit();
                            }
                        }
                    }
                }
            }
        }
    }

    function createPageObject(page) {
        let component = Qt.createComponent(page);
        if (component.status !== Component.Error) {
            return component.createObject(null);
        } else {
            console.warn("Couldn't load page '" + page + "'");
            console.warn(" " + component.errorString())
            component.destroy();
            // TODO: Instead create and return a placeholder page with error info
            return null;
        }
    }

    Component.onCompleted: {
        // Push pages dynamically
        switch (Controller.mode) {
            case Controller.Update:
                pageStack.push(createPageObject("PlasmaUpdate.qml"));
                break;

            case Controller.Live:
                pageStack.push(createPageObject("Live.qml"));
                // Fallthrough

            case Controller.Welcome:
                pageStack.push(createPageObject("Welcome.qml"));

                if (!Controller.networkAlreadyConnected()) {
                    pageStack.push(createPageObject("Network.qml"));
                }

                pageStack.push(createPageObject("SimpleByDefault.qml"));
                pageStack.push(createPageObject("PowerfulWhenNeeded.qml"));

                let discover = createPageObject("Discover.qml");
                if (discover.application.exists) {
                    pageStack.push(discover);
                } else {
                    discover.destroy();
                }

                // KCMs
                if (Controller.mode !== Controller.Live) {
                    if (Controller.userFeedbackAvailable()) {
                        pageStack.push(createPageObject("Feedback.qml"));
                    }
                }

                // Append any distro-specific pages that were found
                let distroPages = Controller.distroPages();
                for (let i in distroPages) {
                    pageStack.push(createPageObject(distroPages[i]));
                }

                pageStack.push(createPageObject("Contribute.qml"));
                pageStack.push(createPageObject("Donate.qml"));
                break;
        }

        // Start at the beginning
        pageStack.currentIndex = 0;
    }
}
