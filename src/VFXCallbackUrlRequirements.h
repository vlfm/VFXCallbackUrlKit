#import <Foundation/Foundation.h>

@interface VFXCallbackUrlRequirements : NSObject

@property (nonatomic) BOOL sourceRequired;
@property (nonatomic) BOOL successCallbackRequired;
@property (nonatomic) BOOL errorCallbackRequired;
@property (nonatomic) BOOL cancelCallbackRequired;
@property (nonatomic) NSArray *requiredParameters;

@end