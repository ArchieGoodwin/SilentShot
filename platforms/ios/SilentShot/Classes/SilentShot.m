//
//  SilentShot.m
//  PhoneApp
//
//  Created by Nero Wolfe on 11/05/14.
//
//

#import "SilentShot.h"
#import <Cordova/NSData+Base64.h>

#define CDV_PHOTO_PREFIX @"silentshot_photo_"



enum CDVDestinationType {
    DestinationTypeFileUri = 0,
    DestinationTypeBase64 = 1
};

@implementation SilentShot
{
    BOOL isCameraReady;
    AVCaptureDevicePosition cameraType;
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    UIImage *stillImage;
    
    CGSize imageTargetSize;
    NSInteger quality;
    enum CDVDestinationType returnType;
    NSNumber* cameraDirection;
}


-(void)setDefaults {
    cameraType =  [cameraDirection integerValue];
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

//cameraDirection
//	AVCaptureDevicePositionBack                = 1,
//  AVCaptureDevicePositionFront               = 2

/*  takePicture arguments:
 * INDEX   ARGUMENT
 *  0       quality
 *  1       destination type
 *  2       targetWidth
 *  3       targetHeight
 *  4       cameraDirection
 */
-(void)parseCommandArguments:(NSArray*) args
{
    
    //image size
    if(args.count > 0)
    {
        NSDictionary *arguments = args[0];
        NSNumber* targetWidth = arguments[@"targetWidth"] ? arguments[@"targetWidth"] : @240;
        NSNumber* targetHeight = arguments[@"targetHeight"] ? arguments[@"targetHeight"] : @320;
        
        imageTargetSize = CGSizeMake(0, 0);
        if ((targetWidth != nil) && (targetHeight != nil)) {
            imageTargetSize = CGSizeMake([targetWidth floatValue], [targetHeight floatValue]);
        }
        
        quality = arguments[@"quality"] ? [arguments[@"quality"] intValue] : 50;

        returnType = DestinationTypeBase64;
        if(arguments[@"destinationType"])
        {
            NSInteger dest = [arguments[@"destinationType"] integerValue];
            returnType = (enum CDVDestinationType) dest;
        }
        cameraDirection = arguments[@"cameraDirection"] ? arguments[@"cameraDirection"] : [NSNumber numberWithInteger:AVCaptureDevicePositionFront];
    }
    else
    {
        NSNumber* targetWidth = @240;
        NSNumber* targetHeight = @320;
        
        imageTargetSize = CGSizeMake(0, 0);
        if ((targetWidth != nil) && (targetHeight != nil)) {
            imageTargetSize = CGSizeMake([targetWidth floatValue], [targetHeight floatValue]);
        }
        
        quality = 50;
        
        returnType = DestinationTypeBase64;
        
        cameraDirection = [NSNumber numberWithInteger:AVCaptureDevicePositionFront];
    }
    

    

}


-(void)processingCamera
{
    

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
                                                      
                                                      CDVPluginResult* result = nil;
                                                      
                                                      if(!error)
                                                      {
                                                          NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                          UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                          stillImage = [self imageCorrectedForCaptureOrientation:image];
                                                          ///result!!!
                                                          UIImage* scaledImage = nil;
                                                          
                                                          if ((imageTargetSize.width > 0) && (imageTargetSize.height > 0)) {
                                                              
                                                              scaledImage = [self imageByScalingNotCroppingForSize:stillImage toSize:imageTargetSize];
                                                          }
                                                          
                                                          UIImage* returnedImage = (scaledImage == nil ? stillImage : scaledImage);
                                                          
                                                          
                                                          
                                                          // Get the image data (blocking; around 1 second)
                                                          NSData* data = UIImageJPEGRepresentation(returnedImage, quality);
                                                          
                                                          
                                                          
                                                          
                                                          
                                                          if (returnType == DestinationTypeFileUri) {
                                                              // write to temp directory and return URI
                                                              // get the temp directory path
                                                              NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];
                                                              NSError* err = nil;
                                                              NSFileManager* fileMgr = [[NSFileManager alloc] init]; // recommended by apple (vs [NSFileManager defaultManager]) to be threadsafe
                                                              // generate unique file name
                                                              NSString* filePath;
                                                              
                                                              int i = 1;
                                                              do {
                                                                  filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"jpg"];
                                                              } while ([fileMgr fileExistsAtPath:filePath]);
                                                              
                                                              
                                                              NSLog(@"path %@ image: %lu", filePath, (unsigned long)data.length);
                                                              
                                                              // save file
                                                              if (![data writeToFile:filePath options:NSAtomicWrite error:&err]) {
                                                                  result = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
                                                              } else {
                                                                  result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[NSURL fileURLWithPath:filePath] absoluteString]];
                                                              }
                                                          } else {
                                                              result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[data base64EncodedString]];
                                                          }
                                                          
                                                          
                                                      }
                                                      else
                                                      {
                                                          result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                                                          
                                                          
                                                      }
                                                      
                                                      if (result) {
                                                          [self.commandDelegate sendPluginResult:result callbackId:_latestCommand.callbackId];
                                                      }
                                                      self.hasPendingOperation = NO;
                                                      
                                                      
                                                  }];
}

-(void)makeShot:(CDVInvokedUrlCommand *)command
{
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    [self parseCommandArguments:command.arguments];
    [self setDefaults];
    [self startFaceCam];
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


- (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)anImage toSize:(CGSize)targetSize
{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageCorrectedForCaptureOrientation:(UIImage*)anImage
{
    float rotation_radians = 0;
    bool perpendicular = false;
    
    switch ([anImage imageOrientation]) {
        case UIImageOrientationUp :
            rotation_radians = 0.0;
            break;
            
        case UIImageOrientationDown:
            rotation_radians = M_PI; // don't be scared of radians, if you're reading this, you're good at math
            break;
            
        case UIImageOrientationRight:
            rotation_radians = M_PI_2;
            perpendicular = true;
            break;
            
        case UIImageOrientationLeft:
            rotation_radians = -M_PI_2;
            perpendicular = true;
            break;
            
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(anImage.size.width, anImage.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Rotate around the center point
    CGContextTranslateCTM(context, anImage.size.width / 2, anImage.size.height / 2);
    CGContextRotateCTM(context, rotation_radians);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    float width = perpendicular ? anImage.size.height : anImage.size.width;
    float height = perpendicular ? anImage.size.width : anImage.size.height;
    CGContextDrawImage(context, CGRectMake(-width / 2, -height / 2, width, height), [anImage CGImage]);
    
    // Move the origin back since the rotation might've change it (if its 90 degrees)
    if (perpendicular) {
        CGContextTranslateCTM(context, -anImage.size.height / 2, -anImage.size.width / 2);
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize
{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = frameSize.width;
    CGFloat targetHeight = frameSize.height;
    CGFloat scaleFactor = 0.0;
    CGSize scaledSize = frameSize;
    
    if (CGSizeEqualToSize(imageSize, frameSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        // opposite comparison to imageByScalingAndCroppingForSize in order to contain the image within the given bounds
        if (widthFactor > heightFactor) {
            scaleFactor = heightFactor; // scale to fit height
        } else {
            scaleFactor = widthFactor; // scale to fit width
        }
        scaledSize = CGSizeMake(MIN(width * scaleFactor, targetWidth), MIN(height * scaleFactor, targetHeight));
    }
    
    UIGraphicsBeginImageContext(scaledSize); // this will resize
    
    [sourceImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
