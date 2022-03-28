
import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var customView: CustomUIElementClass!
    
    var buttonON = false
    var viewModel = UserViewControllerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        customView.delegate = self

    }
    
    func updateUI(user: User) {
            self.idLabel.text = "\(String(describing: viewModel.currentUser?.id))"
            self.userNameTextField.text = viewModel.currentUser?.username
            self.firstNameLabel.text = viewModel.currentUser?.firstname
            self.lastNameLabel.text = viewModel.currentUser?.lastname
            self.emailLabel.text = viewModel.currentUser?.email
            self.passwordTextField.text = viewModel.currentUser?.password
            self.phoneLabel.text = viewModel.currentUser?.phone
            self.userStatusLabel.text = "\(String(describing: viewModel.currentUser?.userStatus))"
        
        passwordButton.setImage(viewModel.closeEye, for: .normal)
        passwordTextField.isSecureTextEntry = false
        passwordButton.alpha = 1
    }
    
    func hidePassword() {
        passwordTextField.alpha = 1
        passwordButton.alpha = 1
        passwordTextField.isSecureTextEntry = false
    }
    
    func showPassword() {
        passwordTextField.alpha = 0.5
        passwordButton.alpha = 0.5
        passwordTextField.isSecureTextEntry = true
    }
    
    func showAlert(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] result in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            guard let userName = self.viewModel.currentUser?.username else { return }
            networkManager.userDeleteRequest(username: userName) { [weak self] result in
                guard self != nil else {return}
                switch result{
                case .success(_):
                    print("User was deleted")
//                    realmManager.delete(username: userName)
                case .failure(let error):
                    print("Error is:", error.localizedDescription)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        vc.present(alert,animated: true)
    }
    
    @IBAction func showHidePasswordButtonPressed(_ sender: Any) {
        if buttonON {
            hidePassword()
            passwordButton.setImage(viewModel.closeEye, for: .normal)
        } else {
            showPassword()
            passwordButton.setImage(viewModel.openEye, for: .normal)
        }
        buttonON = !buttonON
    }
}

extension UserViewController: CustomUIElementClassDelegate {
    func didButtonPressed() {
        showAlert(vc: self, title: "Delete", message: "Are you sure?")
    }
}

