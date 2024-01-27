////////////////////
// Load XML Files //
////////////////////
function loadTXT(file:String, callBack:Function) {
	var my_lv:LoadVars = new LoadVars();
	my_lv.onLoad = function(success:Boolean) {
		if (success) {
			callBack(this);
		} else {
			trace("File failed to load");
		}
	};
	my_lv.load(file);
}

//////////
// Init // 
//////////
function init() {
	
	// Load up directory into tree.
	loadTXT("tse.lua", populateProfiles);
}

populateProfiles = function(fileTXT) {
	var luaFile = unescape(fileTXT);
	idx = luaFile.indexOf('["');
	trace(idx);
	
}

init();