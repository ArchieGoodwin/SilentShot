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
    EyeVerifyLoader *evLoader;
    BOOL isCameraReady;

}

-(void)getIris:(CDVInvokedUrlCommand *)command
{
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    [self parseCommandArguments:command.arguments];
    [self setDefaults];
    
    [self performSelectorInBackground:@selector(startIris) withObject:nil];

    
    //[self startIris];
    /*if(isCameraReady)
    {
        
        [self performSelectorInBackground:@selector(processingCamera) withObject:nil];
        
    }
    else
    {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Camera is not ready"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        self.hasPendingOperation = NO;
    }*/
    
    
    
}


-(void)processingCamera
{
    

    
    


   



}


-(void)startIris {
    [self enroll];
}


- (void) enroll {
    
    __block CDVPluginResult* result = nil;
    
    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
    if (ev) {
        [ev setEVAuthSessionDelegate:self];
        [ev enrollUser:ev.userName userKey:[@"1234fhshfsf678906867" dataUsingEncoding:NSUTF8StringEncoding] localCompletionBlock:^(BOOL enrolled, NSData *userKey, NSError *error) {
            NSLog(@"Enrollment localCompletionBlock: enrolled=%d; userKey=%@ error=%@", enrolled, userKey != nil ? [[NSString alloc] initWithData:userKey encoding:NSUTF8StringEncoding] : @"nil", error);
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];

            if (result) {
                [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
            }
            self.hasPendingOperation = NO;
            
        }];
    }
}

- (void) verify {
    
    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
    
    if (ev) {
        [ev setEVAuthSessionDelegate:self];
        [ev verifyUser:ev.userName localCompletionBlock:^(BOOL verified, NSData *userKey, NSError *error) {
            NSLog(@"Enrollment localCompletionBlock: enrolled=\(enrolled); userKey=\(userKey != nil ? NSString(data: userKey!, encoding: NSUTF8StringEncoding) : nil) error=\(error)");

            if (error) {
                NSLog(@"%@", error.localizedFailureReason);
            }
            
           
        }];
    }
}

-(void)setDefaults {
    evLoader = [[EyeVerifyLoader alloc] init];
    [evLoader loadEyeVerifyWithLicense:@"1DBRJYSHENYXWOK0"];

    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
    ev.userName = @"sample";

    [ev setCaptureView:[[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)]];

    
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


- (void) eyeStatusChanged:(EVEyeStatus)newEyeStatus
{
    
    __block CDVPluginResult* result = nil;
    NSLog(@"%li", (long)newEyeStatus);
    //self.scanningOverlay.targetHighlighted = NO;
    switch (newEyeStatus) {
        case EVEyeStatusNoEye:
            NSLog(@"%@", @"Position your eyes in the window");
            /*result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Position your eyes in the window"];
            
            if (result) {
                [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
            }*/
            break;
        case EVEyeStatusTooFar:
            NSLog(@"%@", @"Move device closer");
            /*result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Move device closer"];
            
            if (result) {
                [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
            }*/
            break;
        case EVEyeStatusOkay:
            NSLog(@"%@", @"Scanning OK");

            break;
    }
}

- (void) enrollmentProgressUpdated:(float)completionRatio counter:(int)counterValue
{
    NSLog(@"counter: %d  completionRatio: %f",counterValue, completionRatio);
    
}

- (void) enrollmentSessionStarted:(int)totalSteps
{
    NSLog(@"totalSteps: %d ",totalSteps);

}

- (void)enrollmentSessionCompleted:(BOOL)isFinished
{
    NSLog(@"isFinished: %d ",isFinished);
    if(!isFinished)
    {
        EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];

        [ev continueAuth];
        
    }
}



@end
