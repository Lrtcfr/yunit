/*
 * Copyright (C) 2014 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.3
import Ubuntu.Components 1.1

Item {
    id: root

    property alias dragHandleLeftMargin: coverPage.dragHandleLeftMargin
    property alias launcherOffset: coverPage.launcherOffset
    property alias currentIndex: loginList.currentIndex
    property int delayMinutes // TODO
    property alias backgroundTopMargin: coverPage.backgroundTopMargin
    property alias background: coverPage.background
    property bool locked
    property bool alphanumeric // unused
    property alias userModel: loginList.model
    property alias infographicModel: coverPage.infographicModel
    readonly property bool fullyShown: coverPage.showProgress === 1
    readonly property bool required: coverPage.required

    signal selected(int index)
    signal responded(string response)
    signal tease()
    signal emergencyCall() // UNUSED

    function showMessage(html) {
        loginList.showMessage(html);
    }

    function showPrompt(text, isSecret, isDefaultPrompt) {
        loginList.showPrompt(text, isSecret, isDefaultPrompt);
    }

    function showLastChance() {
        // TODO
    }

    function hide() {
        coverPage.hide();
    }

    function authenticated(success) {
        if (!success) {
            loginList.showError();
        }
    }

    function reset() {
        loginList.reset();
    }

    function tryToUnlock(toTheRight) {
        if (root.locked) {
            coverPage.show();
            loginList.tryToUnlock();
        } else {
            if (toTheRight) {
                coverPage.hideRight();
            } else {
                coverPage.hide();
            }
        }
    }

    QtObject {
        id: d
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: coverPage.showProgress * 0.8
    }

    CoverPage {
        id: coverPage
        objectName: "coverPage"
        height: parent.height
        width: parent.width
        draggable: !root.locked

        infographics {
            height: 0.75 * parent.height
            anchors.leftMargin: loginList.x + loginList.width
        }

        onTease: root.tease()

        onShowProgressChanged: {
            if (showProgress === 0 && !root.locked) {
                root.responded("");
            }
        }

        LoginList {
            id: loginList
            objectName: "loginList"

            anchors {
                left: parent.left
                leftMargin: Math.min(parent.width * 0.16, units.gu(20))
                verticalCenter: parent.verticalCenter
            }
            width: units.gu(29)
            height: parent.height

            locked: root.locked

            onSelected: root.selected(index)
            onResponded: root.responded(response)
        }
    }
}
