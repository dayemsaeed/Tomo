package com.lumen.tomo.ui.util

import androidx.annotation.RawRes
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import com.airbnb.lottie.compose.LottieAnimation
import com.airbnb.lottie.compose.LottieCompositionSpec
import com.airbnb.lottie.compose.LottieConstants
import com.airbnb.lottie.compose.rememberLottieComposition

@Composable
fun LoopingLottieAnimation(
    @RawRes lottieRes: Int
) {
    val composition by rememberLottieComposition(spec = LottieCompositionSpec.RawRes(lottieRes))

    LottieAnimation(
        composition = composition,
        isPlaying = true,
        iterations = LottieConstants.IterateForever,
        reverseOnRepeat = true,
        modifier = Modifier.fillMaxSize()
    )
}