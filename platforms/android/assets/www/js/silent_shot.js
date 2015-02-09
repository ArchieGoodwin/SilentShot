/**
 * Created by sdikarev on 11/05/14.
 */
var SilentShot = {
    makeShot: function(success, failure, args){
        cordova.exec(success, failure, "SilentShot", "makeShot", [args]);
    }
};

module.exports = SilentShot;