package com.lumen.tomo.ui.util.breathing

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.lumen.tomo.model.BreathingPattern
import com.lumen.tomo.model.BreathingPhase
import com.lumen.tomo.viewmodel.BreathingViewModel

@Composable
fun BreathingAnimation(currentPhase: BreathingPhase) {
    // Define target scale based on the phase
    val targetScale = when (currentPhase.instruction) {
        "Inhale" -> 1.5f
        "Exhale" -> 0.75f
        "Hold" -> 1.5f // If holding after inhale, otherwise use 0.75f
        else -> 1f
    }

    // Animate the scale
    val scale by animateFloatAsState(
        targetValue = targetScale,
        animationSpec = tween(durationMillis = currentPhase.durationInMillis.toInt()),
        label = "BreathingAnimation"
    )

    // Draw the circle with the animated scale
    Box(
        modifier = Modifier
            .size(200.dp)
            .scale(scale)
            .background(Color.Transparent, shape = CircleShape)
            .border(width = 4.dp, color = Color.Blue, shape = CircleShape)
    )
}

@Composable
fun BreathingExercise(viewModel: BreathingViewModel) {
    val currentPhase by viewModel.currentPhase.observeAsState()

    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center,
    ) {
        currentPhase?.let {
            Text(text = it.instruction, fontSize = 24.sp, fontWeight = FontWeight.Bold)
            BreathingAnimation(currentPhase = it)
        }
    }
    DisposableEffect(Unit) {
        onDispose {
            viewModel.stopBreathing()
        }
    }
}