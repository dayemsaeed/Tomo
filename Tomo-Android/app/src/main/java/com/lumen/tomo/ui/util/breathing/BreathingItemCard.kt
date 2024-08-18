package com.lumen.tomo.ui.util.breathing

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.lumen.tomo.model.BreathingPattern

@Composable
fun BreathingItemCard(
    modifier: Modifier = Modifier,
    breathingItem: BreathingPattern,
    onItemClick: (BreathingPattern) -> Unit
) {
    Card(
        modifier = modifier
            .fillMaxWidth(),
        onClick = { onItemClick(breathingItem) }
    ) {
        Column(
            modifier = modifier.padding(16.dp),
            horizontalAlignment = Alignment.Start,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                text = breathingItem.name.replace("_", " "),
                fontWeight = FontWeight.Bold
            )
            Text(
                text = breathingItem.description,
                fontStyle = FontStyle.Italic,
            )
        }
    }
}

@Preview
@Composable
fun BreathingItemCardPreview() {
    BreathingItemCard(breathingItem = BreathingPattern.BOX_BREATHING) {
        // TODO: Handle item click
    }
}