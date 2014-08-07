#import "MainViewController.h"

#import "MainView.h"
#import "UrlBuilderViewController.h"
#import "VFXCallbackUrl.h"
#import "VFXCallbackUrlRequest.h"

@interface MainViewController () <MainViewDelegate>

@end

@implementation MainViewController {
    MainView *_view;
    UrlBuilderViewController *_editorVc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xCallbackUrlNotification:)
                                                 name:VFXCallbackUrlNotification object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    _view = [MainView new];
    _view.delegate = self;
    self.view = _view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark MainViewDelegate

- (void)mainViewEditorOptionAction:(MainView *)view {
    _editorVc = [UrlBuilderViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:_editorVc];
    
    _editorVc.url = _view.url;
    
    _editorVc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                         target:self action:@selector(editorDone:)];
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)mainViewSendOptionAction:(MainView *)view {
    NSURL *url = view.url;
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Cannot open url"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark UrlBuilderViewController done

- (void)editorDone:(id)sender {
    _view.url = _editorVc.url;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    _editorVc = nil;
}

#pragma mark x-callback-url notification

- (void)xCallbackUrlNotification:(NSNotification *)n {
    VFXCallbackUrlRequest *request = n.object;
    _view.response = request.asUrl;
}

@end
