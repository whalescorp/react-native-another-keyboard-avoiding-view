#pragma once

#include <react/debug/react_native_assert.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>

#include "AnotherKeyboardAvoidingViewShadowNode.h"

namespace facebook
{
    namespace react
    {
        class AnotherKeyboardAvoidingViewComponentDescriptor final : public ConcreteComponentDescriptor<AnotherKeyboardAvoidingViewShadowNode>
        {
            using ConcreteComponentDescriptor::ConcreteComponentDescriptor;

            void adopt(ShadowNode::Unshared const &shadowNode) const override
            {
                react_native_assert(std::dynamic_pointer_cast<AnotherKeyboardAvoidingViewShadowNode>(shadowNode));
                auto anotherKeyboardAvoidingViewShadowNode = std::static_pointer_cast<AnotherKeyboardAvoidingViewShadowNode>(shadowNode);

                react_native_assert(std::dynamic_pointer_cast<YogaLayoutableShadowNode>(anotherKeyboardAvoidingViewShadowNode));
                auto layoutableShadowNode = std::static_pointer_cast<YogaLayoutableShadowNode>(anotherKeyboardAvoidingViewShadowNode);

                auto state = std::static_pointer_cast<const AnotherKeyboardAvoidingViewShadowNode::ConcreteState>(shadowNode->getState());
                auto stateData = state->getData();

                layoutableShadowNode->setPadding(stateData.padding);
                ConcreteComponentDescriptor::adopt(shadowNode);
            }
        };
    }
}
