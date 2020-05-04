import UIKit

extension MainViewController {

    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }

    func createViews() {
        tableView = UITableView()
        view.addSubview(tableView)
    }

    func styleViews() {
        tableView.backgroundColor = .clear
        view.backgroundColor = .mainBackgroundColor
    }

    func defineLayoutForViews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 66).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
