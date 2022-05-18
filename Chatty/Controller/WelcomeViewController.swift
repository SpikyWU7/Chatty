import UIKit
import CLTypingLabel

final class WelcomeViewController: UIViewController {

    @IBOutlet private var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = K.appName
    }
}
