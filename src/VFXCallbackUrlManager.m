#import "VFXCallbackUrlManager.h"

#import "VFXCallbackUrlHandler.h"
#import "VFXCallbackUrlRequest.h"
#import "VFXCallbackUrlRequirements.h"

NSString * const VFXCallbackUrlErrorDomain = @"VFXCallbackUrlErrorDomain";

NSString * const VFXCallbackUrlNotification = @"VFXCallbackUrlNotification";

NSString * const VFXCallbackUrlXSource = @"x-source";
NSString * const VFXCallbackUrlXSuccess = @"x-success";
NSString * const VFXCallbackUrlXError = @"x-error";
NSString * const VFXCallbackUrlXCancel = @"x-cancel";

@implementation VFXCallbackUrlManager {
    NSString *_scheme;
    NSMutableDictionary *_handlers;
}

- (instancetype)initWithScheme:(NSString *)scheme {
    self = [super init];
    _scheme = scheme;
    _handlers = [NSMutableDictionary dictionary];
    return self;
}

- (void)registerAction:(NSString *)action requirements:(VFXCallbackUrlRequirementsSetBlock)setUrlRequirements
       processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock {
    
    VFXCallbackUrlHandler *handler = [[self class] handlerWithRequirements:setUrlRequirements
                                                           processingBlock:[self notificationProcessingBlock:processingBlock]];
    [_handlers setObject:handler forKey:action];
}

- (BOOL)handleUrl:(NSURL *)url error:(NSError **)error {
    NSString *action = [VFXCallbackUrlRequest getActionFromUrl:url];
    VFXCallbackUrlHandler *handler = (action != nil) ? _handlers[action] : nil;
    
    if (handler == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:VFXCallbackUrlErrorDomain code:VFXCallbackUrlErrorUnknownAction userInfo:@{@"action": action}];
        }
        return NO;
    }
    
    [handler handleUrl:url];
    return YES;
}

- (BOOL)handleUrl:(NSURL *)url action:(NSString *)action
     requirements:(VFXCallbackUrlRequirementsSetBlock)setUrlRequirements
  processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock
            error:(NSError **)error {
    
    if ([action isEqualToString:[VFXCallbackUrlRequest getActionFromUrl:url]] == NO) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:VFXCallbackUrlErrorDomain code:VFXCallbackUrlErrorUnknownAction userInfo:@{@"action": action}];
        }
        return NO;
    }
    
    VFXCallbackUrlHandler *handler = [[self class] handlerWithRequirements:setUrlRequirements
                                                           processingBlock:[self notificationProcessingBlock:processingBlock]];
    [handler handleUrl:url];
    return YES;
}

+ (VFXCallbackUrlHandler *)handlerWithRequirements:(VFXCallbackUrlRequirementsSetBlock)setUrlRequirements
                                   processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock {
    
    VFXCallbackUrlRequirements *urlRequirements = [VFXCallbackUrlRequirements new];
    if (setUrlRequirements) {
        setUrlRequirements(&urlRequirements);
    }
    
    return [[VFXCallbackUrlHandler alloc] initWithUrlRequirements:urlRequirements processingBlock:processingBlock];
}

- (VFXCallbackUrlProcessingBlock)notificationProcessingBlock:(VFXCallbackUrlProcessingBlock)processingBlock {
    return ^ (VFXCallbackUrlRequest *request, NSArray *errors) {
        processingBlock(request, errors);
        
        NSNotification *n = [NSNotification notificationWithName:VFXCallbackUrlNotification object:request];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    };
}

@end
