#import "MainView.h"

@implementation MainView {
    UIScrollView *_scrollView;
    
    UILabel *_urlLabel;
    UITextView * _urlTextView;
    
    UIButton *_urlEditorButton;
    UIButton *_sendButton;
    
    UILabel *_responseLabel;
    UITextView *_responseTextView;
}

- (instancetype)init {
    self = [super init];
    
    _scrollView = [UIScrollView new];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self addSubview:_scrollView];
    
    UILabel *(^addLabel)(NSString *) = ^ UILabel *(NSString *text) {
        UILabel *label = [UILabel new];
        label.text = text;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [_scrollView addSubview:label];
        return label;
    };
    
    UITextView *(^addTextView)(BOOL) = ^ UITextView *(BOOL editable) {
        UITextView *textView = [UITextView new];
        textView.backgroundColor = [UIColor lightGrayColor];
        textView.editable = editable;
        textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [_scrollView addSubview:textView];
        return textView;
    };
    
    UIButton *(^addButton)(NSString *, SEL) = ^ UIButton *(NSString *title, SEL action) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        return button;
    };
    
    _urlLabel = addLabel(@"URL");
    _urlTextView = addTextView(YES);
    _urlEditorButton = addButton(@"Editor", @selector(editorButtonTap:));
    _sendButton = addButton(@"Send", @selector(sendButtonTap:));
    _responseLabel = addLabel(@"Response");
    _responseTextView = addTextView(NO);
    
    return self;
}

- (NSURL *)url {
    if (_urlTextView.text.length > 0) {
        return [NSURL URLWithString:_urlTextView.text];
    }
    return nil;
}

- (void)setUrl:(NSURL *)url {
    _urlTextView.text = [url absoluteString];
}

- (NSURL *)response {
    if (_responseTextView.text.length > 0) {
        return [NSURL URLWithString:_responseTextView.text];
    }
    return nil;
}

- (void)setResponse:(NSURL *)response {
    _responseTextView.text = [response absoluteString];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    
    CGFloat padding = 20;
    
    void(^layoutLabel)(UILabel *, CGFloat) = ^ (UILabel *label, CGFloat y) {
        [label sizeToFit];
        label.frame = CGRectMake(padding, y, CGRectGetWidth(_scrollView.frame) - 2 * padding, CGRectGetHeight(label.frame));
    };
    
    layoutLabel(_urlLabel, padding);
    
    _urlTextView.frame = CGRectMake(padding, CGRectGetMaxY(_urlLabel.frame) + padding,
                                    CGRectGetWidth(_scrollView.frame) - 2 * padding, 100);
    
    [_urlEditorButton sizeToFit];
    _urlEditorButton.frame = CGRectMake(padding, CGRectGetMaxY(_urlTextView.frame) + padding / 2,
                                        CGRectGetWidth(_urlEditorButton.frame), 44);
    
    [_sendButton sizeToFit];
    _sendButton.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) - CGRectGetWidth(_sendButton.frame) - padding,
                                   CGRectGetMinY(_urlEditorButton.frame),
                                   CGRectGetWidth(_sendButton.frame), 44);
    
    layoutLabel(_responseLabel, CGRectGetMaxY(_urlEditorButton.frame) + 2 * padding);
    
    {
        CGFloat y = CGRectGetMaxY(_responseLabel.frame) + padding;
        CGFloat h = CGRectGetHeight(_scrollView.frame) - y - padding - _scrollView.contentInset.top;
        _responseTextView.frame = CGRectMake(padding, y,
                                             CGRectGetWidth(_scrollView.frame) - 2 * padding,
                                             h);
    }
}

#pragma mark button actions

- (void)editorButtonTap:(id)sender {
    [self.delegate mainViewEditorOptionAction:self];
}

- (void)sendButtonTap:(id)sender {
    [self.delegate mainViewSendOptionAction:self];
}

@end
