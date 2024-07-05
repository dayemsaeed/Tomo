import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    kotlin("kapt")
    id("com.google.dagger.hilt.android")
    kotlin("plugin.serialization") version "1.9.23"
}

android {
    namespace = "com.lumen.tomo"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.lumen.tomo"
        minSdk = 29
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
        val properties = Properties()
        properties.load(project.rootProject.file("local.properties").inputStream())
        buildConfigField("String", "SUPABASE_KEY", "\"${properties.getProperty("SUPABASE_KEY")}\"")
        buildConfigField("String", "BOT_URI", "\"${properties.getProperty("BOT_URI")}\"")
        buildConfigField("String", "SUPABASE_URL", "\"${properties.getProperty("SUPABASE_URL")}\"")
        buildConfigField("String", "BREAKDOWN_URI", "\"${properties.getProperty("BREAKDOWN_URI")}\"")

        kapt {
            arguments {
                arg("room.schemaLocation", "$projectDir/schemas")
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        // Enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
    buildFeatures {
        compose = true
        viewBinding = true
        buildConfig = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.11"
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

// Version numbers
val lottieVersion = "6.1.0"
val firebaseBomVersion = "33.1.1"
val supabaseVersion = "2.3.0"
val ktorVersion = "2.3.10"
val hiltVersion = "2.51.1"
val retrofitVersion = "2.9.0"
val coreKtxVersion = "1.13.1"
val lifecycleVersion = "2.8.3"
val navigationVersion = "2.7.7"
val activityComposeVersion = "1.9.0"
val composeBomVersion = "2024.06.00"
val appCompatVersion = "1.7.0"
val materialVersion = "1.12.0"
val annotationVersion = "1.8.0"
val constraintLayoutVersion = "2.1.4"
val junitVersion = "4.13.2"
val androidxTestVersion = "1.2.1"
val espressoCoreVersion = "3.6.1"
val constraintLayoutComposeVersion = "1.0.1"
val hiltNavigationVersion = "1.2.0"
val runtimeVersion = "1.6.8"
val calendarVersion = "2.6.0-beta02"
val desugaringVersion = "2.0.4"
val roomVersion = "2.6.1"
val materialIconsVersion = "1.6.7"
val material3Version = "1.3.0-beta04"

dependencies {

    // Desugaring for calendar (Desugaring allows for Java 8+ API support in newer AGP versions)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:$desugaringVersion")

    // Firebase
    implementation(platform("com.google.firebase:firebase-bom:$firebaseBomVersion"))
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
    implementation("com.google.firebase:firebase-auth-ktx")

    // Jetpack Compose
    implementation(platform("androidx.compose:compose-bom:$composeBomVersion"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("androidx.constraintlayout:constraintlayout-compose:$constraintLayoutComposeVersion")
    implementation("androidx.navigation:navigation-compose:$navigationVersion")
    implementation("androidx.datastore:datastore-preferences-core-jvm:1.1.1")
    androidTestImplementation("androidx.compose.ui:ui-test-junit4")
    debugImplementation("androidx.compose.ui:ui-tooling")
    debugImplementation("androidx.compose.ui:ui-test-manifest")

    // Hilt - Dependency Injection
    implementation("com.google.dagger:hilt-android:$hiltVersion")
    kapt("com.google.dagger:hilt-android-compiler:$hiltVersion")
    implementation("androidx.hilt:hilt-navigation-fragment:$hiltNavigationVersion")
    implementation("androidx.hilt:hilt-navigation-compose:$hiltNavigationVersion")

    // Retrofit
    implementation("com.squareup.retrofit2:retrofit:$retrofitVersion")
    implementation("com.squareup.retrofit2:converter-gson:$retrofitVersion")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")

    // Core & Lifecycle
    implementation("androidx.core:core-ktx:$coreKtxVersion")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:$lifecycleVersion")
    implementation("androidx.activity:activity-compose:$activityComposeVersion")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:$lifecycleVersion")
    implementation("androidx.compose.runtime:runtime-livedata:${runtimeVersion}")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:$lifecycleVersion")

    // Supabase
    implementation(platform("io.github.jan-tennert.supabase:bom:$supabaseVersion"))
    implementation("io.github.jan-tennert.supabase:postgrest-kt")
    implementation("io.github.jan-tennert.supabase:storage-kt")
    implementation("io.github.jan-tennert.supabase:compose-auth")
    implementation("io.github.jan-tennert.supabase:compose-auth-ui")
    implementation("io.github.jan-tennert.supabase:gotrue-kt")
    implementation("io.ktor:ktor-client-android:$ktorVersion")
    implementation("io.ktor:ktor-client-core:$ktorVersion")
    implementation("io.ktor:ktor-utils:$ktorVersion")

    // Room
    implementation("androidx.room:room-runtime:$roomVersion")
    implementation("androidx.room:room-ktx:$roomVersion")
    annotationProcessor("androidx.room:room-compiler:$roomVersion")

    // To use Kotlin annotation processing tool (kapt)
    kapt("androidx.room:room-compiler:$roomVersion")

    // Datastore
    implementation("androidx.datastore:datastore-preferences")

    // UI & Material Design
    implementation("androidx.appcompat:appcompat:$appCompatVersion")
    implementation("com.google.android.material:material:$materialVersion")
    implementation("androidx.compose.material3:material3:$material3Version")
    implementation("androidx.compose.material:material-icons-extended:$runtimeVersion")
    implementation("androidx.annotation:annotation:$annotationVersion")
    implementation("androidx.constraintlayout:constraintlayout:$constraintLayoutVersion")
    implementation("androidx.legacy:legacy-support-v4:1.0.0")

    // Lottie Animations
    implementation("com.airbnb.android:lottie-compose:$lottieVersion")

    // Calendar
    implementation("com.kizitonwose.calendar:compose:$calendarVersion")

    // Testing
    testImplementation("junit:junit:$junitVersion")
    androidTestImplementation("androidx.test.ext:junit:$androidxTestVersion")
    androidTestImplementation("androidx.test.espresso:espresso-core:$espressoCoreVersion")
    androidTestImplementation(platform("androidx.compose:compose-bom:$composeBomVersion"))
}

kapt {
    correctErrorTypes = true
}