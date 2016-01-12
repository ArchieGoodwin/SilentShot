/**
 * Created by sdikarev on 01/12/16.
 */
var IrisAccess = {
    getIris: function(success, failure, args){
        cordova.exec(success, failure, "IrisAccess", "getIris", [args]);
    }
    };

module.exports = IrisAccess;