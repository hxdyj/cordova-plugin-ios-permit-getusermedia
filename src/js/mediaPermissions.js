var exec = require('cordova/exec');

var MediaPermissions = {
  checkMicrophoneAccess: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "MediaPermissions", "checkMicrophoneAccess", []);
  },

  checkCameraAccess: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "MediaPermissions", "checkCameraAccess", []);
  },

  requestMicrophoneAccess: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "MediaPermissions", "requestMicrophoneAccess", []);
  },

  requestCameraAccess: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "MediaPermissions", "requestCameraAccess", []);
  }
};

module.exports = MediaPermissions;
