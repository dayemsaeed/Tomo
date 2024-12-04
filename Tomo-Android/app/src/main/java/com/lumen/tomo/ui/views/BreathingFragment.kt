package com.lumen.tomo.ui.views

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
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
import androidx.navigation.NavController
import com.lumen.tomo.model.BreathingPattern
import com.lumen.tomo.model.BreathingPhase
import com.lumen.tomo.ui.util.breathing.BreathingItemCard
import com.lumen.tomo.viewmodel.BreathingViewModel

@Composable
fun BreathingFragment(navController: NavController, viewModel: BreathingViewModel) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(8.dp),
        verticalArrangement = Arrangement.Center
    ) {
        BreathingPattern.entries.forEach { breathingPattern ->
            item {
                BreathingItemCard(
                    breathingItem = breathingPattern,
                    onItemClick = {
                        viewModel.startBreathing(breathingPattern)
                        navController.navigate("breathe/${breathingPattern.name}")
                    }
                )
                Spacer(modifier = Modifier.height(16.dp))
            }
        }
    }
}