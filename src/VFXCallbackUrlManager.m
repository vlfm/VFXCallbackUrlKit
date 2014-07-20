#import "VFXCallbackUrlManager.h"

#import "VFXCallbackUrlCompletion.h"
#import "VFXCallbackUrlHandler.h"
#import "VFXCallbackUrlParser.h"
#import "VFXCallbackUrlRequirements.h"

NSString * const VFXCallbackUrlErrorDomain = @"VFXCallbackUrlErrorDomain";

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
    
    VFXCallbackUrlHandler *handler = [[self class] handlerWithRequirements:setUrlRequirements processingBlock:processingBlock];
    [_handlers setObject:handler forKey:action];
}

- (BOOL)handleUrl:(NSURL *)url error:(NSError **)error {
    NSString *action = [VFXCallbackUrlParser parseAction:url];
    VFXCallbackUrlHandler *handler = _handlers[action];
    
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
    
    if ([action isEqualToString:[VFXCallbackUrlParser parseAction:url]] == NO) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:VFXCallbackUrlErrorDomain code:VFXCallbackUrlErrorUnknownAction userInfo:@{@"action": action}];
        }
        return NO;
    }
    
    VFXCallbackUrlHandler *handler = [[self class] handlerWithRequirements:setUrlRequirements processingBlock:processingBlock];
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

@end
