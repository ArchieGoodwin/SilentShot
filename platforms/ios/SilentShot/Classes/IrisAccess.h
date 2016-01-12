//
//  IrisAccess.h
//  SilentShot
//
//  Created by Nero Wolfe on 12/01/16.
//
//

#import <Cordova/CDVPlugin.h>
#import "EyeVerifyLoader.h"


@interface IrisAccess : CDVPlugin <EVAuthSessionDelegate>



@property (readwrite, assign) BOOL hasPendingOperation;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;

-(void)getIris:(CDVInvokedUrlCommand *)command;

@end
