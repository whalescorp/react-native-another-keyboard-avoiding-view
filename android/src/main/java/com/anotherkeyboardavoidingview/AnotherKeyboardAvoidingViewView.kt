package com.anotherkeyboardavoidingview

import android.content.Context
import android.util.AttributeSet
import android.view.ViewGroup

class AnotherKeyboardAvoidingViewView : ViewGroup {
  constructor(context: Context?) : super(context)
  constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs)
  constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(
    context,
    attrs,
    defStyleAttr
  )

  override fun onLayout(p0: Boolean, p1: Int, p2: Int, p3: Int, p4: Int) { }
}
