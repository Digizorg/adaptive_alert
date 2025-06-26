import Flutter
import UIKit

public class NativeAlertPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app.digizorg.adaptive_alert", binaryMessenger: registrar.messenger())
    let instance = NativeAlertPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

      public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "showAdaptiveAlertDialog":
      guard let args = call.arguments as? [String: Any],
            let title = args["title"] as? String,
            let message = args["message"] as? String,
            let primaryButtonTitle = args["primaryButtonTitle"] as? String,
            let primaryButtonActionType = args["primaryButtonActionType"] as? String,
            let secondaryButtonTitle = args["secondaryButtonTitle"] as? String,
            let secondaryButtonActionType = args["secondaryButtonActionType"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }

      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

      let primaryStyle = getActionStyle(from: primaryButtonActionType)
      alert.addAction(UIAlertAction(title: primaryButtonTitle, style: primaryStyle, handler: { _ in
        result("primary")
      }))

      if !secondaryButtonTitle.isEmpty {
          let secondaryStyle = getActionStyle(from: secondaryButtonActionType)
          alert.addAction(UIAlertAction(title: secondaryButtonTitle, style: secondaryStyle, handler: { _ in
            result("secondary")
          }))
      }

      DispatchQueue.main.async {
          UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
      }

        case "showAdaptiveActionSheet":
        guard let args = call.arguments as? [String: Any],
              let actions = args["actions"] as? [[String: String]],
              let cancelAction = args["cancelAction"] as? [String: String] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for showAdaptiveActionSheet", details: nil))
            return
        }
        let title = args["title"] as? String
        let message = args["message"] as? String

        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        for (index, actionData) in actions.enumerated() {
            if let actionTitle = actionData["title"], let actionType = actionData["type"] {
                let style = getActionStyle(from: actionType)
                let alertAction = UIAlertAction(title: actionTitle, style: style, handler: { _ in
                    result("\(index)")
                })
                alert.addAction(alertAction)
            }
        }

        if let cancelTitle = cancelAction["title"], let cancelType = cancelAction["type"] {
            let style = getActionStyle(from: cancelType)
            let cancelAlertAction = UIAlertAction(title: cancelTitle, style: style, handler: { _ in
                result("cancel")
            })
            alert.addAction(cancelAlertAction)
        }

        DispatchQueue.main.async {
          UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getActionStyle(from type: String) -> UIAlertAction.Style {
      switch type {
      case "destructive":
          return .destructive
      case "cancel":
          return .cancel
      default:
          return .default
      }
  }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
