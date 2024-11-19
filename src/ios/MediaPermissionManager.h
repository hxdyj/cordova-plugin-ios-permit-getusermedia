#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MediaPermissionManager : NSObject

+ (AVAuthorizationStatus)checkMicrophoneAccess;
+ (AVAuthorizationStatus)checkCameraAccess;

+ (void)requestMicrophoneAccessWithCompletion:(void (^)(BOOL granted))completion;
+ (void)requestCameraAccessWithCompletion:(void (^)(BOOL granted))completion;

@end
