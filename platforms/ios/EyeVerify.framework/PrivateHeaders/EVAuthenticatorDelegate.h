//===-- EVAuthenticatorDelegate.h - EVAuthenticatorDelegate Protocol definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EVAuthenticatorDelegate Protocol.
///
//===----------------------------------------------------------------------===//

#import "EVEnums.h"

#import <Foundation/Foundation.h>

@protocol EVAuthenticatorDelegate <NSObject>

- (void)enrollmentCompleted:(enroll_result_enum)enroll_result abortReason:(abort_reason_enum)abort_reason;
- (void)verificationCompleted:(verify_result_enum)result userKey:(NSData *)userKey abortReason:(abort_reason_enum)abort_reason;
- (void)enrollmentSessionCompleted:(BOOL)isFinished;
- (void)handleEyeStatusChanged:(EyeStatus)newEyeStatus;
- (void)enrollmentStepCompleted:(enroll_result_enum)result step:(int)stepCompleted totalSteps:(int)totalSteps counter:(int)count;
- (void)enrollmentSessionStarted:(int)totalSteps;
- (void)processingStarted;
- (void)verificationStepCompleted:(verify_result_enum)result attemptNumber:(int)attemptNumber maxAttempts:(int)maxAttempts;

@end
