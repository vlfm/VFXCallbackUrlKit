#import "VFXCallbackUrlHandler.h"

#import "VFXCallbackUrl.h"
#import "VFXCallbackUrlRequest.h"
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
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestFromUrl:url];
    
    NSMutableArray *errors = [NSMutableArray array];
    
    if (_urlRequirements.sourceRequired) {
        if (request.source == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": VFXCallbackUrlXSource}]];
        }
    }
    
    if (_urlRequirements.successCallbackRequired) {
        if (request.successCallback == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": VFXCallbackUrlXSuccess}]];
        }
    }
    
    if (_urlRequirements.errorCallbackRequired) {
        if (request.errorCallback == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": VFXCallbackUrlXError}]];
        }
    }
    
    if (_urlRequirements.cancelCallbackRequired) {
        if (request.cancelCallback == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": VFXCallbackUrlXCancel}]];
        }
    }
    
    for (NSString *parameter in _urlRequirements.requiredParameters) {
        if (request.parameters[parameter] == nil) {
            [errors addObject:[NSError errorWithDomain:VFXCallbackUrlErrorDomain
                                                  code:VFXCallbackUrlErrorMissingParameter userInfo:@{@"parameter": parameter}]];
        }
    }
    
    _processingBlock(request, [NSArray arrayWithArray:errors]);
}

@end
