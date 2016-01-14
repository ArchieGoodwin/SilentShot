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
    NSInteger scanType;
    NSString *userNameFromOptions;
    NSString *userKeyFromOptions;
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
    if(scanType == 0)
    {
        [self enroll];

    }
    else
    {
        [self verify];
    }
}


- (void) enroll {
    
    __block CDVPluginResult* result = nil;
    
    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
    if (ev) {
        [ev setEVAuthSessionDelegate:self];
        [ev enrollUser:ev.userName userKey:[userKeyFromOptions dataUsingEncoding:NSUTF8StringEncoding] localCompletionBlock:^(BOOL enrolled, NSData *userKey, NSError *error) {
            NSLog(@"Enrollment: enrolled=%d; userKey=%@ error=%@", enrolled, userKey != nil ? [[NSString alloc] initWithData:userKey encoding:NSUTF8StringEncoding] : @"nil", error);
            if(enrolled)
            {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[NSString alloc] initWithData:userKey encoding:NSUTF8StringEncoding]];

            }
            else
            {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];

            }

            if (result) {
                [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
            }
            self.hasPendingOperation = NO;
            
        }];
    }
}

- (void) verify {

    __block CDVPluginResult* result = nil;

    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
    if (ev) {
        [ev setEVAuthSessionDelegate:self];
        [ev verifyUser:ev.userName localCompletionBlock:^(BOOL verified, NSData *userKey, NSError *error) {
            NSLog(@"Verifying: verified=%d; userKey=%@ error=%@", verified, userKey != nil ? [[NSString alloc] initWithData:userKey encoding:NSUTF8StringEncoding] : @"nil", error);
            if(verified)
            {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Verified"];
            }
            else
            {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Not Verified"];

            }

            
            if (result) {
                [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
            }
            self.hasPendingOperation = NO;
            
           
        }];
    }
}

-(void)setDefaults {
    evLoader = [[EyeVerifyLoader alloc] init];
    [evLoader loadEyeVerifyWithLicense:@"1DBRJYSHENYXWOK0"];

    EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
    ev.userName = userNameFromOptions;

    [ev setCaptureView:[[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)]];

    
}

-(void)parseCommandArguments:(NSArray*) args
{
    
    if(args.count > 0)
    {
        NSDictionary *arguments = args[0];

        if(arguments[@"scanType"])
        {
            NSInteger dest = [arguments[@"scanType"] integerValue];
            scanType = dest;
        }
        if(arguments[@"userName"])
        {
            userNameFromOptions = arguments[@"userName"];

        }
        if(arguments[@"userKey"])
        {
            userNameFromOptions = arguments[@"userKey"];
            
        }
        NSLog(@"userName: %@   userKey: %@   scanType: %li", userNameFromOptions, userKeyFromOptions, scanType);

    }
    else
    {
        scanType = 1;
        userNameFromOptions = @"sample";
        userKeyFromOptions = @"1234fhshfsf678906867";
    }
    
}


- (void) eyeStatusChanged:(EVEyeStatus)newEyeStatus
{
    
    __block CDVPluginResult* result = nil;
    NSLog(@"%li", (long)newEyeStatus);
    //self.scanningOverlay.targetHighlighted = NO;
    switch (newEyeStatus) {
        case EVEyeStatusNoEye:{
            NSLog(@"%@", @"Position your eyes in the window");
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_INVALID_ACTION messageAsString:@"Position your eyes in front of front camera (about 20cm to device)"];
            EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
            [ev cancel];
            if (result) {
                [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
            }
            self.hasPendingOperation = NO;}
            break;
        case EVEyeStatusTooFar:{
            NSLog(@"%@", @"Move device closer");
            
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_INVALID_ACTION messageAsString:@"Move device closer (about 20cm to device)"];
            EyeVerify *ev = [EyeVerifyLoader getEyeVerifyInstance];
            [ev cancel];
            if (result) {
                [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
            }
            self.hasPendingOperation = NO;}
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
