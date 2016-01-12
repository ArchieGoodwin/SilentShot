//
//  IrisAccess.m
//  SilentShot
//
//  Created by Nero Wolfe on 12/01/16.
//
//

#import "IrisAccess.h"
#import <Cordova/NSData+Base64.h>

#define CDV_PHOTO_PREFIX @"irisaccess_photo_"

@implementation IrisAccess
{
    
    BOOL isCameraReady;

}

-(void)getIris:(CDVInvokedUrlCommand *)command
{
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    [self parseCommandArguments:command.arguments];
    [self setDefaults];
    [self startIris];
    if(isCameraReady)
    {
        
        [self performSelectorInBackground:@selector(processingCamera) withObject:nil];
        
    }
    else
    {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Camera is not ready"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        self.hasPendingOperation = NO;
    }
    
    
    
}


-(void)processingCamera
{
    
    CDVPluginResult* result = nil;

    //result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
    
    


    if (result) {
        [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
    }
    self.hasPendingOperation = NO;



}


-(void)startIris {

}

-(void)setDefaults {

}

-(void)parseCommandArguments:(NSArray*) args
{
    
    //image size
    if(args.count > 0)
    {
        
    }
    else
    {
        
    }
    
    
    
    
}


@end
