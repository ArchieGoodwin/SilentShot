//
//  EVLicense.h
//  EyeVerify
//

#import <Foundation/Foundation.h>

@interface EVLicense : NSObject

+ (NSString *)currentLicenseCertificate;

- (void)setLicenseCertificate:(NSString *)licenseCertificate;

@end
