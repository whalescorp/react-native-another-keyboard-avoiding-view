#pragma once

#include <react/renderer/components/view/ViewEventEmitter.h>
#include <jsi/jsi.h>

namespace facebook
{
  namespace react
  {
    class JSI_EXPORT AnotherKeyboardAvoidingViewEventEmitter : public ViewEventEmitter
    {
    public:
      using ViewEventEmitter::ViewEventEmitter;
    };
  }
}
