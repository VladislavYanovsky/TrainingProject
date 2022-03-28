import UIKit
//import RealmSwift
import Security

class RegistrationViewController: UIViewController {
    
    let cellIdentifier = "CellIdentifier"
    let login = "VladLogin"
    let password = "VladLoingPassword"

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userStatusTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addCredentiToKeychain: UISwitch!
    
    var model = Validator()
    var userViewControllerModel = UserViewControllerModel()
    var activeTextField: UITextField? = nil
    
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let passwordData = password.data(using: String.Encoding.utf8)
//        
//        do {
//            try? KeyChain.save(password: passwordData!, service: "service", account: "akk")
//        } catch let error {
//            debugPrint(error)
//        }
//               
//        var pets = coreDataManager.get()
        setupAddTargetIsNotEmptyTextFields()

        idTextField.delegate = self
        usernameTextField.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        passwordTextField.delegate = self
        userStatusTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let  keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height + 10
            let contentInsert = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            self.scrollView.scrollIndicatorInsets = contentInsert
            self.scrollView.contentInset = contentInsert
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.contentInset = contentInsets
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let barVc = segue.destination as? UITabBarController {
            barVc.viewControllers?.forEach{
                if let navController = $0 as? UINavigationController,
                   let controller = navController.viewControllers.first(where: {$0 is UserViewController}) as? UserViewController,
                   let user = sender as? User {
                   controller.viewModel.currentUser = user
                }
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        do {
            _ = try model.validateID(id: idTextField.text ?? "")
            _ = try model.validateUsername(username: usernameTextField.text ?? "")
            _ = try model.validateFirstName(firstname: firstnameTextField.text ?? "")
            _ = try model.validateLastName(lastname: lastnameTextField.text ?? "")
            _ = try model.validateEmail(email: emailTextField.text ?? "")
            _ = try model.validatePassword(password: passwordTextField.text ?? "")
            _ = try model.validatePhone(phone: phoneTextField.text ?? "")
            _ = try model.validateUserStatus(userStatus: userStatusTextField.text ?? "")
            let user = User(id: Int(idTextField.text!) ?? 0, username: usernameTextField.text!, firstname: firstnameTextField.text!, lastname: lastnameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, phone: phoneTextField.text!, userStatus: Int(userStatusTextField.text!) ?? 0)
//            let userDataBaseModel = RealmUserModel(from: user)
            networkManager.userPostRequest(id: Int(user.id), username: user.username, firstname: user.firstname, lastname: user.lastname, email: user.email, password: user.password, phone: user.phone, userStatus: user.userStatus ?? 0) { result in
                switch result {
                case .success(let createdUser):
                    self.hideActivityIndicator()
                    print("User was created: \(createdUser)")
//                    realmManager.add(user: userDataBaseModel)
                    self.performSegue(withIdentifier: "goToUserViewController", sender: user)
                case .failure(let error):
                    self.hideActivityIndicator()
                    print("POST Error: \(error.localizedDescription)")
                }
            }
        } catch {
            self.hideActivityIndicator()
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            print(error.localizedDescription)
            return
        }
    }
    
  
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            guard let userName = userStatusTextField.text, !userName.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty
            else {return }
            print("ON")
        } else {
            print("OFF")
        }
    }
    

    @IBAction func testButtonPressed(_ sender: UIButton) {
        networkManager.getPets(status: "pending") { result  in
            switch result {
            case.success(let petsList):
            print(petsList)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func  setupAddTargetIsNotEmptyTextFields() {
        loginButton.isEnabled = false
        idTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        firstnameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        lastnameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        userStatusTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }

    @objc func textFieldsIsNotEmpty(sender: UITextField) {
    sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
    guard
        let id = idTextField.text, !id.isEmpty,
        let userName = userStatusTextField.text, !userName.isEmpty,
        let firstName = firstnameTextField.text, !firstName.isEmpty,
        let lastName = lastnameTextField.text, !lastName.isEmpty,
        let email = emailTextField.text, !email.isEmpty,
        let password = passwordTextField.text, !password.isEmpty,
        let phone = phoneTextField.text, !phone.isEmpty,
        let userStatus = userStatusTextField.text, !userStatus.isEmpty
      else{
      self.loginButton.isEnabled = false
      return
    }
    loginButton.isEnabled = true
    }
    
    
}


extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
       self.activeTextField = textField
       print("textFieldDidBeginEditing")
     }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
        print("textFieldDidEndEditing")
      }
}

