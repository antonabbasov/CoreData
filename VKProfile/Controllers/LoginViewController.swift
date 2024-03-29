

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var repository: UserRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repository = UserRepository()
        
        createDemoUser()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func createDemoUser() {
        let demoUserCreatedKey = "demoUserCreated"
        if !UserDefaults.standard.bool(forKey: demoUserCreatedKey) {
            let user = UserVK(name: "Anton", surname: "Abbasov", email: "yet@igmail.com", phoneNumber: "+79127015554", age: 21, city: "Kirov", password: "1234567")
            let secondUser = UserVK(name: "Rinat", surname: "Misha", email: "YADEBIL@icloud.com", phoneNumber: "89193456789", age: 19, city: "Казань", password: "qwe123")
            if !(repository.syncSave(with: user) && repository.syncSave(with: secondUser)) {
                self.showDatabaseSaveError()
            }
            UserDefaults.standard.set(true, forKey: demoUserCreatedKey)
        }
    }
    
    @IBAction func onLoginClick(_ sender: UIButton) {
        let errorLoginMessage = "Неверный логин/пароль"
        let errorTitle = "Ошибка"
        let alertButtonOk = "Понятно"
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.shake()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.shake()
            return
        }
        
        if let userManaged = repository.check(with: email, and: password) {
            UserRepository.currentUser = userManaged
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainPageNVC = storyboard.instantiateViewController(withIdentifier: "mainPageNavigationVC") as! UINavigationController
            guard let mainPageVC = mainPageNVC.viewControllers.first as? ViewController else { return }
            
            let userVK = UserVK(from: userManaged)
            mainPageVC.userVK = userVK
            UserDefaults.standard.set(userVK.id, forKey: userIdKey)
            
            present(mainPageNVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: errorTitle, message: errorLoginMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: alertButtonOk, style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    

}
