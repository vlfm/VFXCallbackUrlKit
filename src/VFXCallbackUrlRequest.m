#import "VFXCallbackUrlRequest.h"

#import "VFXCallbackUrl.h"

@implementation VFXCallbackUrlRequest

+ (instancetype)requestWithScheme:(NSString *)scheme
                           action:(NSString *)action
                       parameters:(NSDictionary *)parameters
                           source:(NSString *)source
                  successCallback:(NSString *)successCallback
                    errorCallback:(NSString *)errorCallback
                   cancelCallback:(NSString *)cancelCallback {
    
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest new];
    request->_scheme = scheme;
    request->_host = @"x-callback-url";
    request->_action = action;
    request->_parameters = parameters;
    request->_source = source;
    request->_successCallback = successCallback;
    request->_errorCallback = errorCallback;
    request->_cancelCallback = cancelCallback;
    return request;
}

+ (instancetype)requestFromUrl:(NSURL *)url {
    NSString *scheme = url.scheme;
    NSString *host = url.host;
    NSString *action = [self getActionFromUrl:url];
    
    NSDictionary *allParameters = [self parseQuery:url.query];
    
    NSString *source = allParameters[VFXCallbackUrlXSource];
    NSString *successCallback = allParameters[VFXCallbackUrlXSuccess];
    NSString *errorCallback = allParameters[VFXCallbackUrlXError];
    NSString *cancelCallback = allParameters[VFXCallbackUrlXCancel];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:allParameters];
    [parameters removeObjectsForKeys:@[VFXCallbackUrlXSource,
                                       VFXCallbackUrlXSuccess,
                                       VFXCallbackUrlXError,
                                       VFXCallbackUrlXCancel]];
    
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:scheme
                                                                       action:action
                                                                   parameters:[NSDictionary dictionaryWithDictionary:parameters]
                                                                       source:source
                                                              successCallback:successCallback
                                                                errorCallback:errorCallback
                                                               cancelCallback:cancelCallback];
    request->_host = host;
    
    return request;
}

- (NSURL *)asUrl {
    if (self.scheme.length == 0 || self.host.length == 0) {
        return nil;
    }
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    
    {
        void(^setQueryParameter)(NSString *, NSString *) = ^ (NSString *key, NSString *value) {
            if (key.length > 0 && value.length > 0) {
                [queryParameters setObject:value forKey:key];
            }
        };
        
        setQueryParameter(VFXCallbackUrlXSource, self.source);
        setQueryParameter(VFXCallbackUrlXSuccess, self.successCallback);
        setQueryParameter(VFXCallbackUrlXError, self.errorCallback);
        setQueryParameter(VFXCallbackUrlXCancel, self.cancelCallback);
    }
    
    NSString *query = [[self class] formatEncodedQueryStringWithParameters:queryParameters];
    
    if (self.action.length == 0 && query.length > 0) {
        return nil;
    }
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@://%@", self.scheme, self.host];
    
    {
        void(^appendString)(NSString *, NSString *) = ^ (NSString *prefix, NSString *part) {
            if (part.length > 0) {
                [string appendFormat:@"%@%@", prefix, part];
            }
        };
        
        appendString(@"/", self.action);
        appendString(@"?", query);
    }
    
    return [NSURL URLWithString:string];
}

+ (NSString *)getActionFromUrl:(NSURL *)url {
    return url.path.lastPathComponent;
}

#pragma mark query

+ (NSString *)formatEncodedQueryStringWithParameters:(NSDictionary *)parameters {
    NSMutableString *query = [NSMutableString stringWithString:@""];
    for (NSString *key in [parameters allKeys]) {
        NSString *value = parameters[key];
        if (query.length > 0) {
            [query appendString:@"&"];
        }
        [query appendString:[NSString stringWithFormat:@"%@=%@",
                             [self encodeString:key],
                             [self encodeString:value]]];
    }
    return query;
}

+ (NSDictionary *)parseQuery:(NSString *)query {
    NSArray *elements = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *element in elements) {
        NSArray *keyValue = [element componentsSeparatedByString:@"="];
        if (keyValue.count != 2) {
            continue;
        }
        dictionary[[self decodeString:keyValue[0]]] = [self decodeString:keyValue[1]];
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

#pragma mark encoding

+ (NSString *)encodeString:(NSString *)string {
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                  (__bridge CFStringRef)string,
                                                                                  NULL,
                                                                                  (CFStringRef) @"/%&=?$#+-~@<>|\\*,.()[]{}^!",
                                                                                  kCFStringEncodingUTF8);
}

+ (NSString *)decodeString:(NSString *)string {
    return (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                  (__bridge CFStringRef)string,
                                                                                                  CFSTR(""),
                                                                                                  kCFStringEncodingUTF8);
}

#pragma mark call completions

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
    
    NSString *queryString = [self formatEncodedQueryStringWithParameters:parameters];
    if (queryString.length > 0) {
        [urlString appendString:@"?"];
        [urlString appendString:queryString];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    return [[UIApplication sharedApplication] openURL:url];
}

@end
