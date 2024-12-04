package com.lumen.tomo.model

enum class BreathingPattern(val description: String, val phases: List<BreathingPhase>) {
    BOX_BREATHING(
        "Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds, hold for 4 seconds. Helps regain calm and control of thoughts when under stress.",
        listOf(
            BreathingPhase("Inhale", 4000),
            BreathingPhase("Hold", 4000),
            BreathingPhase("Exhale", 4000),
            BreathingPhase("Hold", 4000)
        )
    ),
    FOUR_SEVEN_EIGHT(
        "Inhale for 4 seconds, hold for 7 seconds, exhale for 8 seconds. Promotes relaxation and helps with sleep.",
        listOf(
            BreathingPhase("Inhale", 4000),
            BreathingPhase("Hold", 7000),
            BreathingPhase("Exhale", 8000)
        )
    ),
    EQUAL_BREATHING(
        "Inhale for 4 seconds, exhale for 4 seconds. Balances the nervous system, reduces stress.",
        listOf(
            BreathingPhase("Inhale", 4000),
            BreathingPhase("Exhale", 4000)
        )
    ),
    MEASURED_BREATHING(
        "Inhale for 4 seconds, hold for 1 second, exhale for 7 seconds. Reduces stress and anxiety, promotes relaxation.",
        listOf(
            BreathingPhase("Inhale", 4000),
            BreathingPhase("Hold", 1000),
            BreathingPhase("Exhale", 7000)
        )
    ),
    TRIANGLE_BREATHING(
        "Inhale for 4 seconds, hold for 4 seconds, exhale for 4 seconds. Alleviates anxiety and stress.",
        listOf(
            BreathingPhase("Inhale", 4000),
            BreathingPhase("Hold", 4000),
            BreathingPhase("Exhale", 4000)
        )
    )
}


data class BreathingPhase(val instruction: String, val durationInMillis: Long)