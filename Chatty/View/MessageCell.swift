import UIKit

final class MessageCell: UITableViewCell {

    @IBOutlet private var messageBubble: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet private var rightImageView: UIImageView!
    @IBOutlet private var leftImageView: UIImageView!
    
    func setup(isSender: Bool) {
        if isSender {
            leftImageView.isHidden = true
            rightImageView.isHidden = false
            messageBubble.backgroundColor = UIColor(named: K.BrandColors.navyBlue)
            label.textColor = UIColor(named: K.BrandColors.lightBlue)
        } else {
            leftImageView.isHidden = false
            rightImageView.isHidden = true
            messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightBlue)
            label.textColor = UIColor(named: K.BrandColors.navyBlue)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }
    
}
