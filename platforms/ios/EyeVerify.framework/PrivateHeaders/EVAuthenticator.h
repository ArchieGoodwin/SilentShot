//===-- EVAuthenticator.h - EVAuthenticator class definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EVAuthenticator class.
///
//===----------------------------------------------------------------------===//

#import "EVAuthenticatorDelegate.h"
#import "EyeVerify.h"
#import "VideoCamera.h"

#import <EVEnums.h>

#import <UIKit/UIKit.h>

@protocol EyeVerifyDelegate <NSObject>
- (void)enrollmentCompleted:(BOOL)enrolled error:(NSError*) error;
- (void)verificationCompleted:(BOOL)verified userKey:(NSData *)userKey error:(NSError*) error;
@end

@interface EVAuthenticator : NSObject <EVAuthenticatorDelegate>

@property (nonatomic, readonly) BOOL isBusy;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSData *userKey;
@property (nonatomic, weak) UIView *captureView;

@property (nonatomic, weak) id<EVAuthSessionDelegate> authSessionDelegate;

- (instancetype)initWithLicense:(NSString *)license_certificate delegate:(id<EyeVerifyDelegate>)delegate;

- (license_result_enum)validateLicense:(NSString *)license;
- (BOOL)isUserEnrolled:(NSString *)user;
- (NSArray*)getEnrolledUsers;
- (void)deleteEnrollments;

- (void)cancelRequest:(abort_reason_enum)reason;
- (void)captureEnrollment:(BOOL)continueAuth;
- (void)captureVerification;
- (void)continueAuth;

@end
