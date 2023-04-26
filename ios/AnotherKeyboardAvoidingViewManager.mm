#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import <React/RCTShadowView.h>

#import <yoga/Yoga.h>

#import "_AnotherKeyboardAvoidingView.h"
#import "RCTBridge.h"

//
// AnotherKeyboardAvoidingViewLocalData
//

@interface AnotherKeyboardAvoidingViewLocalData : NSObject

@property (atomic, readonly) UIEdgeInsets insets;

@end

@implementation AnotherKeyboardAvoidingViewLocalData

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if (self) {
        _insets = insets;
    }
    return self;
}

@end

//
// AnotherKeyboardAvoidingViewShadowView
//

@interface AnotherKeyboardAvoidingViewShadowView : RCTShadowView

@end

@implementation AnotherKeyboardAvoidingViewShadowView

- (void)setLocalData:(AnotherKeyboardAvoidingViewLocalData *)localData
{
  RCTAssert([localData isKindOfClass:[AnotherKeyboardAvoidingViewLocalData class]],
      @"Local data object for `AnotherKeyboardAvoidingViewShadowView` must be `AnotherKeyboardAvoidingViewLocalData` instance.");

  UIEdgeInsets insets = localData.insets;

  super.paddingLeft = (YGValue) {
      (float)insets.left,
      YGUnitPoint
  };
    
  super.paddingRight = (YGValue) {
      (float)insets.right,
      YGUnitPoint
  };
    
  super.paddingTop = (YGValue) {
      (float)insets.top,
      YGUnitPoint
  };
    
  super.paddingBottom = (YGValue) {
      (float)insets.bottom,
      YGUnitPoint
  };

  [self didSetProps:@[@"paddingLeft", @"paddingRight", @"paddingTop", @"paddingBottom"]];
}

- (void)setPadding:(__unused YGValue)value {}
- (void)setPaddingLeft:(__unused YGValue)value {}
- (void)setPaddingRight:(__unused YGValue)value {}
- (void)setPaddingTop:(__unused YGValue)value {}
- (void)setPaddingBottom:(__unused YGValue)value {}

@end

//
// AnotherKeyboardAvoidingViewManager
//

@interface AnotherKeyboardAvoidingViewManager : RCTViewManager <_AnotherKeyboardAvoidingViewDelegate>

@property (nonatomic, assign) UIEdgeInsets additionalInsets;

@end

@implementation AnotherKeyboardAvoidingViewManager

RCT_EXPORT_MODULE(AnotherKeyboardAvoidingView)

- (_AnotherKeyboardAvoidingView *)view {
    _AnotherKeyboardAvoidingView *view = [[_AnotherKeyboardAvoidingView alloc] init];
    view.delegate = self;
    return view;
}

- (AnotherKeyboardAvoidingViewShadowView *)shadowView {
    return [AnotherKeyboardAvoidingViewShadowView new];
}

- (void)updateWithCurrentAdditionalInsetsWithView:(UIView *)view {
    AnotherKeyboardAvoidingViewLocalData *localData = [[AnotherKeyboardAvoidingViewLocalData alloc] initWithInsets:_additionalInsets];
    [self.bridge.uiManager setLocalData:localData forView:view];
}

RCT_CUSTOM_VIEW_PROPERTY(enabled, BOOL, _AnotherKeyboardAvoidingView) {
    view.keyboardListeningEnabled = [RCTConvert BOOL:json];
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

#pragma mark - _AnotherKeyboardAvoidingViewDelegate

- (void)_anotherKeyboardAvoidingView:(_AnotherKeyboardAvoidingView *)view
           requiresUpdateBottomInset:(CGFloat)inset
{
    UIEdgeInsets additionalInsets = UIEdgeInsetsZero;
    additionalInsets.bottom = RCTRoundPixelValue(inset);
    
    if (UIEdgeInsetsEqualToEdgeInsetsWithThreshold(additionalInsets, _additionalInsets, 1.0 / RCTScreenScale())) {
        return;
    }

    _additionalInsets = additionalInsets;
    [self updateWithCurrentAdditionalInsetsWithView:view];
}

@end
