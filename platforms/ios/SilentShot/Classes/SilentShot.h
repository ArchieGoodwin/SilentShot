//
//  SilentShot.h
//  PhoneApp
//
//  Created by Nero Wolfe on 11/05/14.
//
//

#import <Cordova/CDVPlugin.h>
#import <AVFoundation/AVFoundation.h>

@interface SilentShot : CDVPlugin

@property (readwrite, assign) BOOL hasPendingOperation;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;

-(void)makeShot:(CDVInvokedUrlCommand *)command;



@end
