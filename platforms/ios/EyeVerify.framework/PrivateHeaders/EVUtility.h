//===-- EVUtility.h - EVUtility class definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EVUtility class.
///
//===----------------------------------------------------------------------===//

#import <UIKit/UIKit.h>

@interface EVUtility : NSObject

+ (NSString *)documentsDirectory;
+ (NSString *)directoryInDocuments:(NSString *)directoryName;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

typedef void(^SaveImageCompletion)(NSError* error);

+ (void)saveImage:(UIImage *)image
      toAlbumOrNil:(NSString *)album
   completionBlock:(SaveImageCompletion)block;

+ (NSString*)getDeviceId;

#pragma mark -
#pragma mark Queue utilities
void runOnMainQueueWithoutDeadlocking(void (^block)(void));

@end
