
import UIKit
import CoreData

class PetsListTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static let identifier = "PetsListTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "PetsListTableViewCell",
                     bundle: nil)
    }
    
    func configure(with pets: PetEntity) {
        self.NameLabel.text = String(pets.id)
    }
}
