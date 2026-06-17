package com.example.sanad_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.sanad_app/quran"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openQuran" -> {
                    val intent = Intent(this, com.katma1.Quran1.MainActivity::class.java)
                    startActivity(intent)
                    result.success(true)
                }
                "openReading" -> {
                    val surahId = call.argument<String>("surah_id") ?: "1"
                    val ayahId = call.argument<String>("ayah_id")
                    val intent = Intent(this, com.katma1.Quran1.ReadingActivity::class.java)
                    intent.putExtra("surah_id", surahId)
                    if (ayahId != null) intent.putExtra("ayah_id", ayahId)
                    startActivity(intent)
                    result.success(true)
                }
                "openSearch" -> {
                    val intent = Intent(this, com.katma1.Quran1.SearchActivity::class.java)
                    startActivity(intent)
                    result.success(true)
                }
                "openBookmarks" -> {
                    val intent = Intent(this, com.katma1.Quran1.BookmarksActivity::class.java)
                    startActivity(intent)
                    result.success(true)
                }
                "openStats" -> {
                    val intent = Intent(this, com.katma1.Quran1.StatsActivity::class.java)
                    startActivity(intent)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
