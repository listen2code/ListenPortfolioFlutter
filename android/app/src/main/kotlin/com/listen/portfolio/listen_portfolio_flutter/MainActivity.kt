package com.listen.portfolio.listen_portfolio_flutter

import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.android.installreferrer.api.InstallReferrerClient
import com.android.installreferrer.api.InstallReferrerStateListener
import com.android.installreferrer.api.ReferrerDetails

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.listen.portfolio/install_referrer"

    override fun onCreate(savedInstanceState: Bundle?) {
        // 1. Call installSplashScreen() before super.onCreate
        installSplashScreen()

        super.onCreate(savedInstanceState)

        // 2. Ensure that the content can extend to the system bar (optional, to enhance visual consistency)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getInstallReferrer") {
                fetchInstallReferrer(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun fetchInstallReferrer(result: MethodChannel.Result) {
        try {
            val referrerClient = InstallReferrerClient.newBuilder(this).build()
            referrerClient.startConnection(object : InstallReferrerStateListener {
                override fun onInstallReferrerSetupFinished(responseCode: Int) {
                    when (responseCode) {
                        InstallReferrerClient.InstallReferrerResponse.OK -> {
                            try {
                                val response: ReferrerDetails = referrerClient.installReferrer
                                val referrerUrl: String = response.installReferrer ?: ""
                                val clickTimestamp: Long = response.referrerClickTimestampSeconds
                                val installTimestamp: Long = response.installBeginTimestampSeconds
                                val instantExperience: Boolean = response.googlePlayInstantParam
                                referrerClient.endConnection()
                                result.success(
                                    mapOf(
                                        "installReferrer" to referrerUrl,
                                        "referrerClickTimestampSeconds" to clickTimestamp,
                                        "installBeginTimestampSeconds" to installTimestamp,
                                        "googlePlayInstant" to instantExperience
                                    )
                                )
                            } catch (e: Exception) {
                                try { referrerClient.endConnection() } catch (_: Exception) {}
                                result.success(mapOf("installReferrer" to ""))
                            }
                        }
                        else -> {
                            try { referrerClient.endConnection() } catch (_: Exception) {}
                            result.success(mapOf("installReferrer" to ""))
                        }
                    }
                }

                override fun onInstallReferrerServiceDisconnected() {
                    // Service disconnected
                }
            })
        } catch (e: Exception) {
            result.success(mapOf("installReferrer" to ""))
        }
    }
}
