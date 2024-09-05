//
//  PrivacyViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 12/07/24.
//

import UIKit

class PrivacyViewController: UIViewController{
    
    @IBOutlet weak var privacyPolicytext: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let fullTextPrivacy = """

Privacy Policy for Constable On Patrol (COP) App

This Privacy Policy explains how SKILLOP Society ("we," "us," or "our") collects, uses, and
discloses information from users ("you" or "your") of the Constable On Patrol (COP) App
("App"). By using the App, you agree to the collection and use of information in accordance
with this policy.

1. Information We Collect

1.1 Personal Information

• Account Information: When you create an account, we collect information such as
your name, mobile number, and any other details you provide.
• Location Data: We collect real-time location information from your device to
provide location-based services for patrolling purposes.

1.2 Non-Personal Information

• Usage Data: We collect information on how the App is accessed and used, including
your interactions within the App, IP address and browser type.

2. How We Use Your Information

2.1 To Provide and Maintain the Service

• To manage user accounts and provide access to the App’s features.
• To track constable locations for effective patrolling.

2.2 To Improve the App

• To analyze usage patterns and improve the App’s functionality and user experience.
• To fix bugs and improve security.

2.3 To Communicate with You

• To send updates, notifications, and administrative messages.

3. Sharing Your Information

3.1 With Law Enforcement

• We may share your information with law enforcement agencies as required by law or
to protect the safety and security of the community.

3.2 With Service Providers

• We may employ third-party companies and individuals to facilitate our service,
perform service-related tasks, or assist us in analyzing how our service is used. These
third parties have access to your information only to perform these tasks on our behalf
and are obligated not to disclose or use it for any other purpose.

4. Data Security

We implement appropriate technical and organizational measures to protect your personal
information from unauthorized access, use, alteration, or destruction. However, no method of
transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee
absolute security.

5. Your Data Rights

5.1 Access and Update

• You have the right to access and update your personal information stored in our
system.

5.2 Deletion

• You can request the deletion of your personal information. We will comply with such
requests to the extent required by law.

6. Children’s Privacy

The App is not intended for use by anyone under the age of 18. We do not knowingly collect
personal information from children under 18. If we become aware that we have collected
personal information from a child under 18 without verification of parental consent, we take
steps to remove that information.

7. Changes to This Privacy Policy

We may update our Privacy Policy from time to time. We will notify you of any changes by
posting the new Privacy Policy on this page. You are advised to review this Privacy

"""
        
        
        let attributedStringPrivacy = NSMutableAttributedString(string: fullTextPrivacy)
        attributedStringPrivacy.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: fullTextPrivacy.count))
        
        let boldRangesPrivacy = [
            (fullTextPrivacy as NSString).range(of: "Privacy Policy for Constable On Patrol (COP) App"),
            (fullTextPrivacy as NSString).range(of: "1. Information We Collect"),
            (fullTextPrivacy as NSString).range(of: "1.1 Personal Information"),
            (fullTextPrivacy as NSString).range(of: "1.2 Non-Personal Information"),
            (fullTextPrivacy as NSString).range(of: "2. How We Use Your Information"),
            (fullTextPrivacy as NSString).range(of: "2.1 To Provide and Maintain the Service"),
            (fullTextPrivacy as NSString).range(of: "2.2 To Improve the App"),
            (fullTextPrivacy as NSString).range(of: "2.3 To Communicate with You"),
            (fullTextPrivacy as NSString).range(of: "3. Sharing Your Information"),
            (fullTextPrivacy as NSString).range(of: "3.1 With Law Enforcement"),
            (fullTextPrivacy as NSString).range(of: "3.2 With Service Providers"),
            (fullTextPrivacy as NSString).range(of: "4. Data Security"),
            (fullTextPrivacy as NSString).range(of: "5. Your Data Rights"),
            (fullTextPrivacy as NSString).range(of: "5.1 Access and Update"),
            (fullTextPrivacy as NSString).range(of: "5.2 Deletion"),
            (fullTextPrivacy as NSString).range(of: "6. Children’s Privacy"),
            (fullTextPrivacy as NSString).range(of: "7. Changes to This Privacy Policy")
            
        ]
        
        let largefontPrivacy = UIFont.boldSystemFont(ofSize: 22)
        
        for range in boldRangesPrivacy {
            attributedStringPrivacy.addAttribute(.font, value: largefontPrivacy, range: range)
        }
        
        privacyPolicytext.attributedText = attributedStringPrivacy
        privacyPolicytext.isEditable = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
