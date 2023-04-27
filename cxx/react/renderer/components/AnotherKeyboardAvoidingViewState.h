#pragma once

#ifdef ANDROID
#include <folly/dynamic.h>
#include <react/renderer/mapbuffer/MapBuffer.h>
#include <react/renderer/mapbuffer/MapBufferBuilder.h>
#endif

namespace facebook
{
    namespace react
    {

        class AnotherKeyboardAvoidingViewState final
        {
        public:
            AnotherKeyboardAvoidingViewState() = default;
            EdgeInsets padding{};

#ifdef ANDROID
            AnotherKeyboardAvoidingViewState(AnotherKeyboardAvoidingViewState const &previousState, folly::dynamic data){};
            folly::dynamic getDynamic() const
            {
                return {};
            };
            MapBuffer getMapBuffer() const
            {
                return MapBufferBuilder::EMPTY();
            };
#endif
        };

    }
}