package com.lumen.tomo.ui.util

import androidx.annotation.RawRes
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.pointerInput
import com.airbnb.lottie.compose.LottieAnimation
import com.airbnb.lottie.compose.LottieCompositionSpec
import com.airbnb.lottie.compose.LottieConstants
import com.airbnb.lottie.compose.rememberLottieComposition
import com.lumen.tomo.R
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@Composable
fun InteractiveLottieAnimation(
    @RawRes initialAnimation: Int,
    @RawRes tapAnimation: Int,
    @RawRes swipeAnimation: Int = R.raw.cat_idle
) {
    var animationRes by remember { mutableIntStateOf(initialAnimation) }
    val idleAnimationComposition by rememberLottieComposition(LottieCompositionSpec.RawRes(initialAnimation))
    val tapAnimationComposition by rememberLottieComposition(LottieCompositionSpec.RawRes(tapAnimation))
    val swipeAnimationComposition by rememberLottieComposition(LottieCompositionSpec.RawRes(swipeAnimation))
    val coroutineScope = rememberCoroutineScope()  // Remember a CoroutineScope tied to the Composable's lifecycle

    LottieAnimation(
        composition = if (animationRes == initialAnimation) idleAnimationComposition else if (animationRes == tapAnimation) tapAnimationComposition else swipeAnimationComposition,  // Choose based on animationRe
        iterations = LottieConstants.IterateForever,
        modifier = Modifier
            .fillMaxWidth()
            .pointerInput(Unit) {
                detectTapGestures(onTap = {
                    coroutineScope.launch {
                        animationRes = tapAnimation
                        delay(5000)
                        animationRes = initialAnimation
                    }
                })
            }
            .pointerInput(Unit) {
                detectDragGestures { _, _ ->
                    coroutineScope.launch {
                        animationRes = swipeAnimation
                        delay(5000)
                        animationRes = initialAnimation
                    }
                }
            }
    )
}