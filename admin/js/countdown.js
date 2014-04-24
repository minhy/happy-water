
/***********************************************
* Dynamic Countdown script- © Dynamic Drive (http://www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for this script and 100s more.
***********************************************/

function cdtime(container, targetdate){
if (!document.getElementById || !document.getElementById(container)) return
this.container=document.getElementById(container)
this.currentTime=new Date()
this.targetdate=new Date(targetdate)
this.timesup=false
this.updateTime()
}

cdtime.prototype.updateTime=function(){
var thisobj=this
this.currentTime.setSeconds(this.currentTime.getSeconds()+1)
setTimeout(function(){thisobj.updateTime()}, 1000) //update time every second
}

cdtime.prototype.displaycountdown=function(baseunit, functionref){
this.baseunit=baseunit
this.formatresults=functionref
this.showresults()
}

cdtime.prototype.showresults=function(){
var thisobj=this


var timediff=(this.targetdate-this.currentTime)/1000 //difference btw target date and current date, in seconds
if (timediff<0){ //if time is up
this.timesup=true
this.container.innerHTML=this.formatresults()
return
}
var oneMinute=60 //minute unit in seconds
var oneHour=60*60 //hour unit in seconds
var oneDay=60*60*24 //day unit in seconds
var dayfield=Math.floor(timediff/oneDay)
var hourfield=Math.floor((timediff-dayfield*oneDay)/oneHour)
var minutefield=Math.floor((timediff-dayfield*oneDay-hourfield*oneHour)/oneMinute)
var secondfield=Math.floor((timediff-dayfield*oneDay-hourfield*oneHour-minutefield*oneMinute))
if (this.baseunit=="hours"){ //if base unit is hours, set "hourfield" to be topmost level
hourfield=dayfield*24+hourfield
dayfield="n/a"
}
else if (this.baseunit=="minutes"){ //if base unit is minutes, set "minutefield" to be topmost level
minutefield=dayfield*24*60+hourfield*60+minutefield
dayfield=hourfield="n/a"
}
else if (this.baseunit=="seconds"){ //if base unit is seconds, set "secondfield" to be topmost level
var secondfield=timediff
dayfield=hourfield=minutefield="n/a"
}
this.container.innerHTML=this.formatresults(dayfield, hourfield, minutefield, secondfield)
setTimeout(function(){thisobj.showresults()}, 1000) //update results every second
}

/////CUSTOM FORMAT OUTPUT FUNCTIONS BELOW//////////////////////////////

//Create your own custom format function to pass into cdtime.displaycountdown()
//Use arguments[0] to access "Days" left
//Use arguments[1] to access "Hours" left
//Use arguments[2] to access "Minutes" left
//Use arguments[3] to access "Seconds" left

//The values of these arguments may change depending on the "baseunit" parameter of cdtime.displaycountdown()
//For example, if "baseunit" is set to "hours", arguments[0] becomes meaningless and contains "n/a"
//For example, if "baseunit" is set to "minutes", arguments[0] and arguments[1] become meaningless etc


function displayCountDown(){
    if (this.timesup == false) { //if target date/time not yet met
        var displaystring = "";
        //var displaystring = "Chỉ còn " + (arguments[0] > 0 ? arguments[0] + " ngày " : "") + arguments[1] + ":" + arguments[2] + "':" + arguments[3] + "''";
        if (arguments[0] > 0)
        {
            displaystring += "<span class=\"itime\"><strong>" + arguments[0] + "</strong> NGÀY</span><span class=\"dots\">:</span>"
            displaystring += "<span class=\"itime\"><strong>" + arguments[1] + "</strong> GIỜ</span>"
        }
        else if (arguments[1] > 0)
        {
            displaystring += "<span class=\"itime\"><strong>" + arguments[1] + "</strong> GIỜ</span><span class=\"dots\">:</span>"
            displaystring += "<span class=\"itime\"><strong>" + arguments[2] + "</strong> PHÚT</span>"
        }
        else if (arguments[2] > 0) {
            displaystring += "<span class=\"itime\"><strong>" + arguments[2] + "</strong> PHÚT</span><span class=\"dots\">:</span>"
            displaystring += "<span class=\"itime\"><strong>" + arguments[3] + "</strong> GIÂY</span>"
        }
        
}
else{ //else if target date/time met
    //location.reload();
}
return displaystring
}

function displayCountDown2() {
    if (this.timesup == false) { //if target date/time not yet met
        var displaystring = "Chỉ còn " + (arguments[0] > 0 ? arguments[0] + " ngày " : "") + arguments[1] + ":" + arguments[2] + "':" + arguments[3] + "''";

    }
    return displaystring
}
function displayCountDownMidAutumn() {
    debugger;
    if (this.timesup == false) {
        var displaystring = (arguments[2] < 10 ? "0" + arguments[2] : arguments[2]) + ":" + (arguments[3] < 10 ? "0" + arguments[3] : arguments[3]);
        return displaystring
    }
    else {
        CreateCookie("MidAutumn", "0", 30);
        location.reload();
    }
    return "";
}