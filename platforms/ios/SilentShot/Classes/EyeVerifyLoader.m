//
//  EyeVerifyLoader.m
//  EyeprintID
//

#import "EyeVerifyLoader.h"
#import <EyeVerify/EVLicense.h>

#import <dlfcn.h>

static EyeVerify *ev;
static EVLicense *evLicenser;

@implementation EyeVerifyLoader

+ (EyeVerify *)getEyeVerifyInstance {
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer  floatValue]>=8.0) {
        if (ev != nil) {
            return ev;
        }
    }
    return nil;
}

- (void)loadEyeVerifyWithLicense:(NSString *)license {
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer  floatValue]>=8.0) {
        [self loadDynamicFramework];
        evLicenser = [[NSClassFromString (@"EVLicense") alloc] init];
        [evLicenser setLicenseCertificate:license];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ev = [[NSClassFromString (@"EyeVerify") alloc] init];
        });
    }
}

- (void)loadDynamicFramework {
    NSString *LibName = @"EyeVerify";
    NSString *LibExtension = @"framework";
    NSString *Path = [[NSBundle mainBundle] pathForResource:LibName ofType:LibExtension];
    NSLog(@"Loading dynamic library: %@", Path);
    Path=[Path stringByAppendingString:@"/EyeVerify"];
    
    void *revealLib = NULL;
    revealLib = dlopen([Path cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    
    if (revealLib == NULL) {
        char *error = dlerror();
        NSLog(@"dlopen error: %s", error);
        NSString *message = [NSString stringWithFormat:@"%@.%@ failed to load with error: %s", LibName, LibExtension, error];
        [[[UIAlertView alloc] initWithTitle:@"Library could not be loaded" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
