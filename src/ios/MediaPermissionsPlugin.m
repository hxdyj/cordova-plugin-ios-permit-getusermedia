#import <Cordova/CDVPlugin.h>
#import "MediaPermissionManager.h"

@interface MediaPermissionsPlugin : CDVPlugin

- (void)checkMicrophoneAccess:(CDVInvokedUrlCommand *)command;
- (void)checkCameraAccess:(CDVInvokedUrlCommand *)command;
- (void)requestMicrophoneAccess:(CDVInvokedUrlCommand *)command;
- (void)requestCameraAccess:(CDVInvokedUrlCommand *)command;

@end

@implementation MediaPermissionsPlugin

- (void)checkMicrophoneAccess:(CDVInvokedUrlCommand *)command {
    AVAuthorizationStatus status = [MediaPermissionManager checkMicrophoneAccess];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:status]
                                callbackId:command.callbackId];
}

- (void)checkCameraAccess:(CDVInvokedUrlCommand *)command {
    AVAuthorizationStatus status = [MediaPermissionManager checkCameraAccess];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:status]
                                callbackId:command.callbackId];
}

- (void)requestMicrophoneAccess:(CDVInvokedUrlCommand *)command {
    [MediaPermissionManager requestMicrophoneAccessWithCompletion:^(BOOL granted) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:granted]
                                    callbackId:command.callbackId];
    }];
}

- (void)requestCameraAccess:(CDVInvokedUrlCommand *)command {
    [MediaPermissionManager requestCameraAccessWithCompletion:^(BOOL granted) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:granted]
                                    callbackId:command.callbackId];
    }];
}

@end
