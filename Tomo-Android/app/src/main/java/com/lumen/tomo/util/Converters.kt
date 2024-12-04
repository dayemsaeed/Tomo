package com.lumen.tomo.util

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.room.ProvidedTypeConverter
import androidx.room.TypeConverter
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.ZoneOffset
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException
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

    companion object {
        fun convertToLocalDateTime(utcTimestamp: String): String {
            // Parse the UTC timestamp
            val utcZonedDateTime = ZonedDateTime.parse(utcTimestamp, DateTimeFormatter.ISO_OFFSET_DATE_TIME)

            // Convert to local time zone
            val localZonedDateTime = utcZonedDateTime.withZoneSameInstant(ZoneId.systemDefault())

            // Format for display
            val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a")
            return localZonedDateTime.format(formatter)
        }

        // TODO: fix so that times are converted to UTC time. Right now time is unchanged with only UTC timezone added
        fun convertToUTC(localDateTimeString: String, pattern: String): String {
            return try {
                // Define the formatter for the input string
                val formatter = DateTimeFormatter.ofPattern(pattern)

                // Parse the input string to a LocalDateTime
                val localDateTime = LocalDateTime.parse(localDateTimeString, formatter)

                // Define the system's default time zone
                val systemDefault = ZoneId.systemDefault()

                // Create a ZonedDateTime in the system's default time zone
                val localZonedDateTime = localDateTime.atZone(systemDefault)

                // Convert the ZonedDateTime to UTC
                val utcZonedDateTime = localZonedDateTime.withZoneSameInstant(ZoneOffset.UTC)

                // Define the formatter for the output string to match database format
                val utcFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ssX")

                // Format the ZonedDateTime as a string
                utcZonedDateTime.format(utcFormatter)
            } catch (e: DateTimeParseException) {
                e.printStackTrace()
                "${e.message}"
            }
        }

    }
}