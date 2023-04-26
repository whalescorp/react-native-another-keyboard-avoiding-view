//
//  _AnotherKeyboardAvoidingView.h
//  react-native-another-keyboard-avoiding-view
//
//  Created by Anton Spivak on 26.04.2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class _AnotherKeyboardAvoidingView;

extern BOOL UIEdgeInsetsEqualToEdgeInsetsWithThreshold(UIEdgeInsets lhs, UIEdgeInsets rhs, CGFloat threshold);

@protocol _AnotherKeyboardAvoidingViewDelegate <NSObject>
- (void)_anotherKeyboardAvoidingView:(_AnotherKeyboardAvoidingView *)view
           requiresUpdateBottomInset:(CGFloat)inset;
@end

@interface _AnotherKeyboardAvoidingView : UIView

@property (nonatomic, assign, getter=isKeyboardListeningEnabled) BOOL keyboardListeningEnabled;
@property (nonatomic, weak) id<_AnotherKeyboardAvoidingViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
