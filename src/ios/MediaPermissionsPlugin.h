#import <Cordova/CDVPlugin.h>

@interface MediaPermissionsPlugin : CDVPlugin

- (void)checkMicrophoneAccess:(CDVInvokedUrlCommand *)command;

- (void)checkCameraAccess:(CDVInvokedUrlCommand *)command;

- (void)requestMicrophoneAccess:(CDVInvokedUrlCommand *)command;

- (void)requestCameraAccess:(CDVInvokedUrlCommand *)command;

@end
