import RxSwift
@testable import LightSwitch

class LightsRepositoryProtocolMock: LightsRepositoryProtocol {

    // MARK: - queryAllLights

    var queryAllLightsReturnValue: Observable<[LightModel]>!
    func queryAllLights() -> Observable<[LightModel]> {
        return queryAllLightsReturnValue
    }

    // MARK: - queryAllLightStates

    var queryAllLightStatesReturnValue: Observable<[LightStateModel]>!
    func queryAllLightStates() -> Observable<[LightStateModel]> {
        return queryAllLightStatesReturnValue
    }

    // MARK: - toggleLight

    var toggleLightCallsCount = 0
    var toggleLightReceivedInvocations: [Int] = []
    var toggleLightReturnValue: Completable!
    func toggleLight(withId id: Int) -> Completable {
        toggleLightCallsCount += 1
        toggleLightReceivedInvocations.append(id)
        return toggleLightReturnValue
    }

}
