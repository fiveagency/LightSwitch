import RxSwift
import RxCocoa

class LightsRepository: LightsRepositoryProtocol {

    private let lightModelRelay = BehaviorRelay<[LightModel]>(value: [])
    private let lightStateModelRelay = BehaviorRelay<[LightStateModel]>(value: [])

    init() {
        lightModelRelay.accept(LightsRepositoryData.lightModels)
        lightStateModelRelay.accept(LightsRepositoryData.lightStateModels)
    }

    func queryAllLights() -> Observable<[LightModel]> {
        return lightModelRelay.asObservable()
    }

    func queryAllLightStates() -> Observable<[LightStateModel]> {
        return lightStateModelRelay.asObservable()
    }

    func toggleLight(withId id: Int) -> Completable {
        var currentLightStateModels = lightStateModelRelay.value
        guard let index = currentLightStateModels.firstIndex(where: { $0.id == id }) else { return .empty() }

        let currentState = currentLightStateModels[index]
        let newState = LightStateModel(id: currentState.id, state: currentState.state.toggledValue)
        currentLightStateModels[index] = newState
        lightStateModelRelay.accept(currentLightStateModels)

        return .empty()
    }

}
