@class VFXCallbackUrlRequest;
@class VFXCallbackUrlRequirements;

extern NSString * const VFXCallbackUrlErrorDomain;

typedef NS_ENUM(NSInteger, VFXCallbackUrlError) {
    VFXCallbackUrlErrorUnknownAction,
    VFXCallbackUrlErrorMissingParameter
};

extern NSString * const VFXCallbackUrlNotification;

extern NSString * const VFXCallbackUrlXSource;
extern NSString * const VFXCallbackUrlXSuccess;
extern NSString * const VFXCallbackUrlXError;
extern NSString * const VFXCallbackUrlXCancel;

typedef void(^VFXCallbackUrlProcessingBlock)(VFXCallbackUrlRequest *request, NSArray *errors);
typedef void(^VFXCallbackUrlRequirementsSetBlock)(VFXCallbackUrlRequirements**);