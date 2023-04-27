#ifdef RCT_NEW_ARCH_ENABLED

#import "AnotherKeyboardAvoidingViewComponentDescriptor.h"

#import "AnotherKeyboardAvoidingView.h"
#import "_AnotherKeyboardAvoidingView.h"

#import "RCTFabricComponentsPlugins.h"
#import "RCTConversions.h"
#import "RCTUtils.h"

using namespace facebook::react;

@interface AnotherKeyboardAvoidingView () <_AnotherKeyboardAvoidingViewDelegate>

@property (nonatomic, strong) _AnotherKeyboardAvoidingView *view;
@property (nonatomic, assign) UIEdgeInsets additionalInsets;
@property (nonatomic, assign) AnotherKeyboardAvoidingViewShadowNode::ConcreteState::Shared state;

@end

@implementation AnotherKeyboardAvoidingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _props = std::make_shared<const AnotherKeyboardAvoidingViewProps>();
        
        _view = [[_AnotherKeyboardAvoidingView alloc] init];
        _view.delegate = self;
        
        _additionalInsets = UIEdgeInsetsZero;

        self.contentView = _view;
    }
    return self;
}

#pragma mark - Updates

- (void)updateWithCurrentAdditionalInsets {
    auto newPadding = RCTEdgeInsetsFromUIEdgeInsets(_additionalInsets);
    _state->updateState([=](AnotherKeyboardAvoidingViewShadowNode::ConcreteState::Data const &oldData) ->
                        AnotherKeyboardAvoidingViewShadowNode::ConcreteState::SharedData {
                            auto newData = oldData;
                            newData.padding = newPadding;
                            return std::make_shared<AnotherKeyboardAvoidingViewShadowNode::ConcreteState::Data const>(newData);
                        },
                        EventPriority::AsynchronousUnbatched);
}

#pragma mark - RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider {
    return concreteComponentDescriptorProvider<AnotherKeyboardAvoidingViewComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps {
    const auto &oldViewProps = *std::static_pointer_cast<AnotherKeyboardAvoidingViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<AnotherKeyboardAvoidingViewProps const>(props);

    if (oldViewProps.enabled != newViewProps.enabled) {
        _view.keyboardListeningEnabled = newViewProps.enabled;
    }

    [super updateProps:props oldProps:oldProps];
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
                          index:(NSInteger)index
{
    [self.contentView mountChildComponentView:childComponentView index:index];
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
                            index:(NSInteger)index
{
    [self.contentView unmountChildComponentView:childComponentView index:index];
}

Class<RCTComponentViewProtocol> AnotherKeyboardAvoidingViewCls(void) {
    return AnotherKeyboardAvoidingView.class;
}

- (void)updateState:(const facebook::react::State::Shared &)state
           oldState:(const facebook::react::State::Shared &)oldState
{
    _state = std::static_pointer_cast<AnotherKeyboardAvoidingViewShadowNode::ConcreteState const>(state);
}

- (void)finalizeUpdates:(RNComponentViewUpdateMask)updateMask {
    [super finalizeUpdates:updateMask];
    [self updateWithCurrentAdditionalInsets];
}

- (void)prepareForRecycle {
    [super prepareForRecycle];
    _state.reset();
}

#pragma mark - _AnotherKeyboardAvoidingViewDelegate

- (void)_anotherKeyboardAvoidingView:(_AnotherKeyboardAvoidingView *)view
           requiresUpdateBottomInset:(CGFloat)inset
{
    if (!_state) {
        return;
    }
    
    UIEdgeInsets additionalInsets = UIEdgeInsetsZero;
    additionalInsets.bottom = RCTRoundPixelValue(inset);
    
    if (UIEdgeInsetsEqualToEdgeInsetsWithThreshold(additionalInsets, _additionalInsets, 1.0 / RCTScreenScale())) {
        return;
    }
 
    _additionalInsets = additionalInsets;
    [self updateWithCurrentAdditionalInsets];
}

@end

#endif
