#pragma once

#include <jsi/jsi.h>
#include <react/renderer/components/view/ViewProps.h>
#include <react/renderer/core/PropsParserContext.h>

namespace facebook
{
  namespace react
  {

    class JSI_EXPORT AnotherKeyboardAvoidingViewProps final : public ViewProps
    {
    public:
      AnotherKeyboardAvoidingViewProps() = default;
      AnotherKeyboardAvoidingViewProps(const PropsParserContext &context, const AnotherKeyboardAvoidingViewProps &sourceProps, const RawProps &rawProps);

      bool enabled{false};
    };

  }
}
