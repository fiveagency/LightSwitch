import RxSwift

class LightsUseCase: LightsUseCaseProtocol {

    private let lightsRepository: LightsRepositoryProtocol

    init(lightsRepository: LightsRepositoryProtocol) {
        self.lightsRepository = lightsRepository
    }

    private lazy var lightsWithState: Observable<[LightWithState]> = {
        let lightModels = lightsRepository.queryAllLights()
        let lightStates = lightsRepository.queryAllLightStates()

        return Observable
            .combineLatest(lightModels, lightStates)
            .map { lightModels, lightStates -> [LightWithState] in
                let lightStatesById = Dictionary(grouping: lightStates, by: { $0.id })

                return lightModels
                    .compactMap { lightModel in
                        guard let lightState = lightStates.first(where: { $0.id == lightModel.id }) else { return nil }

                        return LightWithState(light: lightModel, lightState: lightState)
                }
        }
    }()

    func queryLightsWithState() -> Observable<[LightWithState]> {
        return lightsWithState
    }

    func areAllLightsOff() -> Observable<Bool> {
        return queryLightsWithState()
            .map { lightWithState -> Bool in
                lightWithState.allSatisfy { $0.lightState.state == .off }
        }
    }

    func toggleLight(withId id: Int) -> Completable {
        return lightsRepository.toggleLight(withId: id)
    }

}
