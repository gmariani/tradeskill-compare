// Variables //
var profileListener:Object = new Object();
var skillListener:Object = new Object();
var sortListener:Object = new Object();
var skills_array:Array = new Array();
var remain_obj:Object = new Object();
var remain_array:Array = new Array();
var libraryXML:XML = new XML();
var detailNode:XMLNode = new XMLNode();
var showAll:Boolean = false;
var format = new TextField.StyleSheet();

//TODO: Have a php file scan the profiles folder and create a directory listing
//TODO: See if the TSE Addon generates one file for both professions
//TODO: Have flash read in and parse the .lua files itself, and populate the array that way.



////////////////////
// Load XML Files //
////////////////////
function loadXML(file:String, callBack:Function) {
	var my_xml:XML = new XML();
	my_xml.ignoreWhite = true;
	my_xml.onLoad = function(success:Boolean) {
		if(success) {
			//trace("File loaded successfully");
			callBack(this);
		} else {
			trace("File failed to load");
		}
	};
	my_xml.load(file);
}

///////////////////
// Upload Button //
///////////////////
// have a popup with a file browser to upload files with
upload_btn.onRelease = function() {
	//
}

///////////////////
// Delete Button //
///////////////////
delete_btn.onRelease = function() {
	//
}

////////////////////////
// View Toggle Button //
////////////////////////
viewToggle_btn.onRelease = function() {
	if(this.label == "Show All") {
		this.label = "Show Remaining";
		showAll = true;
		populateSkills();
	} else {
		this.label = "Show All";
		showAll = false;
		populateSkills();
	}
}

/////////////////////
// Populate Skills //
/////////////////////
function populateSkills() {
	remain_list.removeAll();
	remain_list.stylecache.color = 0x646464;
	remain_list.setStyle("fontWeight", "bold");
			
	var color_array = new Array();
	color_array["common"] = 0xFFFFFF;
	color_array["uncommon"] = 0x00FF00;
	color_array["rare"] = 0x0070DD;
	color_array["epic"] = 0xA335EE;
	color_array["legendary"] = 0xFF6633;
	color_array["artifact"] = 0xFF6633;
	
	if(showAll) {		
		for(var i in skills_array) {
			//this.comp.selectionColor = 0xCEF3FF;
			remain_list.addItem({label:skills_array[i], data:skills_array[i]});
		}
		remain_list.sortItemsBy("label", "ASC");
	} else {		
		for(var i in remain_obj) {
			switch(sortBy_cb.selectedItem.data) {
				case "name" :
					remain_list.addItem({label:remain_array[i][0], data:remain_array[i][0]});
					break;
				case "slot" :
					remain_list.addItem({label:remain_array[i][0], data:remain_array[i][2]});
					break;
				case "skill" :
					remain_list.addItem({label:remain_array[i][0], data:remain_array[i][1]});
					break;				
			}
			var rowNum = remain_list.length - 1;
			
			
			
			
			//remain_list.setPropertiesAt(rowNum, {backgroundColor:color_array[remain_array[i][3]]});
			
			
			
			//trace(remain_list.content_mc["listRow" + rowNum].cell.text);
			//remain_list.content_mc["listRow" + rowNum].stylecache.color = 0xA335EE;
			//remain_list.content_mc["listRow" + rowNum].normalColor = 0xA335EE;
			//remain_list.content_mc["listRow" + rowNum].cell.textColor = 0xA335EE;

		}
		remain_list.sortItemsBy("data", "ASC");
	}	
	//trace(remain_list.content_mc.listRow17.cell.text);
	//remain_list.content_mc.listRow17.cell.textColor = 0xA335EE;
}

///////////////////////
// Populate Profiles //
///////////////////////
populateProfiles = function(fileXML:XML) {
	user_tree.dataProvider = fileXML.firstChild;
}

/////////////////
// Load Skills //
/////////////////
loadSkills = function(fileXML:XML) {
	//remain_list.dataProvider = fileXML.firstChild;
	skills_array = new Array();
	var profession = fileXML.firstChild.attributes.profession;
	for (var aNode:XMLNode = fileXML.firstChild.firstChild; aNode != null; aNode = aNode.nextSibling) {
		skills_array.push(aNode.attributes.label);
	}
	loadXML("library/" + profession + ".xml", loadLibrary);
}

