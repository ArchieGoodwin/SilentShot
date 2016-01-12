//===-- EVSettings.h - EVSettings class definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EVSettings class.
///
//===----------------------------------------------------------------------===//

#import <AVFoundation/AVFoundation.h>

@interface EVSettings : NSObject

@property (nonatomic, assign) AVCaptureExposureMode exposure;
@property (nonatomic, assign) AVCaptureFocusMode focus;

@property (nonatomic, assign) BOOL useVideoFeed;
@property (nonatomic, assign) int numCapturesPerExposure;
@property (nonatomic, assign) BOOL livenessEnabled;
@property (nonatomic, assign) BOOL logEnhancedImages;
@property (nonatomic, assign) BOOL testDataServiceEnabled;
@property (nonatomic, readonly) BOOL isRestrictedMode;
@property (nonatomic, readonly) NSString *version;

@property (nonatomic, readonly) int killSwitchAbortTimeout;
@property (nonatomic, readonly) int maxVerificationAttempts;
@property (nonatomic, readonly) int enrollmentsPerSession;
@property (nonatomic, weak) NSString *licenseCertificate;

+ (EVSettings *)getInstance;

+ (NSString *)getSettingSupportedDevices;

@end
