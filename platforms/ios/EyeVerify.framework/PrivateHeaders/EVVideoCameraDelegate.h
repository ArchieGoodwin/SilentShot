//===-- EVVideoCameraDelegate.h - EVVideoCameraDelegate Protocol definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EVVideoCameraDelegate Protocol.
///
//===----------------------------------------------------------------------===//

#import <UIKit/UIKit.h>

@protocol EVVideoCameraDelegate <NSObject>

- (BOOL)isAccumulating;
- (void)setIsAccumulating:(BOOL)isAccumulating;
- (BOOL)isAddFrame;
- (void)setIsAddFrame:(BOOL)isAddFrame;
- (BOOL)focusAtPoint:(CGPoint)point useAutoFocus:(BOOL)useAutoFocus;
- (BOOL)exposeAtPoint:(CGPoint)point useAutoExposure:(BOOL)useAutoExposure;
- (void)setExposureCompensation:(float)value24Range;

@end
