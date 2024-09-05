//
//  termsAndConditionViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 12/07/24.
//

import UIKit

class termsAndConditionViewController: UIViewController{
    
    @IBOutlet weak var termsAndConditions: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullText = """

        These Terms and Conditions govern your use of the Constable On Patrol (COP) App, developed and provided by SKILLOP Society in Delhi Technological University. By downloading, installing, or using the App, you agree to comply with these Terms. If you do not agree with any part of these Terms, do not use the App.

        1. Acceptance of Terms

         By downloading, installing, or using the App, you agree to be bound by these Terms of Service (“Terms”). If you do not agree with any part of these Terms, you must not use the App.

        2. License

        We grant you a limited, non-exclusive, non-transferable, revocable license to use the App solely for your personal or internal business purposes. You may not modify, adapt, translate, reverse engineer, decompile, or disassemble the App.

        3. User Accounts

        Some features of the App may require you to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.

        4. Privacy Policy

        Your use of the App is also subject to our Privacy Policy, which is incorporated into these Terms by reference. By using the App, you consent to the collection and use of your information as described in the Privacy Policy.

        5. Use Restrictions

        You agree not to use the App for any unlawful purpose or in any way that violates these Terms. You may not use the App in any manner that could damage, disable, overburden, or impair the App. If you do so, neither SKILLOP Society nor any developer will be responsible for any consequences.

        6. Intellectual Property

        The App and its original content, features, and functionality are owned by SKILLOP Society and are protected by COP Team as of now.

        7. Updates

        SKILLOP Society may from time to time provide updates to the App. These updates may include bug fixes, feature enhancements, or improvements. You agree to install such updates promptly.

        8. Termination

        SKILLOP Society may terminate your access to the App at any time without notice if you violate these Terms. Upon termination, you must cease all use of the App and uninstall it from your device and also will be informed to Top Officials.

        9. Disclaimer of Warranties

        THE APP IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. SKILLOP Society DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON- INFRINGEMENT.

        10. Limitation of Liability

        IN NO EVENT SHALL SKILLOP Society BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE OF THE APP.

        11. Governing Law

        These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which SKILLOP Society is based, without regard to its conflict of law provisions.

        12. Changes to Terms

        SKILLOP Society reserves the right, at its sole discretion, to modify or replace these Terms at any time. It is your responsibility to review these Terms periodically for changes. Your continued use of the App following the posting of any changes to these Terms constitutes acceptance of those changes.

        13. Contact Us

        If you have any questions about these Terms, please contact us at ekanshbhushan@gmail.com or +91 9643654899.
        By using the App, you acknowledge that you have read, understood, and agree to be bound by these Terms. If you do not agree to these Terms, do not use the App.

"""
    
        
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: fullText.count))
        
        let boldRanges = [
            (fullText as NSString).range(of: "1. Acceptance of Terms"),
            (fullText as NSString).range(of: "2. License"),
            (fullText as NSString).range(of: "3. User Accounts"),
            (fullText as NSString).range(of: "4. Privacy Policy"),
            (fullText as NSString).range(of: "5. Use Restrictions"),
            (fullText as NSString).range(of: "6. Intellectual Property"),
            (fullText as NSString).range(of: "7. Updates"),
            (fullText as NSString).range(of: "8. Termination"),
            (fullText as NSString).range(of: "9. Disclaimer of Warranties"),
            (fullText as NSString).range(of: "10. Limitation of Liability"),
            (fullText as NSString).range(of: "11. Governing Law"),
            (fullText as NSString).range(of: "12. Changes to Terms"),
            (fullText as NSString).range(of: "13. Contact Us")
        ]
        
        let largeFont = UIFont.boldSystemFont(ofSize: 22)
        
        for range in boldRanges {
            attributedString.addAttribute(.font, value: largeFont, range: range)
        }
        
        termsAndConditions.attributedText = attributedString
        
        termsAndConditions.isEditable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
