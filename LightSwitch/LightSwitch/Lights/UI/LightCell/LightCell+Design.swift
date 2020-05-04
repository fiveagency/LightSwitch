import UIKit

extension LightCell {

    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }

    func createViews() {
        containerView = UIView()
        addSubview(containerView)

        lightName = UILabel()
        containerView.addSubview(lightName)

        lightImageView = UIImageView()
        containerView.addSubview(lightImageView)
    }

    func styleViews() {
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        addGradient()
        backgroundColor = .clear
        selectionStyle = .none
    }

    func defineLayoutForViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        lightName.translatesAutoresizingMaskIntoConstraints = false
        lightImageView.translatesAutoresizingMaskIntoConstraints = false

        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true

        lightName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 11).isActive = true
        lightName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 11).isActive = true
        lightName.trailingAnchor.constraint(equalTo: lightImageView.leadingAnchor, constant: 11).isActive = true

        lightImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -11).isActive = true
        lightImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        lightImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        lightImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        lightImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        lightImageView.contentMode = .scaleAspectFit
    }

    private func addGradient() {
        let startGradientColor = UIColor.cellGradientStart.cgColor
        let endGradientColor = UIColor.cellGradientEnd.cgColor
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
        gradientLayer.colors = [startGradientColor, endGradientColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        self.containerView.layer.insertSublayer(gradientLayer, at: 0)
    }

}
