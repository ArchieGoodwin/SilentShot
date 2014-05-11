//
//  SilentShot.m
//  PhoneApp
//
//  Created by Nero Wolfe on 11/05/14.
//
//

#import "SilentShot.h"
#import <Cordova/NSData+Base64.h>

@implementation SilentShot
{
    BOOL isCameraReady;
    AVCaptureDevicePosition cameraType;
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    UIImage *stillImage;
}


-(void)setDefaults {
    cameraType = AVCaptureDevicePositionFront;
}


-(void)startFaceCam {
    AVCaptureDevice *device = [self CameraIfAvailable];
    
    if (device) {
        if (!session) {
            session = [[AVCaptureSession alloc] init];
        }
        session.sessionPreset = AVCaptureSessionPresetMedium;
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input) {
            // Handle the error appropriately.
            NSLog(@"ERROR: trying to open camera: %@", error);
        } else {
            if ([session canAddInput:input]) {
                [session addInput:input];
                [session startRunning];
                [self addStillImageOutput];
            } else {
                NSLog(@"Couldn't add input");
            }
        }
    } else {
        NSLog(@"Camera not available");
    }
}

-(AVCaptureDevice *)CameraIfAvailable
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == cameraType)
        {
            captureDevice = device;
            break;
        }
    }
    
    //just in case
    if (!captureDevice) {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    if(!captureDevice)
    {
        isCameraReady = NO;
    }
    else
    {
        isCameraReady = YES;
    }
    return captureDevice;
}

- (void)addStillImageOutput
{
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [stillImageOutput connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [session addOutput:stillImageOutput];
}




-(void)makeShot:(CDVInvokedUrlCommand *)command
{
    
    [self setDefaults];
    [self startFaceCam];
    
    AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [stillImageOutput connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
            break;
        }
	}
    
	NSLog(@"about to request a capture from: %@", stillImageOutput);
    

    
	[stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                  completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                      if(!error)
                                                      {
                                                          NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                          UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                          stillImage = image;
                                                          ///result!!!
                                                          
                                                          // Get a file path to save the JPEG
                                                          NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                          NSString* documentsDirectory = [paths objectAtIndex:0];
                                                          NSString* filename = @"test.jpg";
                                                          NSString* imagePath = [documentsDirectory stringByAppendingPathComponent:filename];
                                                          
                                                          // Get the image data (blocking; around 1 second)
                                                          NSData* data = UIImageJPEGRepresentation(stillImage, 0.5);
                                                          
                                                          // Write the data to the file
                                                          [data writeToFile:imagePath atomically:YES];
                                                          
                                                          
                                                          NSLog(@"path %@ image: %lu", imagePath, (unsigned long)data.length);
                                                          // Create an object that will be serialized into a JSON object.
                                                          // This object contains the date String contents and a success property.
                                                          /*NSDictionary *jsonObj = [ [NSDictionary alloc]
                                                                                   initWithObjectsAndKeys :
                                                                                   [data base64EncodedString], @"image",
                                                                                   @"true", @"success",
                                                                                   nil
                                                                                   ];
                                                          */
                                                          // Create an instance of CDVPluginResult, with an OK status code.
                                                          // Set the return message as the Dictionary object (jsonObj)...
                                                          // ... to be serialized as JSON in the browser
                                                          CDVPluginResult *pluginResult = [ CDVPluginResult
                                                                                           resultWithStatus    : CDVCommandStatus_OK
                                                                                           messageAsString : imagePath
                                                                                           ];
                                                          
                                                          // Execute sendPluginResult on this plugin's commandDelegate, passing in the ...
                                                          // ... instance of CDVPluginResult
                                                          [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                      }
                                                      else
                                                      {
                                                          CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                                                          [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


                                                      }
                                                     
                                                      
                                                  }];
    
    
    
}

@end
