/*
 
 Copyright 2013 Valery Fomenko
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import "VFKeyboardObserver.h"

VFKeyboardProperties VFKeyboardPropertiesMake(CGRect frame,
                                              NSTimeInterval animationDuration,
                                              UIViewAnimationCurve animationCurve);

CGRect KeyboardFrameInWindowCoordinatesConsideringOrientation(CGRect keyboardFrame);
CGRect ViewFrameInWindowCoordinates(UIView *view);

@implementation VFKeyboardObserver {
    NSHashTable *_delegates;
    BOOL _interfaceOrientationWillChange;
}

+ (instancetype)sharedKeyboardObserver {
    static VFKeyboardObserver *sharedKeyboardObserver;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedKeyboardObserver = [VFKeyboardObserver new];
    });
    return sharedKeyboardObserver;
}

- (instancetype)init {
    self = [super init];
    _delegates = [NSHashTable weakObjectsHashTable];
    return self;
}

- (void)start {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

- (void)dealloc {
    [self stop];
}

- (void)stop {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addDelegate:(id<VFKeyboardObserverDelegate>)delegate {
    [_delegates addObject:delegate];
}

- (void)removeDelegate:(id<VFKeyboardObserverDelegate>)delegate {
    [_delegates removeObject:delegate];
}

- (void)interfaceOrientationWillChange {
    if (self.keyboardXShow) {
        _interfaceOrientationWillChange = YES;
    }
}

- (void)animateWithKeyboardProperties:(void(^)())animations {
    [self animateWithKeyboardProperties:animations completion:nil];
}

- (void)animateWithKeyboardProperties:(void(^)())animations completion:(void (^)(BOOL finished))completion {
    if (_interfaceOrientationWillChange) {
        if (animations) {animations();}
        if (completion) {completion(YES);}
        
    } else {
        
        [UIView animateWithDuration:_lastKeyboardProperties.animationDuration
                              delay:0.0
                            options:_lastKeyboardProperties.animationCurve << 16
                         animations:animations completion:completion];
    }
}

- (CGRect)keyboardFrameInViewCoordinates:(UIView *)view {
    if (self.keyboardXHide) {
        return CGRectZero;
    }
    
    CGRect viewFrameInWindowCoordinates = ViewFrameInWindowCoordinates(view);
    
    CGRect keyboardFrame = self.lastKeyboardProperties.frame;
    
    CGFloat keyboardHeightInViewCoordinates = MAX(0, CGRectGetMaxY(viewFrameInWindowCoordinates) - keyboardFrame.origin.y);
    
    return CGRectMake(keyboardFrame.origin.x, view.bounds.size.height - keyboardHeightInViewCoordinates, keyboardFrame.size.width, keyboardHeightInViewCoordinates);
}

- (BOOL)keyboardXShow {
    return _keyboardWillShow || _keyboardDidShow;
}

- (BOOL)keyboardXHide {
    return _keyboardWillHide || _keyboardDidHide;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self setKeyboardWillShow:YES];
    [self updateKeyboardPropertiesWithNotification:notification];
    [self notifyKeyboardWillShow];
    
    if (_interfaceOrientationWillChange) {
        _interfaceOrientationWillChange = NO;
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    [self setKeyboardDidShow:YES];
    [self notifyKeyboardDidShow];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (_interfaceOrientationWillChange) {
        return;
    }
    
    [self setKeyboardWillHide:YES];
    [self updateKeyboardPropertiesWithNotification:notification];
    [self notifyKeyboardWillHide];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    if (_interfaceOrientationWillChange) {
        return;
    }
    
    [self setKeyboardDidHide:YES];
    [self notifyKeyboardDidHide];
}

- (void)setKeyboardWillShow:(BOOL)keyboardWillShow {
    _keyboardWillShow = keyboardWillShow;
    
    if (_keyboardWillShow) {
        _keyboardDidHide = NO;
    }
}

- (void)setKeyboardDidShow:(BOOL)keyboardDidShow {
    _keyboardDidShow = keyboardDidShow;
    
    if (_keyboardDidShow) {
        _keyboardWillShow = NO;
    }
}

- (void)setKeyboardWillHide:(BOOL)keyboardWillHide {
    _keyboardWillHide = keyboardWillHide;
    
    if (_keyboardWillHide) {
        _keyboardDidShow = NO;
    }
}

- (void)setKeyboardDidHide:(BOOL)keyboardDidHide {
    _keyboardDidHide = keyboardDidHide;
    
    if (_keyboardDidHide) {
        _keyboardWillHide = NO;
    }
}

- (void)notifyKeyboardWillShow {
    for (id<VFKeyboardObserverDelegate> delegate in [_delegates allObjects]) {
        if ([delegate respondsToSelector:@selector(keyboardObserver:keyboardWillShowWithProperties:interfaceOrientationWillChange:)]) {
            [delegate keyboardObserver:self keyboardWillShowWithProperties:_lastKeyboardProperties interfaceOrientationWillChange:_interfaceOrientationWillChange];
        }
    }
}

- (void)notifyKeyboardDidShow {
    for (id<VFKeyboardObserverDelegate> delegate in [_delegates allObjects]) {
        if ([delegate respondsToSelector:@selector(keyboardObserver:keyboardDidShowWithProperties:)]) {
            [delegate keyboardObserver:self keyboardDidShowWithProperties:_lastKeyboardProperties];
        }
    }
}

- (void)notifyKeyboardWillHide {
    for (id<VFKeyboardObserverDelegate> delegate in [_delegates allObjects]) {
        if ([delegate respondsToSelector:@selector(keyboardObserver:keyboardWillHideWithProperties:)]) {
            [delegate keyboardObserver:self keyboardWillHideWithProperties:_lastKeyboardProperties];
        }
    }
}

- (void)notifyKeyboardDidHide {
    for (id<VFKeyboardObserverDelegate> delegate in [_delegates allObjects]) {
        if ([delegate respondsToSelector:@selector(keyboardObserver:keyboardDidHideWithProperties:)]) {
            [delegate keyboardObserver:self keyboardDidHideWithProperties:_lastKeyboardProperties];
        }
    }
}

- (void)updateKeyboardPropertiesWithNotification:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    frame = KeyboardFrameInWindowCoordinatesConsideringOrientation(frame);
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    _lastKeyboardProperties = VFKeyboardPropertiesMake(frame, animationDuration, animationCurve);
}

@end

VFKeyboardProperties VFKeyboardPropertiesMake(CGRect frame,
                                              NSTimeInterval animationDuration,
                                              UIViewAnimationCurve animationCurve) {
    VFKeyboardProperties keyboardProperties;
    keyboardProperties.frame = frame;
    keyboardProperties.animationDuration = animationDuration;
    keyboardProperties.animationCurve = animationCurve;
    return keyboardProperties;
}

NSString *NSStringFromVFKeyboardProperties(VFKeyboardProperties keyboardProperties) {
    return [NSString stringWithFormat:@"VFKeyboardProperties (frame: %@; animationDuration:%f; animationCurve:%d)",
            NSStringFromCGRect(keyboardProperties.frame),
            keyboardProperties.animationDuration,
            keyboardProperties.animationCurve];
}

CGRect KeyboardFrameInWindowCoordinatesConsideringOrientation(CGRect keyboardFrame) {
    CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait: {
            return keyboardFrame;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return CGRectMake(keyboardFrame.origin.y, keyboardFrame.origin.x, keyboardFrame.size.height, keyboardFrame.size.width);
        }
        case UIInterfaceOrientationLandscapeRight: {
            return CGRectMake(keyboardFrame.origin.y, windowBounds.size.width - keyboardFrame.size.width, keyboardFrame.size.height, keyboardFrame.size.width);
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            keyboardFrame.origin.y = windowBounds.size.height - keyboardFrame.size.height;
            return keyboardFrame;
        }
    }
}

CGRect ViewFrameInWindowCoordinates(UIView *view) {
    CGRect viewFrame = [view convertRect:view.bounds toView:nil];
    CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        viewFrame = CGRectMake(viewFrame.origin.y, viewFrame.origin.x, viewFrame.size.height, viewFrame.size.width);
    }
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationLandscapeLeft: {
            return viewFrame;
        }
        case UIInterfaceOrientationLandscapeRight: {
            viewFrame.origin.y = windowBounds.size.width - viewFrame.origin.y - viewFrame.size.height;
            return viewFrame;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            viewFrame.origin.y = windowBounds.size.height - viewFrame.origin.y - viewFrame.size.height;
            return viewFrame;
        }
    }
}