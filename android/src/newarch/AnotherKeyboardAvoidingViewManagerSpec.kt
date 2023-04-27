package com.anotherkeyboardavoidingview

import android.view.ViewGroup

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.AnotherKeyboardAvoidingViewManagerDelegate
import com.facebook.react.viewmanagers.AnotherKeyboardAvoidingViewManagerInterface
import com.facebook.soloader.SoLoader

abstract class AnotherKeyboardAvoidingViewManagerSpec<T : ViewGroup> : ViewGroupManager<T>(), AnotherKeyboardAvoidingViewManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = AnotherKeyboardAvoidingViewManagerDelegate(this)
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
