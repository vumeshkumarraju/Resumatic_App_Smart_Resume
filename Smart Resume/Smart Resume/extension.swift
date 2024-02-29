//
//  extension.swift
//  Smart Resume
//
//  Created by UMESH KUMAR on 09/11/23.
//

import Foundation
import UIKit
import MessageUI

extension UIView{
    
    func applyGradient(colors:[CGColor] = [UIColor(named: "primaryColor")!.cgColor,UIColor(named: "gradientTint")!.cgColor,UIColor(named: "gradientTint")!.cgColor,UIColor(named: "gradientTint")!.cgColor],cornerRadius:CGFloat = 0){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func setUpView(cornerRadius:CGFloat = 40){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    
    func setActivityView(activityView:UIActivityIndicatorView){
        //activityView = UIActivityIndicatorView(style: .large)
                activityView.center = self.center
                self.addSubview(activityView)
    }
    func showActivityIndicatory(activityView:UIActivityIndicatorView) {
        

        activityView.startAnimating()
   }
    func hideActivityIndicator(activityView:UIActivityIndicatorView){
        if (activityView != nil){
            
            activityView.stopAnimating()
        }
    }
}

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    public func showPopUp(title:String,message:String){

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    func callToPhone(phNo:String){
        if let url = URL(string: "tel://\(phNo)"),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
