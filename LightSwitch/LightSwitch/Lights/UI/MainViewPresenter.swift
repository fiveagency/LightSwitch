import RxSwift

class MainViewPresenter {

    private var lightsUseCase: LightsUseCaseProtocol!
    private var disposeBag: DisposeBag!

    var lightData: Observable<[SectionOfLightViewModels]> {
        return lightsUseCase
            .queryLightsWithState()
            .map { lightsWithState in
                let viewModels = lightsWithState.map { LightViewModel(from: $0) }

                return [SectionOfLightViewModels(header: "Lights", items: viewModels)]
            }
    }

    var areAllLightsOff: Observable<Bool> {
        return lightsUseCase
            .areAllLightsOff()
            .distinctUntilChanged()
    }

    init(lightsUseCase: LightsUseCaseProtocol) {
        self.lightsUseCase = lightsUseCase
        self.disposeBag = DisposeBag()
    }

    func toggleLight(withId id: Int) {
        lightsUseCase
            .toggleLight(withId: id)
            .subscribe()
            .disposed(by: disposeBag)
    }

}
