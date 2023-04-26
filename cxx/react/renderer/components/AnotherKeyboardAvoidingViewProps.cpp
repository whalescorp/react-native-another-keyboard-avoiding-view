#include "AnotherKeyboardAvoidingViewProps.h"

#include <react/renderer/core/PropsParserContext.h>
#include <react/renderer/core/propsConversions.h>

namespace facebook
{
  namespace react
  {

    AnotherKeyboardAvoidingViewProps::AnotherKeyboardAvoidingViewProps(
        const PropsParserContext &context,
        const AnotherKeyboardAvoidingViewProps &sourceProps,
        const RawProps &rawProps) : ViewProps(context, sourceProps, rawProps),
                                    enabled(convertRawProp(context, rawProps, "enabled", sourceProps.enabled, {false}))
    {
    }
  }
}
