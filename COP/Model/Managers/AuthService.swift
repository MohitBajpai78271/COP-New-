//
//  AuthService.swift
//  ConstableOnPatrol
//
//  Created by Mac on 15/07/24.
//

import UIKit
import Alamofire

class AuthService{
    
    static let shared = AuthService()
    let baseURL = "http://93.127.172.217:4000"
    private let session = URLSession.shared
    private let storage = UserDefaults.standard
    
     public let userDefaults = UserDefaults.standard
     public let signedInKey = "isSignedIn"
    

     
     public init() {}
     
     var isSignedIn: Bool {
         get {
             return userDefaults.bool(forKey: signedInKey)
         }
         set {
             userDefaults.set(newValue, forKey: signedInKey)
         }
     }
    
    //MARK: - Get OTP
    
    func getOTP(phoneNumber: String,completion: @escaping(OTPResponse?, Error?)->Void){
        let urlString = "\(baseURL)/api/send-otp"
        
        let parameters: [String: Any] = ["phoneNumber": phoneNumber]
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: OTPResponse.self) { response in
                if let data = response.data {
                    print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
                    do {
                        let otpResponse = try JSONDecoder().decode(OTPResponse.self, from: data)
                        completion(otpResponse, nil)
                    } catch let decodeError {
                        print("Decoding Error: \(decodeError)")
                        completion(nil, decodeError)
                    }
                } else {
                    print("No data in response")
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data in response"]))
                }
            }
    }
  
    //MARK: - Verify OTP
    
    func verifyOtp(phoneNumber: String, otp: String, isSignUp: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = isSignUp ? "/api/verify-otp" : "/api/verify-otp-signIn"
          guard let url = URL(string: "\(baseURL)\(endpoint)") else {
              completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
              return
          }
          
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
          
          let body = ["phoneNumber": phoneNumber, "otp": otp]
          request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
          
          let task = session.dataTask(with: request) { data, response, error in
              if let error = error {
                  print("Invalid response received.")
                  completion(.failure(error))
                  return
              }
              
              guard let response = response as? HTTPURLResponse else {
                  completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                  return
              }
              
              if let data = data {
                         // Print raw response data for debugging
                         print("Response data: \(String(describing: String(data: data, encoding: .utf8)))")
                         
                         // Parse JSON response
                         do {
                             if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                 // Extract userRole and token from JSON response if available
                                 if let userRole = jsonResponse["userRole"] as? String {
                                     print("User role from response: \(userRole)")
                                     // Store userRole in UserDefaults
                                     UserDefaults.standard.set(userRole, forKey: "userRole")
                                 }
                                 
                                 if let token = jsonResponse["token"] as? String {
                                     print("Token from response: \(token)")
                                     // Store token in UserDefaults
                                     UserDefaults.standard.set(token, forKey: "x-auth-token")
                                 }
                                 if let userName = jsonResponse["userName"] as? String {
                                     print("Token from response: \(userName)")
                                     // Store token in UserDefaults
                                     UserDefaults.standard.set(userName, forKey: "userName")
                                 }
                                 if let dateOfBirth = jsonResponse["dateOfBirth"] as? String {
                                     print("Token from response: \(dateOfBirth)")
                                     // Store token in UserDefaults
                                     UserDefaults.standard.set(dateOfBirth, forKey: "dateOfBirth")
                                 }
                                 if let address = jsonResponse["address"] as? String {
                                     print("Token from response: \(address)")
                                     // Store token in UserDefaults
                                     UserDefaults.standard.set(address, forKey: "address")
                                 }
                                 
                             }
                         } catch {
                             print("Failed to parse response data: \(error.localizedDescription)")
                         }
                     }
                     
              switch response.statusCode {
              case 200:
                  completion(.success(()))
              case 401:
                  let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid OTP or unauthorized"])
                  completion(.failure(error))
              case 409:
                       let error = NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "User already exists. Try logging in h."])
                       completion(.failure(error))
              default:
                  let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])
                  completion(.failure(error))
              }
          }
          task.resume()
     }
    
    func existingUser(phoneNumber: String, otp: String, completion: @escaping (OTPResponse?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/api/verify-otp-signIn")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = ["phoneNumber": phoneNumber, "otp": otp]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data in response"]))
                return
            }
            
            do {
                let otpResponse = try JSONDecoder().decode(OTPResponse.self, from: data)
                completion(otpResponse, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    //MARK: - LogOut
    
    func logOut(phoneNumber: String, context: UIViewController) {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Logout implementation
            guard let url = URL(string: "http://93.127.172.217:4000/api/logout") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            request.httpMethod = "POST"
            
            do {
                request.httpBody = try JSONEncoder().encode(["phoneNumber": phoneNumber])
            } catch {
                print("Failed to encode phone number: \(error)")
                return
            }
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // Add any required headers, e.g., authorization token
            if let token = UserDefaults.standard.string(forKey: "x-auth-token") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showSnackBar(context: context, message: "Failed to log out: \(error.localizedDescription)")
                    }
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        // Remove sign-in number from data
                        UserDefaults.standard.removeObject(forKey: "x-auth-token")
                        UserDefaults.standard.removeObject(forKey: "userPhoneNumber")
                        UserDefaults.standard.removeObject(forKey: "userRole")
                        UserDefaults.standard.removeObject(forKey: "phoneNumberSignUp")
                        UserDefaults.standard.removeObject(forKey: "userName")
                        UserDefaults.standard.removeObject(forKey: "dateOfBirth")
                        UserDefaults.standard.removeObject(forKey: "address")
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        print("Token removed, transitioning to SignInViwController")
                        
                        // Go back to signIn page
                        DispatchQueue.main.async {
                            // Setting the root view controller to SignInViewController
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                               let window = appDelegate.window {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViwController") // Ensure the identifier matches your storyboard
                                window.rootViewController = UINavigationController(rootViewController: signInVC)
                                window.makeKeyAndVisible()
                                context.performSegue(withIdentifier: "SegueToSignin", sender: context)
                            }
                            
                            self.showSnackBar(context: context, message: "User logged out successfully")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showSnackBar(context: context, message: "Failed to log out: Server responded with status code \(response.statusCode)")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showSnackBar(context: context, message: "Failed to log out: Invalid server response")
                    }
                }
            }.resume()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        context.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - ShowSnackBar
    
      func showSnackBar(context: UIViewController, message: String) {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.view.backgroundColor = .black
            alertController.view.alpha = 0.5
            alertController.view.layer.cornerRadius = 15
            
            context.present(alertController, animated: true) {
                DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
        }
    
    //MARK: - Create User
    
    func createUser(context: UIViewController, userName: String, phoneNumber: String, dateOfBirth: String, gender: String, address: String, completion: @escaping () -> Void) {
        let url = URL(string: "http://93.127.172.217:4000/users/user-token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        // Creating the user dictionary with all required fields
        let user: [String: Any] = [
            "userRole": "", // Ensure this is set if required by the API
            "id": "",       // Ensure this is set if required by the API
            "token": "",    // Ensure this is set if required by the API
            "userName": userName,
            "phoneNumber": phoneNumber,
            "gender": gender,
            "address": address,
            "dateOfBirth": dateOfBirth
        ]
        
        // Convert the dictionary to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: user, options: [])
        } catch {
            DispatchQueue.main.async {
                self.showSnackBar(context: context, message: "Failed to create user request body")
            }
            return
        }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for network errors
            if let error = error {
                DispatchQueue.main.async {
                    self.showSnackBar(context: context, message: "Network error: \(error.localizedDescription)")
                }
                return
            }
            
            // Check for valid response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.showSnackBar(context: context, message: "Failed to create user. Status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                }
                return
            }
            
            // Check if data is received
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showSnackBar(context: context, message: "No data received from server")
                }
                return
            }
            
            // Parse the JSON response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let token = json["token"] as? String, let userRole = json["userRole"] as? String  {
                        

                        UserDefaults.standard.set(token, forKey: "x-auth-token")
                        UserDefaults.standard.set(userRole, forKey: "userRole")
                        
                        DispatchQueue.main.async {
                            self.showSnackBar(context: context, message: "User created successfully")
//                            context.performSegue(withIdentifier: "detailsToTab", sender: context)
                            completion()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showSnackBar(context: context, message: "Token not found in response")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showSnackBar(context: context, message: "Failed to parse create user response: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
        }
    
    //MARK: - ???
    
    func getUserData(context: UIViewController, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "x-auth-token") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No token found"])))
            return
        }

        let url = URL(string: "http://93.127.172.217:4000/user-tokenIsValid")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "x-auth-token")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user data"])))
                return
            }

            do {
                if let userData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Save the user data to UserDefaults
                    if let phoneNumber = userData["phoneNumber"] as? String {
                        UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                    }
                    if let userName = userData["userName"] as? String {
                        UserDefaults.standard.set(userName, forKey: "userName")
                    }
                    if let address = userData["address"] as? String {
                        UserDefaults.standard.set(address, forKey: "address")
                    }
                    if let dateOfBirth = userData["dateOfBirth"] as? String {
                        UserDefaults.standard.set(dateOfBirth, forKey: "dateOfBirth")
                    }
                    UserDefaults.standard.synchronize()
                    
                    completion(.success(userData))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    func updateUser(context: UIViewController, phoneNumber: String, userName: String, address: String, dateOfBirth: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "x-auth-token") else {
            showSnackBar(context: context, message: "No token found")
            return
        }

        let url = URL(string: "http://93.127.172.217:4000/update-userdata")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-auth-token")

        let updateData: [String: Any] = [
            "phoneNumber": phoneNumber,
            "userName": userName,
            "address": address,
            "dateOfBirth": dateOfBirth
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: updateData, options: [])
        } catch {
            showSnackBar(context: context, message: "Failed to create update request body")
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showSnackBar(context: context, message: "Failed to update user data")
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.showSnackBar(context: context, message: "Invalid server response")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                }
                return
            }

            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    // Fetch the updated user data
                    self.getUserData(context: context) { result in
                        switch result {
                        case .success:
                            self.showSnackBar(context: context, message: "Profile updated successfully")
                            completion(.success(()))
                        case .failure(let error):
                            self.showSnackBar(context: context, message: "Failed to fetch updated user data")
                            completion(.failure(error))
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showSnackBar(context: context, message: "Failed to update user data")
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)))
                }
            }
        }

        task.resume()
    }

    }
extension Dictionary {
    func toJsonData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}

//"http://93.127.172.217:4000/update-userdata"
//http://93.127.172.217:4000/user-tokenIsValid"
//http://93.127.172.217:4000/user-token
