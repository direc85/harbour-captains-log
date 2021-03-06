/*
 * This file is part of harbour-captains-log.
 * Copyright (C) 2020  Gabriel Berkigt, Mirian Margiani
 *
 * harbour-captains-log is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * harbour-captains-log is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with harbour-captains-log.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
    id: page

    ConfigurationValue {
        id: useCodeProtection
        key: "/useCodeProtection"
    }

    ConfigurationValue {
        id: protectionCode
        key: "/protectionCode"
        defaultValue: "-1"
    }

    onStatusChanged: {
        if(status == PageStatus.Deactivating) {
            if (protectionSwitch.checked && protectionCode.value !== "-1") {
                // if protection is switched on AND a protection code is set - save!
                useCodeProtection.value = 1

                // if the code was just set, make sure the app knows it's unlocked
                appWindow.unlocked = true
            } else {
                // if not checked or code not set rollback all details
                useCodeProtection.value = 0
                protectionCode.value = "-1"
            }
        }
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: listView
        anchors.fill: parent

        Column {
            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader {
                title: qsTr("Settings")
            }

            SectionHeader {
                text: qsTr("Security")
            }

            TextSwitch {
                id: protectionSwitch
                text: qsTr("activate code protection")
                checked: useCodeProtection.value
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: protectionCode.value === "-1" ? qsTr("Set Code") : qsTr("Change Code")
                visible: protectionSwitch.checked
                onClicked: pageStack.push(Qt.resolvedUrl("ChangePinPage.qml"), {
                                              expectedCode: protectionCode.value === "-1" ? "" : protectionCode.value,
                                              settingsPage: page
                                          })
            }

            SectionHeader {
                text: qsTr("Export features")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Export data")
                onClicked: pageStack.push(Qt.resolvedUrl("ExportPage.qml"))
            }
        }
    }
}
