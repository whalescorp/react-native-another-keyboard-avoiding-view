package com.anotherkeyboardavoidingview

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

@ReactModule(name = AnotherKeyboardAvoidingViewManager.NAME)
class AnotherKeyboardAvoidingViewManager :
  AnotherKeyboardAvoidingViewManagerSpec<AnotherKeyboardAvoidingView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): AnotherKeyboardAvoidingView {
    return AnotherKeyboardAvoidingView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: AnotherKeyboardAvoidingView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "AnotherKeyboardAvoidingView"
  }
}
