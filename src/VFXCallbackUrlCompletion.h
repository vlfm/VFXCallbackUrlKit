#import <Foundation/Foundation.h>

@interface VFXCallbackUrlCompletion : NSObject

@property (nonatomic, copy, readonly) NSString *successCallback;
@property (nonatomic, copy, readonly) NSString *errorCallback;
@property (nonatomic, copy, readonly) NSString *cancelCallback;

- (instancetype)initWithSuccessCallback:(NSString *)successCallback
                          errorCallback:(NSString *)errorCallback
                         cancelCallback:(NSString *)cancelCallback;

- (BOOL)callSuccessWithParameters:(NSDictionary *)parameters;
- (BOOL)callErrorWithParameters:(NSDictionary *)parameters;
- (BOOL)callCancelWithParameters:(NSDictionary *)parameters;

@end
