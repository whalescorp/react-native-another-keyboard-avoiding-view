#pragma once

#include <jsi/jsi.h>
#include <react/renderer/components/view/ConcreteViewShadowNode.h>

#include "AnotherKeyboardAvoidingViewProps.h"
#include "AnotherKeyboardAvoidingViewEventEmitter.h"
#include "AnotherKeyboardAvoidingViewState.h"

namespace facebook
{
    namespace react
    {
        extern const char AnotherKeyboardAvoidingViewComponentName[];

        /*
         * `ShadowNode` for <AnotherKeyboardAvoidingView> component.
         */
        class AnotherKeyboardAvoidingViewShadowNode final : public ConcreteViewShadowNode<AnotherKeyboardAvoidingViewComponentName,
                                                                                          AnotherKeyboardAvoidingViewProps,
                                                                                          AnotherKeyboardAvoidingViewEventEmitter,
                                                                                          AnotherKeyboardAvoidingViewState>
        {
            using ConcreteViewShadowNode::ConcreteViewShadowNode;

        public:
            static ShadowNodeTraits BaseTraits()
            {
                auto traits = ConcreteViewShadowNode::BaseTraits();
                traits.set(ShadowNodeTraits::Trait::DirtyYogaNode);
                return traits;
            }
        };

    }
}
