
import UIKit
import CoreData

class PetsListViewController: UIViewController {
    
    @IBOutlet weak var petsListTableView: UITableView!
    
    let cellIdentifier = "CellIdentifier"
    let login = "VladLogin"
    let password = "VladLoingPassword"
    
    lazy var fetchedResultsController: NSFetchedResultsController<PetEntity> = {
        let fetchRequest: NSFetchRequest<PetEntity> = PetEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController (
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataManager.getViewContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        
        networkManager.userLogin(username: login, password:password) { result in
            switch result {
            case .success(let object):
                print("OK")
                print(object)
            case .failure(let error):
                print("Failure", error.localizedDescription)
            }
        }
    }
}

extension PetsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = petsListTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let pet = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = pet.name
        return cell
    }
}

extension PetsListViewController: NSFetchedResultsControllerDelegate {
    
}


