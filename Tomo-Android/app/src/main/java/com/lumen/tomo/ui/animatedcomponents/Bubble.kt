package com.lumen.tomo.ui.animatedcomponents

import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateOffsetAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.lumen.tomo.R

@Composable
fun Bubble(
    startAnimation: Boolean,
    position1: Offset,
    position2: Offset
) {
    val offset1 by animateOffsetAsState(
        targetValue = if (startAnimation) position1 else position1.copy(x = position1.x + 10f, y = position1.y + 30f),
        animationSpec = infiniteRepeatable(
            animation = tween(3000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ), label = "Bubble1"
    )

    val offset2 by animateOffsetAsState(
        targetValue = if (startAnimation) position2 else position2.copy(x = position2.x + 30f, y = position2.y + 10f),
        animationSpec = infiniteRepeatable(
            animation = tween(3000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ), label = "Bubble2"
    )

    Canvas(modifier = Modifier.size(300.dp)) {
        drawCircle(color = Color(R.color.teal_200).copy(alpha = 0.4f), radius = 150f, center = offset1)
        drawCircle(color = Color(R.color.teal_200).copy(alpha = 0.4f), radius = 150f, center = offset2)
    }
}


