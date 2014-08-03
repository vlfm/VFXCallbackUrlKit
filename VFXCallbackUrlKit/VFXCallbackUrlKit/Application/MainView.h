#import <UIKit/UIKit.h>

@class MainView;
@protocol MainViewDelegate<NSObject>

- (void)mainViewEditorOptionAction:(MainView *)view;
- (void)mainViewSendOptionAction:(MainView *)view;

@end

@interface MainView : UIView

@property (nonatomic, weak) id<MainViewDelegate> delegate;
@property (nonatomic) NSURL *url;

@end
