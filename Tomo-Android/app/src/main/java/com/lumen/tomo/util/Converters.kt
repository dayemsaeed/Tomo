package com.lumen.tomo.util

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.room.ProvidedTypeConverter
import androidx.room.TypeConverter
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.Date

@ProvidedTypeConverter
class Converters {
    @TypeConverter
    fun fromColor(color: Int): Color {
        return Color(color)
    }

    @TypeConverter
    fun toColor(color: Color): Int {
        return color.toArgb()
    }

    @TypeConverter
    fun fromDate(date: Date): Long {
        return date.time
    }

    @TypeConverter
    fun toDate(millis: Long): Date {
        return Date(millis)
    }

    private val formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME

    @TypeConverter
    fun fromString(value: String?): LocalDateTime? {
        return value?.let { LocalDateTime.parse(it, formatter) }
    }

    @TypeConverter
    fun toString(date: LocalDateTime?): String? {
        return date?.format(formatter)
    }
}