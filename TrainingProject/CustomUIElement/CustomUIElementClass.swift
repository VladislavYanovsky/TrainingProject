
import UIKit

protocol CustomUIElementClassDelegate: AnyObject {
    func didButtonPressed()
}

class CustomUIElementClass: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: CustomUIElementClassDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView = loadViewFromNib(nibName: "CustomUIElement")
        contentView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    private func loadViewFromNib(nibName: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func deleteButtonPressd(_ sender: UIButton) {
        delegate?.didButtonPressed()
        textLabel.text = "Highlighted"
    }
        
    @IBAction func TouchDown(_ sender: Any) {
        textLabel.text = "Highlighted"
    }

    @IBAction func TouchCancel(_ sender: UIButton, forEvent event: UIEvent) {
        textLabel.text = "Normal"
    }
}
