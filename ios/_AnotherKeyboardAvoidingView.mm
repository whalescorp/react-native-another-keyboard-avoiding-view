//
//  _AnotherKeyboardAvoidingView.m
//  react-native-another-keyboard-avoiding-view
//
//  Created by Anton Spivak on 26.04.2023.
//

#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#endif

#import "_AnotherKeyboardAvoidingView.h"

BOOL UIEdgeInsetsEqualToEdgeInsetsWithThreshold(UIEdgeInsets lhs, UIEdgeInsets rhs, CGFloat threshold) {
    return
    ABS(lhs.left - rhs.left) <= threshold && ABS(lhs.right - rhs.right) <= threshold &&
    ABS(lhs.top - rhs.top) <= threshold && ABS(lhs.bottom - rhs.bottom) <= threshold;
}

@interface _AnotherKeyboardAvoidingLayer : CALayer

@property (nonatomic) CGFloat inset;

@end

//
// _AnotherKeyboardAvoidingView
//

@interface _AnotherKeyboardAvoidingView ()

@property (nonatomic, assign) CGRect currentKeyboardFrame;
@property (nonatomic, assign, getter=isKeyboardHeightLayoutNeeded) BOOL keyboardHeightLayoutNeeded;

@end

@implementation _AnotherKeyboardAvoidingView

+ (Class)layerClass {
    return [_AnotherKeyboardAvoidingLayer self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _keyboardListeningEnabled = YES;
        _keyboardHeightLayoutNeeded = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(UIKeyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(UIKeyboardWillChangeFrameNotification:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(UIKeyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.isKeyboardHeightLayoutNeeded) {
        return;
    }
    
    [self layoutSubviewsDependingCurrentKeyboardHeight];
}

- (void)setNeedsKeyboardHeightLayout {
    self.keyboardHeightLayoutNeeded = YES;
    [self setNeedsLayout];
}

#pragma mark -

- (void)layoutSubviewsDependingCurrentKeyboardHeight {
    self.keyboardHeightLayoutNeeded = NO;
    
    CGRect rect = [[self superview] convertRect:[self frame] toView:self.window];
    CGRect intersection = CGRectIntersection(self.currentKeyboardFrame, rect);
    
    CGFloat offset = CGRectGetHeight(intersection);
    ((_AnotherKeyboardAvoidingLayer *)self.layer).inset = offset;
}

- (void)_handleAnimationProgressWithKeyboardHeight:(CGFloat)keyboardHeight {
    [self.delegate _anotherKeyboardAvoidingView:self requiresUpdateBottomInset:keyboardHeight];
}

#pragma mark - Setters & Getters

- (void)setCurrentKeyboardFrame:(CGRect)currentKeyboardFrame {
    _currentKeyboardFrame = currentKeyboardFrame;
    
    if (!self.isKeyboardListeningEnabled) {
        return;
    }
    
    [self setNeedsKeyboardHeightLayout];
}

- (void)setKeyboardListeningEnabled:(BOOL)keyboardListeningEnabled {
    _keyboardListeningEnabled = keyboardListeningEnabled;
    
    if (self.window == nil) {
        return;
    }
    
    [UIView animateWithDuration:0.21 animations:^{
        [self layoutSubviewsDependingCurrentKeyboardHeight];
    }];
}

- (void)updateCurrentKeyboardFrame:(CGRect)currentKeyboardFrame
                        notifiction:(NSNotification *)notification
{
    self.currentKeyboardFrame = currentKeyboardFrame;
    
    NSTimeInterval duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    __auto_type animations = ^{
        [self layoutSubviewsDependingCurrentKeyboardHeight];
    };
    
    UIViewAnimationOptions options = (curve << 16);
    options |= UIViewAnimationOptionBeginFromCurrentState;
    options |= UIViewAnimationOptionLayoutSubviews;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:animations
                     completion:nil];
}

#pragma mark - Observers

- (void)UIKeyboardWillShowNotification:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self updateCurrentKeyboardFrame:rect notifiction:notification];
}

- (void)UIKeyboardWillChangeFrameNotification:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self updateCurrentKeyboardFrame:rect notifiction:notification];
}

- (void)UIKeyboardWillHideNotification:(NSNotification *)notification {
    [self updateCurrentKeyboardFrame:CGRectZero notifiction:notification];
}

@end

//
// _AnotherKeyboardAvoidingLayer
//

@implementation _AnotherKeyboardAvoidingLayer

@dynamic inset;

- (id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[_AnotherKeyboardAvoidingLayer class]]) {
            self.inset = ((_AnotherKeyboardAvoidingLayer *)layer).inset;
        }
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([self isCustomAnimationKey:key]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

+ (BOOL)isCustomAnimationKey:(NSString *)key {
    return [key isEqualToString:@"inset"];
}

- (void)display {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [super display];
    
    if ([self presentationLayer] != nil) {
        [self displayUsingLayer:[self presentationLayer]];
    } else {
        [self displayUsingLayer:self];
    }
    
    [CATransaction commit];
}

- (void)displayUsingLayer:(_AnotherKeyboardAvoidingLayer *)layer {
    _AnotherKeyboardAvoidingView *view = (_AnotherKeyboardAvoidingView *)[self delegate];
    [view _handleAnimationProgressWithKeyboardHeight:layer.inset];
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if (![_AnotherKeyboardAvoidingLayer isCustomAnimationKey:event]) {
        return [super actionForKey:event];
    }
    
    return [self _action:^(CABasicAnimation *animation) {
        animation.keyPath = event;
        
        if ([self presentationLayer] != nil) {
            animation.fromValue = [[self presentationLayer] valueForKeyPath:event];
        } else {
            animation.fromValue = [self valueForKeyPath:event];
        }
        
        animation.toValue = nil;
    }];
}

- (id<CAAction> _Nullable)_action:(void(^)(CABasicAnimation * _Nullable))animation {
    if ([CATransaction disableActions]) {
        return nil;
    }
    
    NSObject<CAAction> *system = (NSObject<CAAction> *)[self actionForKey:@"backgroundColor"];
    SEL sel = NSSelectorFromString(@"_pendingAnimation");
    
    if ([system isKindOfClass:[CABasicAnimation class]]) {
        animation((CABasicAnimation *)system);
    } else if ([system respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        animation([system performSelector:sel]);
#pragma clang diagnostic pop
    } else {
        CABasicAnimation *value = [CABasicAnimation animationWithKeyPath:@""];
        value.duration = [UIView inheritedAnimationDuration];
        animation(value);
        system = value;
    }
    
    return system;
}

@end