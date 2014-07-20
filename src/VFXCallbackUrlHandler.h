#import <Foundation/Foundation.h>

#import "VFXCallbackUrl.h"

@class VFXCallbackUrlRequirements;

@interface VFXCallbackUrlHandler : NSObject

- (instancetype)initWithUrlRequirements:(VFXCallbackUrlRequirements *)urlRequirements
                        processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock;

- (void)handleUrl:(NSURL *)url;

@end
