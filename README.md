SilentShot
==========

PhoneGap plugin to make a camera shot whtout camera inteface

##Install

    >phonegap local plugin add https://github.com/brodysoft/Cordova-SQLitePlugin.git
    
    
##Usage example

    $scope.inButtonClick = function(){
        CordovaService.ready.then(function() {
            var options = { quality : 75,
                            targetWidth: 1024,
                            targetHeight: 768,
                            cameraDirection: 2 };

            SilentFrontCamera.takePicture(function(imageURL){
                $rootScope.imgURL = imageURL;
                $state.go("confirmEmpClockInOut");
            },
            function(){
                alert("Error taking silent front camera photo!");
                $state.go("confirmEmpClockInOut");
            }, options);
        });
    }
    
##Parameters

quality: up to 100 (jpeg quality compression)

targetWidth: in pixels

targetHeight: in pixels

cameraDirection: BACK camera - 1, FRONT camera - 2
