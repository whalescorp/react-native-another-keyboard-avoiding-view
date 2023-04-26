package com.anotherkeyboardavoidingview

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

@ReactModule(name = AnotherKeyboardAvoidingViewViewManager.NAME)
class AnotherKeyboardAvoidingViewViewManager :
  AnotherKeyboardAvoidingViewViewManagerSpec<AnotherKeyboardAvoidingViewView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): AnotherKeyboardAvoidingViewView {
    return AnotherKeyboardAvoidingViewView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: AnotherKeyboardAvoidingViewView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "AnotherKeyboardAvoidingViewView"
  }
}
