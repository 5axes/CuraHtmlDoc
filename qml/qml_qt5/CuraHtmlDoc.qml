// Copyright (c) 2023 5@xes
// CuraHtmlDoc is released under the terms of the AGPLv3 or higher.
// proterties values
//   "FileFolder" : Path to file
//   "AutoSave"	 : AutoSave

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.0

import UM 1.1 as UM
import Cura 1.0 as Cura

Item
{
	id: base

	function pathToUrl(path)
	{
		// Convert the path to a usable url
		var url = "file:///"
		url = url + path
		// Not sure of this last encode
		// url = encodeURIComponent(url)
		
		// Return the resulting url
		return url
	}
	
	function urlToStringPath(url)
	{
		// Convert the url to a usable string path
		var path = url.toString()
		path = path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/, "")
		path = decodeURIComponent(path)

		// On Linux, a forward slash needs to be prepended to the resulting path
		// I'm guessing this is needed on Mac OS, as well, but can't test it
		if (Qt.platform.os === "linux" || Qt.platform.os === "osx" || Qt.platform.os === "unix") path = "/" + path
		
		// Return the resulting path
		return path
	}
			
	property variant catalog: UM.I18nCatalog { name: "curahtmldoc" }
	
	
	// TODO: these widths & heights are a bit too dependant on other objects in the qml...
    width: childrenRect.width
    height: childrenRect.height

	Column {
		id: runOptions
		width: childrenRect.width
		height: childrenRect.height

		Button {
			text: catalog.i18nc("@label","Save As")
			onClicked: fileDialogSave.open()
		}

		FileDialog
		{
			id: fileDialogSave
			// fileUrl QT5 !
			// selectedFile QT6 !
			onAccepted: UM.ActiveTool.setProperty("FileFolder", urlToStringPath(fileUrl))
			nameFilters: "*.html"
			selectExisting : false
			folder:pathToUrl(UM.ActiveTool.properties.getValue("FileFolder"))		
		}
		
		CheckBox {
			text: catalog.i18nc("@option:check","Auto save")
			checked: UM.ActiveTool.properties.getValue("AutoSave")
			onClicked: {
				UM.ActiveTool.setProperty("AutoSave", checked)
			}
		}		
	}
}
