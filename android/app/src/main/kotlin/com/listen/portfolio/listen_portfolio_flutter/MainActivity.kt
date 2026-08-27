package com.listen.portfolio.listen_portfolio_flutter

import android.os.Bundle
import android.util.Log
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
    private val TAG = "InstallReferrer"

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
                Log.d(TAG, "MethodChannel received request: getInstallReferrer")
                fetchInstallReferrer(result)
            } else {
                result.notImplemented()
            }
        }
    }

    /**
     * Connects to Google Play Install Referrer service to retrieve install URL parameters
     * (e.g., refer=xxx&target=xxx&utm_source=xxx) passed from Google Play.
     */
    private fun fetchInstallReferrer(result: MethodChannel.Result) {
        try {
            Log.d(TAG, "Starting connection to Google Play InstallReferrerClient...")
            val referrerClient = InstallReferrerClient.newBuilder(this).build()
            referrerClient.startConnection(object : InstallReferrerStateListener {
                override fun onInstallReferrerSetupFinished(responseCode: Int) {
                    Log.d(TAG, "InstallReferrer setup finished with responseCode: $responseCode")
                    when (responseCode) {
                        InstallReferrerClient.InstallReferrerResponse.OK -> {
                            try {
                                val response: ReferrerDetails = referrerClient.installReferrer
                                val referrerUrl: String = response.installReferrer ?: ""
                                val clickTimestamp: Long = response.referrerClickTimestampSeconds
                                val installTimestamp: Long = response.installBeginTimestampSeconds
                                val instantExperience: Boolean = response.googlePlayInstantParam
                                
                                Log.i(TAG, "Successfully fetched installReferrer: '$referrerUrl'")
                                Log.d(TAG, "Details -> clickTimestamp: $clickTimestamp, installTimestamp: $installTimestamp, instant: $instantExperience")
                                
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
                                Log.e(TAG, "Exception reading ReferrerDetails: ${e.message}", e)
                                try { referrerClient.endConnection() } catch (_: Exception) {}
                                result.success(mapOf("installReferrer" to ""))
                            }
                        }
                        InstallReferrerClient.InstallReferrerResponse.FEATURE_NOT_SUPPORTED -> {
                            Log.w(TAG, "InstallReferrer API not supported on this device/store version.")
                            try { referrerClient.endConnection() } catch (_: Exception) {}
                            result.success(mapOf("installReferrer" to ""))
                        }
                        InstallReferrerClient.InstallReferrerResponse.SERVICE_UNAVAILABLE -> {
                            Log.w(TAG, "InstallReferrer service is currently unavailable.")
                            try { referrerClient.endConnection() } catch (_: Exception) {}
                            result.success(mapOf("installReferrer" to ""))
                        }
                        else -> {
                            Log.w(TAG, "InstallReferrer failed with unhandled responseCode: $responseCode")
                            try { referrerClient.endConnection() } catch (_: Exception) {}
                            result.success(mapOf("installReferrer" to ""))
                        }
                    }
                }

                override fun onInstallReferrerServiceDisconnected() {
                    Log.d(TAG, "InstallReferrer service disconnected.")
                }
            })
        } catch (e: Exception) {
            Log.e(TAG, "Unexpected error in fetchInstallReferrer: ${e.message}", e)
            result.success(mapOf("installReferrer" to ""))
        }
    }
}
