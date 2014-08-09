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

#import <Foundation/Foundation.h>

struct VFKeyboardProperties {
    CGRect frame;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
};
typedef struct VFKeyboardProperties VFKeyboardProperties;

NSString *NSStringFromVFKeyboardProperties(VFKeyboardProperties keyboardProperties);

@protocol VFKeyboardObserverDelegate;

@interface VFKeyboardObserver : NSObject

@property (nonatomic, readonly) BOOL keyboardWillShow;
@property (nonatomic, readonly) BOOL keyboardDidShow;
@property (nonatomic, readonly) BOOL keyboardWillHide;
@property (nonatomic, readonly) BOOL keyboardDidHide;

@property (nonatomic, readonly) BOOL keyboardXShow;
@property (nonatomic, readonly) BOOL keyboardXHide;

@property (nonatomic) VFKeyboardProperties lastKeyboardProperties;

+ (instancetype)sharedKeyboardObserver;
- (void)start;
- (void)stop;

- (void)addDelegate:(id<VFKeyboardObserverDelegate>)delegate;
- (void)removeDelegate:(id<VFKeyboardObserverDelegate>)delegate;

/* notify VFKeyboardObserver that interface orientation will change
   call this method from UIViewController willRotateToInterfaceOrientation:duration: */
- (void)interfaceOrientationWillChange;

/* these methods have convenience behavior
   when interface orientation changes (see interfaceOrientationWillChange method),
   animation and completion blocks will be performed without animation
   and will not interfere with rotation animation */
- (void)animateWithKeyboardProperties:(void(^)())animations;
- (void)animateWithKeyboardProperties:(void(^)())animations completion:(void (^)(BOOL finished))completion;

/* If keyboard visible (in will- or did- show state), returns keyboard frame converted to view coordinates,
   otherwise returns zero rect */
- (CGRect)keyboardFrameInViewCoordinates:(UIView *)view;

@end

@protocol VFKeyboardObserverDelegate <NSObject>

@optional

- (void)keyboardObserver:(VFKeyboardObserver *)keyboardObserver keyboardWillShowWithProperties:(VFKeyboardProperties)keyboardProperties interfaceOrientationWillChange:(BOOL)interfaceOrientationWillChange;
- (void)keyboardObserver:(VFKeyboardObserver *)keyboardObserver keyboardDidShowWithProperties:(VFKeyboardProperties)keyboardProperties;

- (void)keyboardObserver:(VFKeyboardObserver *)keyboardObserver keyboardWillHideWithProperties:(VFKeyboardProperties)keyboardProperties;
- (void)keyboardObserver:(VFKeyboardObserver *)keyboardObserver keyboardDidHideWithProperties:(VFKeyboardProperties)keyboardProperties;

@end
