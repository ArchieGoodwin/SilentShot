//===-- VideoCamera.h - VideoCamera class definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the VideoCamera class.
///
//===----------------------------------------------------------------------===//

#import "EVVideoCameraDelegate.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

static bool VideoCamera_open = false;

@interface VideoCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, EVVideoCameraDelegate>

/// Use this property to manage camera settings. Focus point, exposure point, etc.
@property (nonatomic, readonly) BOOL isVideoMode;
@property (readonly) AVCaptureDevice *inputCamera;
@property (readonly, nonatomic) float brightness;
@property (readonly, nonatomic) int isoRating;
@property (readonly, nonatomic) CMTime currentTime;
@property (assign, nonatomic) BOOL hardwareLocked;
@property (nonatomic, readwrite) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain) AVCaptureSession *session;

- (instancetype)init;

- (void)setExposureDurationUsec:(int64_t)usecDuration;
- (void)setExposureDurationUsec:(int64_t)usecDuration ISO:(float)iso;

- (void)startVideoPreview;
- (void)stopVideoPreview;

@end
