package com.anotherkeyboardavoidingview

import android.graphics.Color
import android.util.Log
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsAnimationCompat
import androidx.core.view.WindowInsetsCompat

@ReactModule(name = AnotherKeyboardAvoidingViewManager.NAME)
class AnotherKeyboardAvoidingViewManager :
  AnotherKeyboardAvoidingViewManagerSpec<AnotherKeyboardAvoidingView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(
      context: ThemedReactContext
  ): AnotherKeyboardAvoidingView {
    var view = AnotherKeyboardAvoidingView(context)

    Log.w("my-tag", "Create view")

    ViewCompat.setOnApplyWindowInsetsListener(view) { _, insets ->
      val imeVisible = insets.isVisible(WindowInsetsCompat.Type.ime())
      val imeHeight = insets.getInsets(WindowInsetsCompat.Type.ime()).bottom
      insets
    }

    var startBottom = 0f
    var endBottom = 0f
    ViewCompat.setWindowInsetsAnimationCallback(
        view,
        object : WindowInsetsAnimationCompat.Callback(DISPATCH_MODE_STOP) {
          override fun onPrepare(animation: WindowInsetsAnimationCompat) {
            Log.w("animation-kbt", "prepare: " + view.bottom.toFloat())

            startBottom = view.bottom.toFloat()
          }

          override fun onStart(
              animation: WindowInsetsAnimationCompat,
              bounds: WindowInsetsAnimationCompat.BoundsCompat
          ): WindowInsetsAnimationCompat.BoundsCompat {
            Log.w("animation-kbt", "start: " + view.bottom.toFloat())
            // Record the position of the view after the IME transition.
            endBottom = view.bottom.toFloat()

            return bounds
          }

          override fun onProgress(
              insets: WindowInsetsCompat,
              runningAnimations: MutableList<WindowInsetsAnimationCompat>
          ): WindowInsetsCompat {
            Log.w("animation-kbt", "a: " + view.translationY.toString())

            // Find an IME animation.
            val imeAnimation =
                runningAnimations.find { it.typeMask and WindowInsetsCompat.Type.ime() != 0 }
                    ?: return insets

            // Offset the view based on the interpolated fraction of the IME animation.
            view.translationY = (startBottom - endBottom) * (1 - imeAnimation.interpolatedFraction)
            Log.w("animation-keyboard", view.translationY.toString())

            return insets
          }
        }
    )

    return view
  }

  companion object {
    const val NAME = "AnotherKeyboardAvoidingView"
  }
}
