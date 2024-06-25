package com.lumen.tomo.util

import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle

class DateUtil {
    companion object {
        private var timeColonPattern: String = "hh:mm a"
        var dateFormatter: DateTimeFormatter = DateTimeFormatter.ofLocalizedDate(FormatStyle.SHORT)
        val timeFormatter: DateTimeFormatter = DateTimeFormatter.ofPattern(timeColonPattern)
    }
}