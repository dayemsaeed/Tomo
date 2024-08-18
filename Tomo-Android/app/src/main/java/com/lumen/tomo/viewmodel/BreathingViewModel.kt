package com.lumen.tomo.viewmodel

import android.os.CountDownTimer
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.lumen.tomo.model.BreathingPattern
import com.lumen.tomo.model.BreathingPhase
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class BreathingViewModel @Inject constructor(): ViewModel() {
    private val _currentPhase = MutableLiveData<BreathingPhase>()
    val currentPhase: LiveData<BreathingPhase> = _currentPhase

    private var currentPhaseIndex = 0
    private lateinit var currentPattern: BreathingPattern

    fun startBreathing(pattern: BreathingPattern) {
        currentPattern = pattern
        currentPhaseIndex = 0
        startNextPhase()
    }

    private fun startNextPhase() {
        if (currentPhaseIndex < currentPattern.phases.size) {
            _currentPhase.value = currentPattern.phases[currentPhaseIndex]
            object : CountDownTimer(currentPattern.phases[currentPhaseIndex].durationInMillis, 1000) {
                override fun onTick(millisUntilFinished: Long) {}
                override fun onFinish() {
                    currentPhaseIndex++
                    startNextPhase()
                }
            }.start()
        }
    }
}
