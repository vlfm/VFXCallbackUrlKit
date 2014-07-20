#import "VFXCallbackUrlHandler.h"

#import "VFXCallbackUrl.h"
#import "VFXCallbackUrlCompletion.h"
#import "VFXCallbackUrlParser.h"
#import "VFXCallbackUrlRequirements.h"

@implementation VFXCallbackUrlHandler {
    VFXCallbackUrlProcessingBlock _processingBlock;
    VFXCallbackUrlRequirements *_urlRequirements;
}

- (instancetype)initWithUrlRequirements:(VFXCallbackUrlRequirements *)urlRequirements
                        processingBlock:(VFXCallbackUrlProcessingBlock)processingBlock {
    self = [super init];
    _processingBlock = [processingBlock copy];
    _urlRequirements = urlRequirements;
    return self;
}

- (void)handleUrl:(NSURL *)url {
    VFXCallbackUrlParseResult *result = [VFXCallbackUrlParser parseUrl:url];
    
    VFXCallbackUrlCompletion *completion = [[VFXCallbackUrlCompletion alloc]
                                            initWithSuccessCallback:result.successCallback
                                            errorCallback:result.errorCallback
                                            cancelCallback:result.cancelCallback];
    
    NSMutableArray *errors = [NSMutableArray array];
    
    if (_urlRequirements.sourceRequired) {
        if (result.source == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": VFXCallbackUrlXSource}]];
        }
    }
    
    if (_urlRequirements.successCallbackRequired) {
        if (result.successCallback == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": VFXCallbackUrlXSuccess}]];
        }
    }
    
    if (_urlRequirements.errorCallbackRequired) {
        if (result.errorCallback == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": VFXCallbackUrlXError}]];
        }
    }
    
    if (_urlRequirements.cancelCallbackRequired) {
        if (result.cancelCallback == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": VFXCallbackUrlXCancel}]];
        }
    }
    
    for (NSString *parameter in _urlRequirements.requiredParameters) {
        if (result.parameters[parameter] == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": parameter}]];
        }
    }
    
    _processingBlock(result.source, result.parameters, [NSArray arrayWithArray:errors], completion);
}

@end
