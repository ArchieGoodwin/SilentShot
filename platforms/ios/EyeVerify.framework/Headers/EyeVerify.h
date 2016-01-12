//===-- EyeVerify.h - EyeVerify class definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EyeVerify class.
///
//===----------------------------------------------------------------------===//

#import <UIKit/UIKit.h>

/// @name Eye Status enum values
/// @{

typedef NS_ENUM(NSInteger, EVEyeStatus) {
    EVEyeStatusOkay,
    EVEyeStatusTooFar,
    EVEyeStatusNoEye,
};

/// @}

/// @name Authentication session delegate callbacks
/// @{

@protocol EVAuthSessionDelegate <NSObject>
@optional
- (void)enrollmentProgressUpdated:(float)completionRatio counter:(int)counterValue;
- (void)eyeStatusChanged:(EVEyeStatus)newEyeStatus;
- (void)enrollmentSessionStarted:(int)totalSteps;
- (void)enrollmentSessionCompleted:(BOOL)isFinished;
@end

/// @}

@class EVAuthenticator;

/// @name Completion Blocks
/// @{

typedef void(^EnrollmentCompletion)(BOOL enrolled, NSData *userKey, NSError *error);
typedef void(^VerificationCompletion)(BOOL verified, NSData *userKey, NSError *error);

/// @}

/// @name Errors
/// @{

FOUNDATION_EXPORT NSString *const EVErrorDomain;

enum {
    EVSystemError = 1,
    EVUnsupportedDeviceError = 2,
    EVUserAbortedError = 3,
    EVInvalidLicenseError = 4
};

/// @}

/// EyeVerify class
@interface EyeVerify : NSObject

@property (nonatomic, readonly) BOOL isBusy;

/// SDK version
@property (nonatomic, readonly) NSString *version;

/// The current user name
@property (nonatomic, copy) NSString *userName;

/// @name Enrollment
/// @{

/**
 Use this method when user authentication utilizes the Local Key Storage

 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @param userKey User Key of enrolled user. This parameter used only with Eyeprint Trust Server and Local Key Storage.
 @param block Completion block
 */
- (BOOL)enrollUser:(NSString *)user_name userKey:(NSData*)userKey localCompletionBlock:(EnrollmentCompletion)block;

/// @}

/// @name Verification
/// @{

/**
 Use this method to implement user authentication with User Key which will be retrieved by EyeVerify SDK from the Local Key Storage

 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @param block Completion block
 */
- (BOOL)verifyUser:(NSString *)user_name localCompletionBlock:(VerificationCompletion)block;

/// @}


/**
 Cancel enrollment or verification session
 */
- (void)cancel;

/**
 Continue enrollment or verification session
 */
- (void)continueAuth;

/// @name Removing Users
/// @{

/**
 This method will remove the specified user and erase enrollment data

 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 */
- (void)removeUser:(NSString *)user_name;

/// Removes all users
- (void)removeAllUsers;

/// @}


/// @name Enrolled Users
/// @{

/**
 Check if a username has enrollment data

 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @return Boolean indicating enrollment status
 */
- (BOOL)isUserEnrolled:(NSString *)user_name;

/**
 Get list of currently enrolled users

 @return NSArray containing enrolled usernames
 */
- (NSArray *)getEnrolledUsers;

/// @}

/**
 Set authentication session delegate
 
 @param delegate Authentication session delegate
 */
- (void)setEVAuthSessionDelegate:(id<EVAuthSessionDelegate>)delegate;

/**
 Set camera preview capture view
 
 @param captureView Authentication session delegate
 */
- (void)setCaptureView:(UIView *)captureView;

/**
 Compliance

 @param user_name Unique ID of the user. Username should contain at least one character, cannot start with “.” symbol, cannot contain “ ” (space) or “/” symbols. Otherwise EyeVerify SDK will return error.
 @param error An error object if (TODO: list error conditions)
 @return
 */
- (BOOL)checkCompliance:(NSString *)userName error:(NSError**) error;

@end
