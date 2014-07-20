#import <Foundation/Foundation.h>

#import "VFXCallbackUrl.h"

@class VFXCallbackUrlCompletion;
@class VFXCallbackUrlRequirements;

@interface VFXCallbackUrlManager : NSObject

- (instancetype)initWithScheme:(NSString *)scheme;

- (void)registerAction:(NSString *)action requirements:(void(^)(VFXCallbackUrlRequirements**))requirements
       processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock;

- (BOOL)handleUrl:(NSURL *)url error:(NSError **)error;

- (BOOL)handleUrl:(NSURL *)url action:(NSString *)action
     requirements:(VFXCallbackUrlRequirementsSetBlock)requirements
  processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock
            error:(NSError **)error;

@end
