package com.lumen.tomo.ui.views

import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.tooling.preview.Preview
import com.airbnb.lottie.compose.LottieAnimation
import com.airbnb.lottie.compose.LottieCompositionSpec
import com.airbnb.lottie.compose.LottieConstants
import com.airbnb.lottie.compose.rememberLottieComposition
import com.lumen.tomo.R

@Composable
fun ChatView() {
    val catIdleLottieComposition by rememberLottieComposition(
        spec = LottieCompositionSpec.RawRes(R.raw.cat_idle)
    )
    LottieAnimation(
        composition = catIdleLottieComposition,
        iterations = LottieConstants.IterateForever,
        reverseOnRepeat = true
    )
}

@Preview(name = "LottieView", showBackground = true)
@Composable
fun ChatViewPreview() {
    ChatView()
}