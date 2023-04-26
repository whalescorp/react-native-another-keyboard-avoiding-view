package com.anotherkeyboardavoidingview

import android.view.View
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager

abstract class AnotherKeyboardAvoidingViewViewManagerSpec<T : View> : SimpleViewManager<T>() {
  abstract fun setColor(view: T?, value: String?)
}
