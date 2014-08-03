#import <Foundation/Foundation.h>

@class VFXCallbackUrlCompletion;

@interface VFXCallbackUrlRequest : NSObject

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSString *action;
@property (nonatomic, copy, readonly) NSDictionary *parameters;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *successCallback;
@property (nonatomic, copy, readonly) NSString *errorCallback;
@property (nonatomic, copy, readonly) NSString *cancelCallback;

- (BOOL)callSuccessWithParameters:(NSDictionary *)parameters;
- (BOOL)callErrorWithParameters:(NSDictionary *)parameters;
- (BOOL)callCancelWithParameters:(NSDictionary *)parameters;

@end
