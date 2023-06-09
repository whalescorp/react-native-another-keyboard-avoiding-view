package com.anotherkeyboardavoidingview

import android.view.ViewGroup
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewGroupManager

abstract class AnotherKeyboardAvoidingViewManagerSpec<T : ViewGroup> : ViewGroupManager<T>() {
    abstract fun setEnabled(view: T, value: Boolean);
}
