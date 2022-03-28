import UIKit
import Foundation
import Security

class PetViewController: UIViewController {
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNamelabel: UILabel!

    var currentPet: PetsResponseData?
    let identifier = "Local Norification #" + UUID().uuidString


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let petName = currentPet?.name else { return }
        self.petNamelabel.text = petName
        let swipeAction = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture(sender:)))
        view.addGestureRecognizer(swipeAction)
        swipeAction.direction = .down
       
    }
    
    @objc private func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        Notifications.shared.scheduleNotification(notificationType: identifier)
    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }

    func showImagePickerActionSheet() {
        
        let alertVC = UIAlertController(title: "Select", message: "Store or camera", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "camera", style: .default) { [weak self] (action) in
            
            guard let self = self else { return }
            
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.present(cameraImagePicker, animated: true) {}
        }

            let libraryAction = UIAlertAction(title: "library", style: .default) { [weak self] (action) in
    
                guard let self = self else { return }
                
                let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
                libraryImagePicker.delegate = self
                self.present(libraryImagePicker, animated: true) {}
            }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
        }

    @IBAction func ImagePickerButtonPressed(_ sender: Any) {
       showImagePickerActionSheet()
    }
}


enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}


extension PetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            guard let image = info[.originalImage] as? UIImage else { return }

            self.petImageView.image = image
            self.petImageView.contentMode = .scaleToFill
            let fileName = UUID().uuidString + ".png"
            
            guard let id = currentPet?.id else { return }
    
            networkManager.uploadPetPhoto(id: id, paramName: "file", fileName: fileName, image: image)
   
            dismiss(animated: true, completion: nil)
        }
}
