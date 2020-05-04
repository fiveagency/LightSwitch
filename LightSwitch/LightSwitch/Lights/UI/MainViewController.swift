import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {

    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionOfLightViewModels>

    private let disposeBag = DisposeBag()

    private var dataSource: DataSource!
    private var presenter: MainViewPresenter!

    var tableView: UITableView!

    convenience init(mainViewPresenter: MainViewPresenter) {
        self.init()
        self.presenter = mainViewPresenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        buildTableView()
        bindPresenter()
    }

    private func buildTableView() {
        tableView.register(LightCell.self, forCellReuseIdentifier: LightCell.reuseIndetifier)
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false

        dataSource = DataSource(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: LightCell.reuseIndetifier,
                    for: indexPath) as! LightCell

                cell.set(viewModel: item)

                return cell
        })

        tableView
            .rx
            .modelSelected(LightViewModel.self)
            .subscribe(onNext: { [weak self] model in
                self?.presenter.toggleLight(withId: model.id)
            })
            .disposed(by: disposeBag)
    }

    private func bindPresenter() {
        presenter
            .lightData
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}
