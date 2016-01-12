//===-- ImageUtility.h - ImageUtility class definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the ImageUtility class.
///
//===----------------------------------------------------------------------===//

#import <opencv2/core/core.hpp>

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define MIN3(x,y,z)  ((y) <= (z) ? \
((x) <= (y) ? (x) : (y)) \
: \
((x) <= (z) ? (x) : (z)))

#define MAX3(x,y,z)  ((y) >= (z) ? \
((x) >= (y) ? (x) : (y)) \
: \
((x) >= (z) ? (x) : (z)))

#define INTENSITY(rgb) ((int) MAX3(rgb.val[0], rgb.val[1], rgb.val[2]))

#define DIF(a,b) (abs(a-b))

@interface ImageUtility : NSObject

+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat isBGR:(BOOL)bgr;

//+ (CIImage *)ciimageWithBytes:(uchar*)bytes
//                    imageSize:(CGSize)imageSize
//                     channels:(size_t)channels
//                        isBGR:(BOOL)bgr;

+ (UIImage *)imageWithBytes:(uchar*)bytes
                  imageSize:(CGSize)imageSize
                   channels:(size_t)channels
                bytesPerRow:(size_t)bytesPerRow
                      isBGR:(BOOL)bgr;

+ (cv::Mat) CVMatForImage:(UIImage *)image;

+ (cv::Mat *) CVMatForBuffer:(CMSampleBufferRef)sampleBuffer;
+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
                              isBGR:(BOOL)isBGR
                        orientation:(UIImageOrientation)orientation;

+ (UIColor *) UIColorForScalar:(CvScalar)color;
+ (CvScalar) scalarForUIColor:(UIColor *)color; 

+ (UIImage *) cropImage:(UIImage *)image toBounds:(CGRect)imageBounds;

+ (cv::Rect) rectAtPoint:(CvPoint)point withRadius:(int)radius inMat:(cv::Mat)cvMat;

+ (CGRect) fitRect:(CGRect)innerRect withinRect:(CGRect)outerRect;

@end
