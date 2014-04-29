function checkPrev(){
	var search= window.location.search;
	var result= search.substr(6,1);
    if(result<=1)
    {
    	return false;
    }           
    else{
    	return true;
    }
     
};

function checkNext(totalPage){
	var search= window.location.search;
	var result= search.substr(6,1);
    if(result>=totalPage)
    {
    	return false;
    }           
    else{
    	return true;
    }
     
};