//////////////////
// Load Library //
//////////////////
loadLibrary = function(fileXML:XML) {
	libraryXML = fileXML;
	remain_array = new Array();
	remain_obj = new Object();
	uniqueID = 0;
	for (var aNode:XMLNode = fileXML.firstChild.firstChild; aNode != null; aNode = aNode.nextSibling) {
		remain_array[aNode.attributes.label] = new Array(aNode.attributes.label, aNode.attributes.skill, aNode.attributes.slot, aNode.attributes.quality);
		remain_obj[aNode.attributes.label] = aNode.attributes.label;
		uniqueID++;
	}
		
	for(var i in skills_array) {
		for(var j in remain_obj) {
			if(skills_array[i] == j) {
				delete remain_obj[j];
			}
		}
	}
	
	populateSkills();
}

//////////////////////////
// On Profile Selection //
//////////////////////////
sortListener.change = function(evt:Object) {
	populateSkills();
};

//////////////////////////
// On Profile Selection //
//////////////////////////
profileListener.change = function(evt:Object) {
	// Upone profile selection, enable buttons
	viewToggle_btn.enabled = true;
	// Load selected profile
	loadXML("profiles/" + evt.target.selectedNode.attributes.url, loadSkills);
};

////////////////////////
// On Skill Selection //
////////////////////////
skillListener.change = function(evt:Object) {
	// Scan XML for item, display details
	for (var aNode:XMLNode = libraryXML.firstChild.firstChild; aNode != null; aNode = aNode.nextSibling) {
		if(aNode.attributes.label == evt.target.selectedItem.label) {
			detailNode = aNode;
		}
	}
	
	var displayText:String;
	displayText = "<p class='" + detailNode.attributes.quality + "text'><a href='http://www.thottbot.com/?s=" + detailNode.attributes.label + "'>" + detailNode.attributes.label + "</a></p>";
	displayText += "<span class='titletext'>Skill</span>: <span class='normtext'>" + detailNode.attributes.skill + "</span><br>";
	displayText += "<span class='titletext'>Slot</span>: <span class='normtext'>" + detailNode.attributes.slot + "</span><br>";
	displayText += "<span class='titletext'>Source</span>: <span class='normtext'>" + detailNode.attributes.source + "</span><br>";
	if(detailNode.childNodes[0].firstChild.nodeValue == undefined) {
		descrip = "None";
	} else {
		descrip = detailNode.childNodes[0].firstChild.nodeValue;
	}
	displayText += "<span class='titletext'>Description</span>: <span class='normtext'>" + descrip + "</span><br>";
	displayText += "<span class='titletext'>Materials</span>:<br><span class='normtext'>";
	for (var aNode:XMLNode = detailNode.firstChild.nextSibling.firstChild; aNode != null; aNode = aNode.nextSibling) {
		displayText += "     " + aNode.attributes.label + " x " + aNode.attributes.ammount + "<br>";
	}
	displayText += "</span>";
	details_txt.stylesheet = format;
	details_txt.wordWrap = true;
	details_txt.multiline = true;
	details_txt.html = true;
	//details_txt.embedFonts = true;
	details_txt.styleSheet = format;
    details_txt.htmlText = displayText;	
}

//////////
// Init // 
//////////
function init() {
	// Disabled til a profile is selected
	delete_btn.enabled = false;
	viewToggle_btn.enabled = false;
	
	// Load up directory into tree.
	loadXML("profiles/toc.xml", populateProfiles);

	// Add profile listener
	user_tree.addEventListener("change", profileListener);
	
	// Add skill listener
	remain_list.addEventListener("change", skillListener);	
	
	// Add skill listener
	sortBy_cb.addEventListener("change", sortListener);	
	
	format.load("style.css");
	format.onLoad = function(success) {
		if (success) {
			details_txt.styleSheet = format;
		}
	};
}

init();