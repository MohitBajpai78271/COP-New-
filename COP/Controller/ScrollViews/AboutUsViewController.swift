//
//  AboutUsViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 12/07/24.
//

import UIKit

class AboutUsViewController: UIViewController{
    
    @IBOutlet weak var AboutUsText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullTextAboutUs = """

Introduction to the Constable On Patrol (COP) App

The Constable On Patrol (COP) is a cutting-edge Android application developed in
collaboration with the Delhi Police to enhance foot patrolling and improve public safety in
Delhi. The app is designed to provide comprehensive tools for constables and top officials,
streamlining operations and enabling data-driven decision-making.

Key Features:

• Real-Time Constable Tracking: The app tracks the location of constables in realtime, ensuring coordinated and efficient patrolling efforts across different areas of
Delhi.
• Dynamic Crime Mapping: The crime map dynamically updates to show the
frequency and types of crimes occurring in various zones. This feature helps
constables focus their efforts on high-crime areas and enables top officials to monitor
and analyze crime patterns effectively.
• Detailed Map View: Constables can view detailed maps that highlight the types and
dates of crimes in specific areas. This allows for better situational awareness and
strategic patrolling to control and reduce crime rates in Delhi.
• Admin Panel for Top Officials: The app includes an admin panel accessible only to
top officials. This panel allows them to:
      o Insert crime data, which automatically updates on the map and shows crime
statistics across Delhi.
      o Assign duties to constables and track their activities.
      o Add new police personnel to the system.
      o Ensure effective patrolling and resource allocation based on real-time data.

Security Features:

• Secure Access: Only specific users can access the admin panel through their mobile
number and password. The password cannot be changed once created, and it is
securely hidden during input on the login screen.
• Role-Based Access: The backend supports OTP-based login and role-based access
control, ensuring that only authorized personnel can use the app and access sensitive
data.
• Data Protection: The backend is designed to prevent any illegal changes to the
database, ensuring that all data is kept secure. Without logging into the admin panel,
no user can access the database in any form.

To visit the admin panel, go to delhicop.in.

The COP App is developed by Ekansh Bhushan, Gaurav Pandey, Ritik Pal, Mohit Bajpai,Harsh, Mohd
Ahmed Faeez, Simran Rojia, Dhruv Dawar, Hemang Jain, Saksham Jain, Rudreshwar Singh,
Hitesh Gupta, Devyansh Bhattacharya, and Ashwani Yaduvanshi, members of the SKILLOP
society at Delhi Technological University.

The COP App combines advanced technology with practical features to support the Delhi
Police in maintaining law and order, enhancing public safety, and efficiently managing police
resources.

"""
        let attributedStringAboutUs = NSMutableAttributedString(string: fullTextAboutUs)
        attributedStringAboutUs.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: fullTextAboutUs.count))
        
        let boldRangesAboutUs = [
        (fullTextAboutUs as NSString).range(of: "Introduction to the Constable On Patrol (COP) App"),
        (fullTextAboutUs as NSString).range(of: "Key Features:"),
        (fullTextAboutUs as NSString).range(of: "Real-Time Constable Tracking:"),
        (fullTextAboutUs as NSString).range(of: "Dynamic Crime Mapping: "),
        (fullTextAboutUs as NSString).range(of: "Detailed Map View:"),
        (fullTextAboutUs as NSString).range(of: "Admin Panel for Top Officials:"),
        (fullTextAboutUs as NSString).range(of: "Security Features:"),
        (fullTextAboutUs as NSString).range(of: "Secure Access:"),
        (fullTextAboutUs as NSString).range(of: "Role-Based Access:"),
        (fullTextAboutUs as NSString).range(of: "Data Protection: ")
        ]
        
        let largefontAboutUs = UIFont.boldSystemFont(ofSize: 22)
        
        for range in boldRangesAboutUs{
            attributedStringAboutUs.addAttribute(.font, value: largefontAboutUs, range: range)
        }
        
        AboutUsText.attributedText = attributedStringAboutUs
        AboutUsText.isEditable = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
