function checkPrev(){
	var search= window.location.search;
	var result= search.substr(search.lastIndexOf("=")+1,1);
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
	var result= search.substr(search.lastIndexOf("=")+1,1);
    if(result>=totalPage)
    {
    	return false;
    }           
    else{
    	return true;
    }
     
};