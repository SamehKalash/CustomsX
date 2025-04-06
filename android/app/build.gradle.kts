plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Apply the Google Services plugin
}

android {
    namespace = "com.example.sccf"
    compileSdk = 33
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.sccf" // Replace with your app's package name
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM (Bill of Materials)
    implementation(platform("com.google.firebase:firebase-bom:33.12.0"))

    // Add Firebase Authentication dependency
    implementation("com.google.firebase:firebase-auth-ktx")

    // Add Firebase Analytics dependency
    implementation("com.google.firebase:firebase-analytics-ktx")

    // Add other Firebase dependencies as needed
    // Example: implementation("com.google.firebase:firebase-database-ktx")

    implementation("androidx.multidex:multidex:2.0.1")
}

dependencies:
  firebase_core: ^latest_version

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
