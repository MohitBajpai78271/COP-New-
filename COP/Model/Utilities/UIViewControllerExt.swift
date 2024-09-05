//
//  UIViewControllerExt.swift
//  COP
//
//  Created by Mac on 06/08/24.
//

import UIKit
import MapKit

fileprivate var containerView : UIView!

extension UIViewController{
    
    func showLoadingView(mapview : MKMapView){
        containerView = UIView(frame: mapview.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        let activityIndicator = UIActivityIndicatorView(style: .large)//gives size
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
        
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async{  // all ui updates in main thread
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView){
        print("show is called")
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
}

