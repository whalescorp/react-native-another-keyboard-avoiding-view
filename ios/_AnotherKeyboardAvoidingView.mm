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
#import <objc/runtime.h>

//
// isAnimationsDisabled
//

static BOOL isAnimationsDisabled() {
    return [NSProcessInfo processInfo].isLowPowerModeEnabled;
}

//
// swizzleUIScrollView
//

static void swizzleUIScrollView(SEL osel, SEL ssel) {
    Class klass = [UIScrollView class];
    
    Method om = class_getInstanceMethod(klass, osel);
    Method sm = class_getInstanceMethod(klass, ssel);

    IMP oimp = method_getImplementation(om);
    IMP simp = method_getImplementation(sm);

    class_replaceMethod(klass,
                        ssel,
                        oimp,
                        method_getTypeEncoding(om));
    
    class_replaceMethod(klass,
                        osel,
                        simp,
                        method_getTypeEncoding(sm));
}

//
// UIScrollView (_AnotherKeyboardAvoidingView)
//

@interface UIScrollView (_AnotherKeyboardAvoidingView)

@property (nonatomic, assign, setter=akav_setKeyboardAdjustmentsBlocked:) BOOL akav_keyboardAdjustmentsBlocked;

@end

@implementation UIScrollView (_AnotherKeyboardAvoidingView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleUIScrollView(@selector(setBounds:),
                            @selector(akav_setBounds:));
        
        swizzleUIScrollView(NSSelectorFromString(@"_systemContentInset"),
                            @selector(akav_systemContentInset));
    });
}

- (void)akav_setBounds:(CGRect)bounds {
    CGRect _bounds = bounds;
    if ([self akav_keyboardAdjustmentsBlocked]) {
        _bounds.origin = [self bounds].origin;
    }
    [self akav_setBounds:_bounds];
}

// https://github.com/WebKit/WebKit/blob/3b9112ff64a6aa1c0daf62390d1646bcc36b488b/Source/WebKit/UIProcess/ios/WKScrollView.mm#L440
- (UIEdgeInsets)akav_systemContentInset {
    if ([self akav_keyboardAdjustmentsBlocked]) {
        [self setValue:@(0.0) forKey:@"_keyboardBottomInsetAdjustment"];
    }
    
    UIEdgeInsets _systemContentInset = [self akav_systemContentInset];
    return _systemContentInset;
}

#pragma mark - Setters & Getters

- (BOOL)akav_keyboardAdjustmentsBlocked {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number == nil ? NO : [number boolValue];
}

- (void)akav_setKeyboardAdjustmentsBlocked:(BOOL)akav_keyboardAdjustmentsBlocked {
    objc_setAssociatedObject(self,
                             @selector(akav_keyboardAdjustmentsBlocked),
                             @(akav_keyboardAdjustmentsBlocked),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

//
// UIEdgeInsetsEqualToEdgeInsetsWithThreshold
//

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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate _anotherKeyboardAvoidingView:self requiresUpdateBottomInset:keyboardHeight];
    });
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
    
    __auto_type animations = ^{
        [self layoutSubviewsDependingCurrentKeyboardHeight];
    };
    
    UIScrollView *nestedScrollView = [self _nestedWKWebViewScrollView];
    nestedScrollView.akav_keyboardAdjustmentsBlocked = YES;
    
    __auto_type completion = ^{
        nestedScrollView.akav_keyboardAdjustmentsBlocked = NO;
    };
    
    if (isAnimationsDisabled()) {
        [UIView performWithoutAnimation:animations];
        dispatch_async(dispatch_get_main_queue(), completion);
        return;
    }
    
    NSTimeInterval duration = 0.21;
    [UIView animateWithDuration:duration animations:animations completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   completion);
}

- (void)updateCurrentKeyboardFrame:(CGRect)currentKeyboardFrame
                        notifiction:(NSNotification *)notification
{
    self.currentKeyboardFrame = currentKeyboardFrame;
    
    NSTimeInterval duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    __auto_type animations = ^{
        self.alpha = 0.98; // This one helps to get complaetion block fired at expectd time;
        [self layoutSubviewsDependingCurrentKeyboardHeight];
    };
    
    UIScrollView *nestedScrollView = [self _nestedWKWebViewScrollView];
    nestedScrollView.akav_keyboardAdjustmentsBlocked = YES;
    
    __auto_type completion = ^{
        nestedScrollView.akav_keyboardAdjustmentsBlocked = NO;
    };
    
    UIViewAnimationOptions options = (curve << 16);
    options |= UIViewAnimationOptionBeginFromCurrentState;
    options |= UIViewAnimationOptionLayoutSubviews;
    
    if (isAnimationsDisabled()) {
        [UIView performWithoutAnimation:animations];
        dispatch_async(dispatch_get_main_queue(), completion);
        return;
    }
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:animations
                     completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   completion);
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

#pragma mark - Helpers

- (UIScrollView * _Nullable)_nestedWKWebViewScrollView {
    __block UIScrollView *scrollView = nil;
    __auto_type extract = ^UIScrollView * (UIView *obj) {
        // RNCWebView -> RCNWebViewImpl -> WKWebView
        UIView *view = [[[[obj subviews] firstObject] subviews] firstObject];
        if ([view isKindOfClass:NSClassFromString(@"WKWebView")]) {
            return (UIScrollView *)[[view subviews] firstObject];
        }
        return nil;
    };
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([NSStringFromClass([obj class]) containsString:@"WebView"]) {
            scrollView = extract(obj);
            *stop = YES;
        } else {
            UIView *subview = [[obj subviews] firstObject];
            if ([NSStringFromClass([subview class]) containsString:@"WebView"]) {
                scrollView = extract(subview);
                *stop = YES;
            }
        }
    }];
    
    return scrollView;
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
    if ([CATransaction disableActions] || isAnimationsDisabled()) {
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
