#import "UrlBuilderView.h"

#import "VFXCallbackUrlRequest.h"

@interface LabeledTextField : UITextField

@property (nonatomic, strong, readonly) UILabel *label;
- (instancetype)initWithLabel:(NSString *)label;

@end

@implementation UrlBuilderView {
    UIScrollView *_scrollView;
    LabeledTextField *_schemeTF;
    LabeledTextField *_hostTF;
    LabeledTextField *_actionTF;
    LabeledTextField *_actionParametersTF;
    LabeledTextField *_sourceTF;
    LabeledTextField *_successCallbackTF;
    LabeledTextField *_errorCallbackTF;
    LabeledTextField *_cancelCallbackTF;
}

- (instancetype)init {
    self = [super init];
    
    _scrollView = [UIScrollView new];
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self addSubview:_scrollView];
    
    LabeledTextField *(^addTextField)(NSString *, NSString *) = ^ LabeledTextField * (NSString *label,
                                                                                      NSString *text) {
        LabeledTextField *tf = [[LabeledTextField alloc] initWithLabel:label];
        tf.backgroundColor = [UIColor lightGrayColor];
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        tf.text = text;
        [_scrollView addSubview:tf];
        [_scrollView addSubview:tf.label];
        return tf;
    };
    
    _schemeTF = addTextField(@"Scheme", @"");
    _hostTF = addTextField(@"Host", @"x-callback-url");
    _actionTF = addTextField(@"Action", @"");
    _actionParametersTF = addTextField(@"Action Parameters", @"");
    _sourceTF = addTextField(@"X-Source", @"VFXCallbackUrlKit");
    _successCallbackTF = addTextField(@"X-Success", @"vf-x-callbackurl-kit://x-callback-url/");
    _errorCallbackTF = addTextField(@"X-Error", @"vf-x-callbackurl-kit://x-callback-url/");
    _cancelCallbackTF = addTextField(@"X-Cancel", @"vf-x-callbackurl-kit://x-callback-url/");
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (NSURL *)url {
    NSMutableString * string = [NSMutableString new];
    
    BOOL (^append1)(UITextField *, NSString *) = ^ BOOL (UITextField *textField,
                                                         NSString *suffix) {
        if (textField.text.length > 0) {
            [string appendString:textField.text];
            [string appendString:suffix];
            return YES;
        }
        return NO;
    };
    
    BOOL (^append2)(NSString *, UITextField *, NSString *) = ^ BOOL (NSString *prefix,
                                                                     UITextField *textField,
                                                                     NSString *suffix) {
        if (textField.text.length > 0) {
            [string appendString:prefix];
            [string appendString:textField.text];
            [string appendString:suffix];
            return YES;
        }
        return NO;
    };
    
    // very simple url building
    // may require some manual fixing
    
    append1(_schemeTF, @"://");
    append1(_hostTF, @"/");
    append1(_actionTF, @"?");
    append1(_actionParametersTF, @"&");
    append2(@"x-source=", _sourceTF, @"&");
    append2(@"x-success=", _successCallbackTF, @"&");
    append2(@"x-error=", _errorCallbackTF, @"&");
    append2(@"x-cancel=",_cancelCallbackTF, @"&");
    
    return [NSURL URLWithString:string];
}

- (void)setUrl:(NSURL *)url {
    if (url.absoluteString.length == 0) {
        return;
    }
    
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestFromUrl:url];
    
    _schemeTF.text = request.scheme;
    _hostTF.text = request.host;
    _actionTF.text = request.action;
    _actionParametersTF.text = [VFXCallbackUrlRequest formatEncodedQueryStringWithParameters:request.parameters];
    _sourceTF.text = request.source;
    _successCallbackTF.text = request.successCallback;
    _errorCallbackTF.text = request.errorCallback;
    _cancelCallbackTF.text = request.cancelCallback;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    
    CGFloat space = 20;
    
    void(^layoutTextField)(LabeledTextField *, CGFloat*) = ^ (LabeledTextField *tf, CGFloat *y) {
        [tf.label sizeToFit];
        
        *y += space;
        
        CGFloat maxWidth = CGRectGetWidth(self.bounds) - 2 * space;
        
        tf.label.frame = CGRectMake(space, *y, MIN(maxWidth, CGRectGetWidth(tf.label.frame)), CGRectGetHeight(tf.label.frame));
        *y += CGRectGetHeight(tf.label.frame) + 10;
        
        tf.frame = CGRectMake(space, *y, CGRectGetWidth(self.bounds) - 2 * space, 44);
        *y += CGRectGetHeight(tf.frame);
    };
    
    CGFloat y = 0;
    
    layoutTextField(_schemeTF, &y);
    layoutTextField(_hostTF, &y);
    layoutTextField(_actionTF, &y);
    layoutTextField(_actionParametersTF, &y);
    layoutTextField(_sourceTF, &y);
    layoutTextField(_successCallbackTF, &y);
    layoutTextField(_errorCallbackTF, &y);
    layoutTextField(_cancelCallbackTF, &y);
    
    y += space;
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), y);
}

#pragma mark VFKeyboardObserverDelegate

- (void)keyboardObserver:(VFKeyboardObserver *)keyboardObserver keyboardWillShowWithProperties:(VFKeyboardProperties)keyboardProperties interfaceOrientationWillChange:(BOOL)interfaceOrientationWillChange {
    
    [keyboardObserver animateWithKeyboardProperties:^{
        UIEdgeInsets contentInset = _scrollView.contentInset;
        contentInset.bottom = keyboardProperties.frame.size.height;
        _scrollView.contentInset = contentInset;
    }];
}

- (void)keyboardObserver:(VFKeyboardObserver *)keyboardObserver keyboardWillHideWithProperties:(VFKeyboardProperties)keyboardProperties {
    [keyboardObserver animateWithKeyboardProperties:^{
        UIEdgeInsets contentInset = _scrollView.contentInset;
        contentInset.bottom = 0;
        _scrollView.contentInset = contentInset;
    }];
}

@end

@implementation LabeledTextField

- (instancetype)initWithLabel:(NSString *)label {
    self = [super init];
    
    _label = [UILabel new];
    _label.text = label;
    
    return self;
}

@end