//
//  FAQsViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 12/07/24.
//

import UIKit

class FAQsViewController: UIViewController{
    
    @IBOutlet weak var FAQText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullTextFaq = """

Frequently Asked Questions (FAQs) for Constable On Patrol App General Questions

1. What is the Constable On Patrol (COP) App?
The Constable On Patrol (COP) App is an Android application developed in collaboration with the Delhi Police to enhance foot patrolling effectiveness. It features real-time constable tracking, a dynamic crime map, jurisdiction-based crime monitoring, and public feedback mechanisms.

2. Who developed the COP App?
The COP App was developed by SKILLOP Society members in Delhi Technological University in collaboration with the Delhi Police.

3. Who can use the COP App?
The app is primarily intended for use by Delhi Police constables and SHOs (Station House Officers) and Top Official.
Technical Questions

4. How do I download the COP App?
You can download the COP App from the link provided by the Developers. Search for "Constable On Patrol" and follow the instructions to install it on your Android device.

5. What are the system requirements for the COP App?
The COP App requires an Android device running Android version 5.0 (Lollipop) or higher with an active internet connection for real-time features.

6. How do I create an account on the COP App?
To create an account, download the app and follow the registration process. Provide accurate information during registration.

7. How do I update my personal information in the app?
You can update your personal information in the app's account settings section.

8. How does the real-time tracking feature work?
The real-time tracking feature uses GPS technology to track constable locations, facilitating coordinated patrolling efforts.

9. What should I do if I encounter a bug or technical issue?
Report bugs or technical issues through the app's support section or contact us at ekanshbhushan@gmail.com or +91 9643654899.

Functional Questions

10. How does the crime map feature work?
The crime map divides Delhi into zones based on crime frequency, aiding constables and SHOs in focusing on high-crime areas.

11. How can the public provide feedback through the app?
The app includes a feedback section where the public can submit comments, suggestions, or complaints directly to the police.

12. How can Top Official use the app to monitor crime in their jurisdiction? 
Top Official can view crime data within their jurisdiction, helping them allocate resources effectively and monitor crime trends.

Security and Privacy Questions

13. How is my data protected in the COP App?
The COP App uses encryption and secure servers to protect user data. Refer to our Privacy Policy for detailed data protection measures.

14. What data does the COP App collect?
The app collects necessary data such as constable locations and crime reports. Detailed information is available in our Privacy Policy.

15. Can I opt out of data collection?
Certain data collection is essential for app functionality. Manage privacy settings within the app; see our Privacy Policy for details.

Miscellaneous Questions

16. Will there be updates to the COP App?
Yes, SKILLOP Society will provide updates including bug fixes, feature enhancements, and improvements. Install updates promptly for optimal app performance.

17. How can I suggest new features for the app?
Submit feature suggestions through the app's feedback section or contact us directly at ekanshbhushan@gmail.com or +91 9643654899.

18. Who should I contact for further questions or support?
For further questions or support, contact us at ekanshbhushan@gmail.com or +91 9643654899.
By using the COP App, you agree to these Terms and our Privacy Policy. If you have any concerns or queries, please reach out to us

"""
        
        let attributedString = NSMutableAttributedString(string: fullTextFaq)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: fullTextFaq.count))
        
        let boldRanges = [
            (fullTextFaq as NSString).range(of: "Frequently Asked Questions (FAQs) for Constable On Patrol App General Questions"),
            (fullTextFaq as NSString).range(of: "1. What is the Constable On Patrol (COP) App?"),
            (fullTextFaq as NSString).range(of: "2. Who developed the COP App?"),
            (fullTextFaq as NSString).range(of: "3. Who can use the COP App?"),
            (fullTextFaq as NSString).range(of: "4. How do I download the COP App?"),
            (fullTextFaq as NSString).range(of: "5. What are the system requirements for the COP App?"),
            (fullTextFaq as NSString).range(of: "6. How do I create an account on the COP App?"),
            (fullTextFaq as NSString).range(of: "7. How do I update my personal information in the app?"),
            (fullTextFaq as NSString).range(of: "8. How does the real-time tracking feature work?"),
            (fullTextFaq as NSString).range(of: "9. What should I do if I encounter a bug or technical issue?"),
            (fullTextFaq as NSString).range(of: "Functional Questions"),
            (fullTextFaq as NSString).range(of: "10. How does the crime map feature work?"),
            (fullTextFaq as NSString).range(of: "11. How can the public provide feedback through the app?"),
            (fullTextFaq as NSString).range(of: "12. How can Top Official use the app to monitor crime in their jurisdiction? "),
            (fullTextFaq as NSString).range(of: "Security and Privacy Questions"),
            (fullTextFaq as NSString).range(of: "13. How is my data protected in the COP App?"),
            (fullTextFaq as NSString).range(of: "14. What data does the COP App collect?"),
            (fullTextFaq as NSString).range(of: "15. Can I opt out of data collection?"),
            (fullTextFaq as NSString).range(of: "Miscellaneous Questions"),
            (fullTextFaq as NSString).range(of: "16. Will there be updates to the COP App?"),
            (fullTextFaq as NSString).range(of: "17. How can I suggest new features for the app?"),
            (fullTextFaq as NSString).range(of: "18. Who should I contact for further questions or support?")
        ]
        let largefont = UIFont.boldSystemFont(ofSize: 22)
        
        for range in boldRanges{
            attributedString.addAttribute(.font, value: largefont , range: range)
        }
        
        FAQText.attributedText = attributedString
        
        FAQText.isEditable = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
