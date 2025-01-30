package io.fullview.mobile.flutter_fullview

import android.app.Activity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.fullview.fullview_sdk.Fullview
import io.fullview.fullview_sdk.HostType
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.fullview.fullview_sdk.Region
import java.lang.IllegalStateException

/** FlutterFullviewPlugin */
class FlutterFullviewPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private var fullview : Fullview = Fullview.getInstance()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_fullview")
    channel.setMethodCallHandler(this)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {}

  override fun onMethodCall(call: MethodCall, result: Result) {
      when (call.method) {
          "getPlatformVersion" ->
              result.success("Android ${android.os.Build.VERSION.RELEASE}")
          "attach" -> {
              attach()
              result.success(null)
          }
          "register" -> {
            register(call, result)
          }
          "logout" -> {
            logout()
            result.success(null)
          }
          "requestCoBrowse" -> {
            requestCoBrowse()
            result.success(null)
          }
          "cancelCoBrowseRequest" -> {
            cancelCoBrowseRequest()
            result.success(null)
          }
          "getPositionInCoBrowseQueue" -> {
            getPositionInCoBrowseQueue(result)
          }
          "getState" -> {
            getState(result)
          }
          else -> result.notImplemented()
      }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

    private fun attach() {
        activity?.apply {
            fullview.attach(this, HostType.FLUTTER)
        }
    }

    private fun register(call: MethodCall, result: Result) {
      val region : Region = call.argument<String>("region")?.uppercase().let {
          when(it) {
              "EU1" -> Region.EU1
              "EU2" -> Region.EU2
              "US1" -> Region.US1
              else -> throw IllegalStateException("Illegal region type $it")
          }
      }
      val organisationId = call.argument<String>("organisationId")!!
      val userId = call.argument<String>("userId")!!
      val deviceId = call.argument<String>("deviceId")!!
      val name = call.argument<String>("name")!!
      val email = call.argument<String>("email")!!

      fullview.register(organisationId, userId, deviceId, name, email, region)
      result.success(null)
    }

    private fun getState(result: Result) {
      result.success(fullview.sessionState.replayCache.lastOrNull()?.javaClass?.simpleName ?: "")
    }

    private fun logout() {
      fullview.logout()
    }

    private fun requestCoBrowse() {
      fullview.requestCoBrowse()
    }

    private fun cancelCoBrowseRequest() {
      fullview.cancelCoBrowseRequest()
    }

    private fun getPositionInCoBrowseQueue(result: Result) {
      result.success(fullview.positionInCoBrowseQueue.replayCache.lastOrNull() ?: -1)
    }
}
