import UIKit
import RxSwift

class LightCell: UITableViewCell {

    static let reuseIndetifier = String(describing: LightCell.self)

    var containerView: UIView!
    var lightName: UILabel!
    var lightImageView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        lightName.text = nil
    }

    func set(viewModel: LightViewModel) {
        lightName.text = viewModel.name
        lightImageView.image = viewModel.isOn ? .lightBulbOn : .lightBulbOff
    }

}
