#ifdef RCT_NEW_ARCH_ENABLED
#import "AnotherKeyboardAvoidingViewView.h"

#import <react/renderer/components/RNAnotherKeyboardAvoidingViewViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNAnotherKeyboardAvoidingViewViewSpec/EventEmitters.h>
#import <react/renderer/components/RNAnotherKeyboardAvoidingViewViewSpec/Props.h>
#import <react/renderer/components/RNAnotherKeyboardAvoidingViewViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "Utils.h"

using namespace facebook::react;

@interface AnotherKeyboardAvoidingViewView () <RCTAnotherKeyboardAvoidingViewViewViewProtocol>

@end

@implementation AnotherKeyboardAvoidingViewView {
    UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<AnotherKeyboardAvoidingViewViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const AnotherKeyboardAvoidingViewViewProps>();
    _props = defaultProps;

    _view = [[UIView alloc] init];

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<AnotherKeyboardAvoidingViewViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<AnotherKeyboardAvoidingViewViewProps const>(props);

    if (oldViewProps.color != newViewProps.color) {
        NSString * colorToConvert = [[NSString alloc] initWithUTF8String: newViewProps.color.c_str()];
        [_view setBackgroundColor: [Utils hexStringToColor:colorToConvert]];
    }

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> AnotherKeyboardAvoidingViewViewCls(void)
{
    return AnotherKeyboardAvoidingViewView.class;
}

@end
#endif
