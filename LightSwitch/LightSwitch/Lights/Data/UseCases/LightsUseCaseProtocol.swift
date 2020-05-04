import RxSwift

protocol LightsUseCaseProtocol {

    func queryLightsWithState() -> Observable<[LightWithState]>

    func areAllLightsOff() -> Observable<Bool>

    func toggleLight(withId id: Int) -> Completable

}
