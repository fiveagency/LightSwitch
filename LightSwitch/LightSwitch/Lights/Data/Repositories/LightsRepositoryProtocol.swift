import RxSwift

protocol LightsRepositoryProtocol {

    func queryAllLights() -> Observable<[LightModel]>

    func queryAllLightStates() -> Observable<[LightStateModel]>

    func toggleLight(withId id: Int) -> Completable

}
