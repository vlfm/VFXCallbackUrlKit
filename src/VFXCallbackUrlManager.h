#import <Foundation/Foundation.h>

#import "VFXCallbackUrl.h"

@class VFXCallbackUrlRequest;
@class VFXCallbackUrlRequirements;

/**
  * Note that VFXCallbackUrlNotification is posted after processingBlock is completed.
  * Notifications's object is the same, as in processingBlock.
*/
@interface VFXCallbackUrlManager : NSObject

- (instancetype)initWithScheme:(NSString *)scheme;

/**
  * VFXCallbackUrlNotification is posted after processingBlock is completed.
*/
- (void)registerAction:(NSString *)action requirements:(void(^)(VFXCallbackUrlRequirements**))requirements
       processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock;

- (BOOL)handleUrl:(NSURL *)url error:(NSError **)error;

/**
  * Handle url with specific action. If action in url is different, error is returned.
  * This is convenient method for handling urls, when action is known.
  * Processing block is passed as argument, no need to register an action.
  *
  * VFXCallbackUrlNotification is posted after processingBlock is completed.
*/
- (BOOL)handleUrl:(NSURL *)url action:(NSString *)action
     requirements:(VFXCallbackUrlRequirementsSetBlock)requirements
  processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock
            error:(NSError **)error;

@end
