import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init() {}
    
    private var isAlertPresented = false
    
    func showAlert(on viewController: UIViewController, message: String) {
        // Prevent presenting multiple alerts simultaneously
        guard !isAlertPresented else { return }
        
        isAlertPresented = true
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.isAlertPresented = false
        })
        
        DispatchQueue.main.async {
            if viewController.isViewLoaded && viewController.view.window != nil {
                viewController.present(alert, animated: true, completion: nil)
            } else {
                // Find the top-most view controller to present the alert
                if let topController = self.topMostViewController() {
                    topController.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        
        let keyWindow = scene.windows.first { $0.isKeyWindow }
        var topController = keyWindow?.rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
}
