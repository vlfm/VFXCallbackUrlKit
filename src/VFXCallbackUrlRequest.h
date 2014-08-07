#import <Foundation/Foundation.h>

@interface VFXCallbackUrlRequest : NSObject

@property (nonatomic, copy, readonly) NSURL *asUrl;

@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSString *action;
@property (nonatomic, copy, readonly) NSDictionary *parameters;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *successCallback;
@property (nonatomic, copy, readonly) NSString *errorCallback;
@property (nonatomic, copy, readonly) NSString *cancelCallback;

+ (instancetype)requestWithScheme:(NSString *)scheme
                           action:(NSString *)action
                       parameters:(NSDictionary *)parameters
                           source:(NSString *)source
                  successCallback:(NSString *)successCallback
                    errorCallback:(NSString *)errorCallback
                   cancelCallback:(NSString *)cancelCallback;

+ (instancetype)requestFromUrl:(NSURL *)url;

+ (NSString *)getActionFromUrl:(NSURL *)url;
+ (NSString *)formatEncodedQueryStringWithParameters:(NSDictionary *)parameters;

- (BOOL)callSuccessWithParameters:(NSDictionary *)parameters;
- (BOOL)callErrorWithParameters:(NSDictionary *)parameters;
- (BOOL)callCancelWithParameters:(NSDictionary *)parameters;

@end
