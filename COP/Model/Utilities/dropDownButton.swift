

import UIKit

protocol dropDownButtonDelegate: AnyObject{
    func dropDownButton(_ button: dropDownButton,didSelectOption option: String)
    func dropDownButtonShowOptions(_ button : dropDownButton)
    func dropDownButtonHideOptions(_ button: dropDownButton)
}

class dropDownButton: UIButton{
    
    weak var delegate: dropDownButtonDelegate?
    weak var alertController : UIAlertController?//
    
    var options : [String] = []{
        didSet{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
          addTarget(self, action: #selector(showOptions), for: .touchUpInside)
      }
      
      @objc func showOptions() {
          if let topController = topMostViewController() {
              if topController.presentedViewController is UIAlertController {
                  topController.dismiss(animated: false) { [weak self] in
                      self?.presentOptions(on: topController)
                  }
              } else {
                  presentOptions(on: topController)
              }
          }
      }
      
      private func presentOptions(on viewController: UIViewController) {
          let alertController = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .actionSheet)
          
          for option in options {
              let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                  self?.delegate?.dropDownButton(self!, didSelectOption: option)
              }
              alertController.addAction(action)
          }
          
          alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
          self.alertController = alertController
          viewController.present(alertController, animated: true, completion: nil)
      }
      
      @objc func dismissAlertController() {
          delegate?.dropDownButtonHideOptions(self)
          alertController?.dismiss(animated: true, completion: nil)
      }
      
      private func topMostViewController() -> UIViewController? {
          var topController = UIApplication.shared.connectedScenes
              .compactMap { $0 as? UIWindowScene }
              .flatMap { $0.windows }
              .first { $0.isKeyWindow }?.rootViewController
          
          while let presented = topController?.presentedViewController {
              topController = presented
          }
          
          return topController
      }
}
