#import "MediaPermissionManager.h"

@implementation MediaPermissionManager

+ (AVAuthorizationStatus)checkMicrophoneAccess {
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
}

+ (AVAuthorizationStatus)checkCameraAccess {
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

+ (void)requestMicrophoneAccessWithCompletion:(void (^)(BOOL granted))completion {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(granted);
            });
        }
    }];
}

+ (void)requestCameraAccessWithCompletion:(void (^)(BOOL granted))completion {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(granted);
            });
        }
    }];
}

@end
