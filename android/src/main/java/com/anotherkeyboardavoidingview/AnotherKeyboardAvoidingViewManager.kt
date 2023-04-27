package com.anotherkeyboardavoidingview

import android.graphics.Color
import android.util.Log
import android.view.View
import android.view.ViewGroup
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsAnimationCompat
import androidx.core.view.WindowInsetsCompat
import kotlin.math.abs

@ReactModule(name = AnotherKeyboardAvoidingViewManager.NAME)
class AnotherKeyboardAvoidingViewManager :
  AnotherKeyboardAvoidingViewManagerSpec<AnotherKeyboardAvoidingView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(
      context: ThemedReactContext
  ): AnotherKeyboardAvoidingView {
    return AnotherKeyboardAvoidingView(context)
  }

  companion object {
    const val NAME = "AnotherKeyboardAvoidingView"
  }
}
