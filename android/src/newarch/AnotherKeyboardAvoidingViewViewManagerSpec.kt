package com.anotherkeyboardavoidingview

import android.view.View

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.AnotherKeyboardAvoidingViewViewManagerDelegate
import com.facebook.react.viewmanagers.AnotherKeyboardAvoidingViewViewManagerInterface
import com.facebook.soloader.SoLoader

abstract class AnotherKeyboardAvoidingViewViewManagerSpec<T : View> : SimpleViewManager<T>(), AnotherKeyboardAvoidingViewViewManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = AnotherKeyboardAvoidingViewViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? {
    return mDelegate
  }

  companion object {
    init {
      if (BuildConfig.CODEGEN_MODULE_REGISTRATION != null) {
        SoLoader.loadLibrary(BuildConfig.CODEGEN_MODULE_REGISTRATION)
      }
    }
  }
}
