//
//  IrisAccess.h
//  SilentShot
//
//  Created by Nero Wolfe on 12/01/16.
//
//

#import <Cordova/CDVPlugin.h>

@interface IrisAccess : CDVPlugin



@property (readwrite, assign) BOOL hasPendingOperation;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;

-(void)getIris:(CDVInvokedUrlCommand *)command;

@end
