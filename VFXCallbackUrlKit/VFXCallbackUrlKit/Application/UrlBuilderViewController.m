#import "UrlBuilderViewController.h"

#import "UrlBuilderView.h"
#import "VFKeyboardObserver.h"

@interface UrlBuilderViewController ()

@end

@implementation UrlBuilderViewController {
    UrlBuilderView *_view;
    NSURL *_tempUrl;
}

- (NSURL *)url {
    return _view.url;
}

- (void)setUrl:(NSURL *)url {
    _view.url = url;
    _tempUrl = url;
}

- (void)loadView {
    _view = [UrlBuilderView new];
    self.view = _view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _view.url = _tempUrl;
    _tempUrl = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[VFKeyboardObserver sharedKeyboardObserver] addDelegate:_view];
    [[VFKeyboardObserver sharedKeyboardObserver] start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[VFKeyboardObserver sharedKeyboardObserver] stop];
    [[VFKeyboardObserver sharedKeyboardObserver] removeDelegate:_view];
}

@end
