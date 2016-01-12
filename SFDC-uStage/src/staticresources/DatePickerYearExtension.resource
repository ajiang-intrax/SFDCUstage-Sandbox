var linkBox = document.evaluate(
	'//h2[contains(text(),"DatePickerYearExtensionLink")]/../..', 
	document, 
	null, 
	XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, 
	null ).snapshotItem(0);
linkBox.style.display='none';
function DatePickerYearExtension() {
	var calYearPicker = document.getElementById('calYearPicker');
	var startYear = 1940;
	var endYear = 2020;
	if (calYearPicker !== null && startYear < endYear) {
		var optionsString = '';
		for (i = startYear; i < endYear + 1; i++) {
			optionsString += "<option value=\"" + i + "\">" + i + "</option>";
		}
		calYearPicker.innerHTML=optionsString;
	}
}
if (window.addEventListener) // W3C standard
{
  window.addEventListener('load', DatePickerYearExtension, false); // NB **not** 'onload'
} 
else if (window.attachEvent) // Microsoft
{
  window.attachEvent('onload', DatePickerYearExtension);
}
