package com.lumen.tomo.ui.util.breathing

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
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
    val scale by animateFloatAsState(
        targetValue = if (currentPhase.instruction == "Inhale") 1.5f else 1f,
        animationSpec = tween(durationMillis = currentPhase.durationInMillis.toInt()), label = ""
    )

    Box(
        modifier = Modifier
            .size(200.dp)
            .scale(scale)
            .background(Color.Transparent, shape = CircleShape)
            .border(width = 4.dp, color = Color.Blue, shape = CircleShape)
    )
}

@Composable
fun BreathingList(viewModel: BreathingViewModel, pattern: BreathingPattern) {
    val currentPhase by viewModel.currentPhase.observeAsState()

    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        currentPhase?.let {
            Text(text = it.instruction, fontSize = 24.sp, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(16.dp))
            BreathingAnimation(currentPhase = it)
        }
    }
}
