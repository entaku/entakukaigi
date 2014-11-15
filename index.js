jThree( function( j3 ) {

	$( "#loading" ).remove();

	j3.Trackball();
	j3.Stats();
	var degree = 0;
	var scene = j3("scene");
	var x = 0;
	var y= 0;
	var z = 0;
	var r = 10;
	for(degree = 0; degree < 360; degree+=30){
	    var obj_degree = -degree;
	    console.log(obj_degree);
	    obj_degree = obj_degree * (Math.PI / 180)
    	x = Math.cos(degree * (Math.PI / 180)) * r;
    	z = Math.sin(degree * (Math.PI / 180)) * r;
    	var rad = degree * (Math.PI / 180);
    	if(degree === 0){
    	    console.log(j3("#camera"));
    	    j3("#camera").css("position",x+' '+y+' '+z);
    	    console.log(j3("camera").css("position"));
    	}
	    scene.append('<mesh id="" class="face" geo="#plain_geo" mtl="#video_mtl" style="position: '+x+' '+y+' '+z+'; rotateY: '+obj_degree+'; scaleX: 0.01;"></mesh>');
	}
	
    j3(".face").on("click",function(){

    });


j3("body").on("keyup",function(e){
    var lookAt = j3("#camera").css("lookat");
    console.log("keyup");
    		switch(e.which){
			case 39: // Key[→]
			j3('#camera').css("lookAt",lookAt[0]+0.5+" "+lookAt[1]+" "+lookAt[2]);
			break;

			case 37: // Key[←]
			$('#container img').animate({left: '-=10px'},100);
			break;

			case 38: // Key[↑]
			$('#container img').animate({top: '-=10px'},100);
			break;

			case 40: // Key[↓]
			$('#container img').animate({top: '+=10px'},100);
			break;
		}
});
    
    


    navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
window.URL = window.URL || window.webkitURL;

window.AudioContext = window.AudioContext || window.webkitAudioContext || window.mozAudioContext || window.msAudioContext;


   var success = function(localMediaStream){
        console.log("success");
        console.log(localMediaStream);
        var audioContext = new AudioContext();
        var mediastreamsource = audioContext.createMediaStreamSource(localMediaStream);
        var analyser = audioContext.createAnalyser();
        var frequencyData = new Uint8Array(analyser.frequencyBinCount);
        var timeDomainData = new Uint8Array(analyser.frequencyBinCount);
        mediastreamsource.connect(analyser);
        
        var count = 0;
        var analyzeVoice = function(){
        	analyser.getByteFrequencyData(frequencyData);        
        	var sum = 0;
        	for(var i = 0; i < frequencyData.length; i++){
        	    sum +=frequencyData[i]
        	}
        	var average = sum / frequencyData.length;
        // 	if(count == 2){
        // 	    average = average / 2;
        //      	j3(".face").animate({scale: average+" "+average+" "+average}, 20);
        //     	count = 0;
        // 	}
            count++;
            window.requestAnimationFrame(analyzeVoice);
        }
        var importHTML = jThree( "import" ).contents();
        var myVideo = importHTML.find("#myVideo")[0];
        myVideo.src = window.URL.createObjectURL(localMediaStream);
        analyzeVoice();

   };
   var error = function(){
            console.log("error");
   };

    navigator.getUserMedia({audio:true, video:true},
           success,
           error
    );
    
    

},
function() {
	alert( "このブラウザはWebGLに対応していません。" );
} );
