import RxSwift

class MainViewPresenter {

    private var lightsUseCase: LightsUseCaseProtocol!

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
    }

    func toggleLight(withId id: Int) -> Completable {
        return lightsUseCase.toggleLight(withId: id)
    }

}
