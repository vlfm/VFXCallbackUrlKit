#import "VFXCallbackUrlCompletion.h"

#import "VFXCallbackUrlParser.h"

@implementation VFXCallbackUrlCompletion

- (instancetype)initWithSuccessCallback:(NSString *)successCallback
                          errorCallback:(NSString *)errorCallback
                         cancelCallback:(NSString *)cancelCallback {
    self = [super init];
    _successCallback = successCallback;
    _errorCallback = errorCallback;
    _cancelCallback = cancelCallback;
    return self;
}

- (BOOL)callSuccessWithParameters:(NSDictionary *)parameters {
    return [[self class] openUrlWithCallbackString:_successCallback parameters:parameters];
}

- (BOOL)callErrorWithParameters:(NSDictionary *)parameters {
    return [[self class] openUrlWithCallbackString:_errorCallback parameters:parameters];
}

- (BOOL)callCancelWithParameters:(NSDictionary *)parameters {
    return [[self class] openUrlWithCallbackString:_cancelCallback parameters:parameters];
}

+ (BOOL)openUrlWithCallbackString:(NSString *)callbackString parameters:(NSDictionary *)parameters {
    if (callbackString == nil) {
        return NO;
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:callbackString];
    
    NSString *queryString = [VFXCallbackUrlParser formatEncodedQueryStringWithParameters:parameters];
    if (queryString.length > 0) {
        [urlString appendString:@"?"];
        [urlString appendString:queryString];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    return [[UIApplication sharedApplication] openURL:url];
}

@end
