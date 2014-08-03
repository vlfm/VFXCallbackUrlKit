#import "VFXCallbackUrlParser.h"

#import "VFXCallbackUrl.h"

@interface VFXCallbackUrlParseResult()

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *successCallback;
@property (nonatomic, copy) NSString *errorCallback;
@property (nonatomic, copy) NSString *cancelCallback;

@end

@implementation VFXCallbackUrlParser

+ (VFXCallbackUrlParseResult *)parseUrl:(NSURL *)url {
    VFXCallbackUrlParseResult *result = [VFXCallbackUrlParseResult new];
    result.url = url;
    result.scheme = url.scheme;
    result.host = url.host;
    result.action = [self parseAction:url];
    
    NSDictionary *allParameters = [self parseQuery:url.query];
    
    {
        result.source = allParameters[VFXCallbackUrlXSource];
        result.successCallback = allParameters[VFXCallbackUrlXSuccess];
        result.errorCallback = allParameters[VFXCallbackUrlXError];
        result.cancelCallback = allParameters[VFXCallbackUrlXCancel];
    }
    
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:allParameters];
        [parameters removeObjectsForKeys:@[VFXCallbackUrlXSource,
                                           VFXCallbackUrlXSuccess,
                                           VFXCallbackUrlXError,
                                           VFXCallbackUrlXCancel]];
        result.parameters = [NSDictionary dictionaryWithDictionary:parameters];
    }
    
    return result;
}

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

+ (NSString *)parseAction:(NSURL *)url {
    return url.path.lastPathComponent;
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

@end

@implementation VFXCallbackUrlParseResult

@end