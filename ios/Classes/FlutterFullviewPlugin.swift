import Flutter
import UIKit
import FullviewSDK

public class FlutterFullviewPlugin: NSObject, FlutterPlugin {
    
    private var fullview: FullviewCore?
    private static var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger: FlutterBinaryMessenger = registrar.messenger()
        channel = FlutterMethodChannel(name: "flutter_fullview", binaryMessenger: messenger)
        let instance = FlutterFullviewPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "register":
            registerUser(call: call, result: result)
        case "logout":
            logout(result: result)
        case "requestCoBrowse":
            requestCoBrowse(result: result)
        case "cancelCoBrowseRequest":
            cancelCoBrowseRequest(result: result)
        case "getPositionInCoBrowseQueue":
            getPositionInCoBrowseQueue(result: result)
        case "getState":
            getState(result: result)
        case "takeScreenshot":
            takeScreenshot(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func registerUser(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let region = args["region"] as? String,
              let organisationId = args["organisationId"] as? String,
              let userId = args["userId"] as? String,
              let deviceId = args["deviceId"] as? String,
              let name = args["name"] as? String,
              let email = args["email"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments for register", details: nil))
            return
        }
        
        guard fullview == nil else {
            result(FlutterError(code: "REGISTER_ERROR", message: "Register already called.", details: nil))
            return
        }
        
        do {
            let regionSelected = FullviewRegion(rawValue: region) ?? .EU1
            let config = try FullviewConfig(
                region: regionSelected,
                organisationId: organisationId,
                userId: userId,
                deviceId: deviceId, // must be a uuid string
                name: name,
                email: email
            )
            fullview = FullviewCore()
            fullview?.onError = { error in
                print("Runtime error: \(error)")
            }
            configureForScreenshots()
            fullview?.register(config: config)
            result(nil)
        } catch {
            fullview = nil
            let errorMessage = (error as? FullviewError)?.debugMessage ?? error.localizedDescription
            result(FlutterError(code: "REGISTER_ERROR", message: errorMessage, details: nil))
        }
    }
    
    private func configureForScreenshots() {
        NotificationCenter.default.post(name: Notification.Name("ScreenshotNotificationModeEnabled"), object: true)
        NotificationCenter.default.addObserver(forName: Notification.Name("SdkWantsToTakeScreenshot"), object: nil, queue: .main) { notification in
            let fullSnapshot = notification.object as? Bool ?? false
            let data = ["fullSnapshot": fullSnapshot ? "true": "false"]
            FlutterFullviewPlugin.channel?.invokeMethod("handleScreenshotRequest", arguments:data)
        }
    }
    
    private func takeScreenshot(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments for takeScreenshot", details: nil))
            return
        }
        
        guard let fullSnapshot = args["fullSnapshot"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing `fullSnapshot` argument for takeScreenshot", details: nil))
            return
        }
        
        guard let redactionFrames = args["data"] as? Array<[String: [String: Any]]> else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing `data` argument for takeScreenshot", details: nil))
            return
        }
        
        guard let fullview else {
            result(FlutterError(code: "TAKE_SCREENSHOT", message: "Register not called.", details: nil))
            return
        }
        
        let frames: [CGRect] = redactionFrames.compactMap { elem in
            guard
                let x = (elem["position"]?["x"] as? NSNumber)?.doubleValue,
                let y = (elem["position"]?["y"] as? NSNumber)?.doubleValue,
                let width = (elem["size"]?["width"] as? NSNumber)?.doubleValue,
                let height = (elem["size"]?["height"] as? NSNumber)?.doubleValue else {
                return nil
            }
            return CGRect(x: x, y: y, width: width, height: height)
        }
        fullview.addDataRedactionFrames(frames)
        
        let fullSnapshotBool = fullSnapshot == "true"
        NotificationCenter.default.post(name: Notification.Name("TakeScreenshot"), object: fullSnapshotBool)
    }
    
    private func logout(result: @escaping FlutterResult) {
        guard let fullview else {
            result(FlutterError(code: "LOGOUT_ERROR", message: "Register not called or already called logout.", details: nil))
            return
        }
        self.fullview = nil
        fullview.logout()
        result(nil)
    }
    
    private func requestCoBrowse(result: @escaping FlutterResult) {
        guard let fullview else {
            result(FlutterError(code: "REQUEST_COBROWSE_ERROR", message: "Register not called.", details: nil))
            return
        }
        fullview.requestCoBrowse() { error in
            if let error {
                result(FlutterError(code: "REQUEST_COBROWSE_ERROR", message: error.localizedDescription, details: nil))
            } else {
                result(nil)
            }
        }
    }
    
    private func cancelCoBrowseRequest(result: @escaping FlutterResult) {
        guard let fullview else {
            result(FlutterError(code: "CANCEL_COBROWSE_REQUEST_ERROR", message: "Register not called.", details: nil))
            return
        }
        fullview.cancelCoBrowseRequest() { error in
            if let error {
                result(FlutterError(code: "CANCEL_COBROWSE_REQUEST_ERROR", message: error.localizedDescription, details: nil))
            } else {
                result(nil)
            }
        }
    }
    
    private func getPositionInCoBrowseQueue(result: @escaping FlutterResult) {
        guard let fullview else {
            result(FlutterError(code: "GET_POSITION_IN_COBROWSE_QUEUE_ERROR", message: "Register not called.", details:  nil))
            return
        }
        switch fullview.coBrowseStatus {
        case .requested(let position):
            result(position)
        default:
            result(0)
        }
    }
    
    private func getState(result: @escaping FlutterResult) {
        guard let fullview else {
            result(FlutterError(code: "GET_STATE_ERROR", message: "Register not called.", details: nil))
            return
        }
        switch fullview.coBrowseStatus {
        case .requested(_):
            result("CO_BROWSE_REQUESTED")
        case .connected:
            result("CO_BROWSE_ACTIVE")
        case .invitation(_):
            result("CO_BROWSE_INVITATION")
        default:
            result("IDLE")
        }
    }
}

