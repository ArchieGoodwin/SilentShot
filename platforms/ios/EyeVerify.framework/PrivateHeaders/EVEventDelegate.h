//===-- EVEventDelegate.h - EVEventDelegate class definition --------------===//
//
//                     EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EVEventDelegate class.
///
//===----------------------------------------------------------------------===//

#import "EVAuthenticatorDelegate.h"
#import "EVVideoCameraDelegate.h"
#import "EvpEventDelegate.hpp"

#import <Foundation/Foundation.h>

@interface EVEventDelegate : NSObject

@property (nonatomic, weak) id<EVVideoCameraDelegate> videoCameraDelegate;
@property (nonatomic, weak) id<EVAuthenticatorDelegate> evAuthenticatorDelegate;
@property (nonatomic) EvpEventDelegate *evpEventDelegate;

+ (EVEventDelegate *)getInstance;

- (void)publishEventFocusCompleted;
- (void)publishEventExposureCompleted;

@end
