package com.listen.portfolio.listen_portfolio_flutter

import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // 1. Call installSplashScreen() before super.onCreate
        installSplashScreen()

        super.onCreate(savedInstanceState)

        // 2. Ensure that the content can extend to the system bar (optional, to enhance visual consistency)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
