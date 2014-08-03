#import <UIKit/UIKit.h>

#import "VFKeyboardObserver.h"

@interface UrlBuilderView : UIView <VFKeyboardObserverDelegate>

@property (nonatomic) NSURL *url;

@end
