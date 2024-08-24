package com.lumen.tomo.viewmodel

import android.os.CountDownTimer
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.lumen.tomo.model.BreathingPattern
import com.lumen.tomo.model.BreathingPhase
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class BreathingViewModel @Inject constructor() : ViewModel() {
    private val _currentPhase = MutableLiveData<BreathingPhase>()
    val currentPhase: LiveData<BreathingPhase> = _currentPhase

    private var currentPhaseIndex = 0
    private lateinit var currentPattern: BreathingPattern
    private var countDownTimer: CountDownTimer? = null

    // Start the breathing pattern
    fun startBreathing(pattern: BreathingPattern) {
        stopBreathing() // Stop any ongoing breathing session
        currentPattern = pattern
        currentPhaseIndex = 0
        startNextPhase()
    }

    // Stop the breathing pattern and cancel the timer
    fun stopBreathing() {
        countDownTimer?.cancel()
        countDownTimer = null
        _currentPhase.value = BreathingPhase("Stopped", 0)
    }

    // Start the next phase in the breathing pattern
    private fun startNextPhase() {
        if (currentPhaseIndex < currentPattern.phases.size) {
            _currentPhase.value = currentPattern.phases[currentPhaseIndex]
            countDownTimer = object : CountDownTimer(currentPattern.phases[currentPhaseIndex].durationInMillis, 1000) {
                override fun onTick(millisUntilFinished: Long) {}
                override fun onFinish() {
                    Log.d("BreathingViewModel", "Phase finished: ${currentPattern.phases[currentPhaseIndex].instruction}")
                    currentPhaseIndex++
                    startNextPhase()
                }
            }.start()
        } else {
            currentPhaseIndex = 0
            startNextPhase() // Optionally, you can reset or loop the breathing pattern
        }
    }

    override fun onCleared() {
        super.onCleared()
        stopBreathing() // Clean up timer when ViewModel is destroyed
    }
}


