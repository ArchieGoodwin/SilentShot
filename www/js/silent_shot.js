/**
 * Created by sdikarev on 11/05/14.
 */
var SilentShot = {
    makeShot: function(success, failure){
        cordova.exec(success, failure, "SilentShot", "makeShot", []);
    }
};

module.exports = SilentShot;