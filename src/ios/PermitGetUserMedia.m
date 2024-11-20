#import "PermitGetUserMedia.h"
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PermitGetUserMediaUIDelegate : NSObject<WKUIDelegate>

@property id<WKUIDelegate> previousDelegate;

- (instancetype)initWithPreviousDelegate: (id<WKUIDelegate>)previousDelegate;

@end

@implementation PermitGetUserMediaUIDelegate

- (instancetype)
    initWithPreviousDelegate: (id<WKUIDelegate>) previousDelegate
{
    self = [super init];
    if (self) {
        self.previousDelegate = previousDelegate;
    }
    return self;
}

- (void)
                                   webView: (WKWebView *) webView
    requestMediaCapturePermissionForOrigin: (WKSecurityOrigin *) origin
                          initiatedByFrame: (WKFrameInfo *) frame
                                      type: (WKMediaCaptureType) type
                           decisionHandler: (void (^)(WKPermissionDecision decision)) decisionHandler
{

    // Creating a key for each type of media
    NSString *permissionKey = [NSString stringWithFormat:@"MediaPermissionGranted_%ld", (long)type];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isPermissionGranted = [defaults boolForKey:permissionKey];

    AVAuthorizationStatus status;
        switch (type) {
            case WKMediaCaptureTypeMicrophone:
                status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                break;
            case WKMediaCaptureTypeCamera:
                status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                break;
            default:
                NSLog(@"Unknown media type, prompting user...");
                decisionHandler(WKPermissionDecisionPrompt);
                return;
        }

    // We check if there is already a saved permission
    if (isPermissionGranted || status == AVAuthorizationStatusAuthorized) {
        NSLog(@"Media permission already granted for type: %ld", (long)type);
        decisionHandler(WKPermissionDecisionGrant);
    } else {
        NSLog(@"Requesting media permission for type: %ld", (long)type);
        decisionHandler(WKPermissionDecisionPrompt);

        // We request access if the user agrees
        [AVCaptureDevice requestAccessForMediaType:(type == WKMediaCaptureTypeMicrophone ? AVMediaTypeAudio : AVMediaTypeVideo)
                                 completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [defaults setBool:YES forKey:permissionKey];
                    [defaults synchronize];
                    NSLog(@"Permission granted for type: %ld", (long)type);
                } else {
                    NSLog(@"Permission denied for type: %ld", (long)type);
                }
            });
        }];
    }
}

- (void)
    forwardInvocation: (NSInvocation *) invocation
{
    SEL aSelector = [invocation selector];

    if ([self.previousDelegate respondsToSelector:aSelector]) {
        [invocation invokeWithTarget:self.previousDelegate];
    } else {
        [super forwardInvocation:invocation];
    }
}

@end

@interface PermitGetUserMedia ()

@property PermitGetUserMediaUIDelegate * permitGetUserMediaDelegate;

@end

@implementation PermitGetUserMedia

- (void)
    pluginInitialize
{
    if ([self.webView isKindOfClass:NSClassFromString(@"WKWebView")]) {
        self.permitGetUserMediaDelegate = [[PermitGetUserMediaUIDelegate alloc]
            initWithPreviousDelegate:((WKWebView *)self.webView).UIDelegate];
        [self.webViewEngine updateWithInfo:@{kCDVWebViewEngineWKUIDelegate: self.permitGetUserMediaDelegate}];
    }
}

@end
