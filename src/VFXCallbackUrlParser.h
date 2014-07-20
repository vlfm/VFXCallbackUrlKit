#import <Foundation/Foundation.h>

@interface VFXCallbackUrlParseResult : NSObject

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *action;
@property (nonatomic, copy, readonly) NSDictionary *parameters;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *successCallback;
@property (nonatomic, copy, readonly) NSString *errorCallback;
@property (nonatomic, copy, readonly) NSString *cancelCallback;

@end

@interface VFXCallbackUrlParser : NSObject

+ (VFXCallbackUrlParseResult *)parseUrl:(NSURL *)url;

+ (NSString *)formatEncodedQueryStringWithParameters:(NSDictionary *)parameters;

+ (NSString *)parseAction:(NSURL *)url;

@end
