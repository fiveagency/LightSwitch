// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import RxSwift
@testable import LightSwitch

class LightsRepositoryProtocolMock: LightsRepositoryProtocol {

    //MARK: - queryAllLights

    var queryAllLightsCallsCount = 0
    var queryAllLightsCalled: Bool {
        return queryAllLightsCallsCount > 0
    }
    var queryAllLightsReturnValue: Observable<[LightModel]>!
    var queryAllLightsClosure: (() -> Observable<[LightModel]>)?

    func queryAllLights() -> Observable<[LightModel]> {
        queryAllLightsCallsCount += 1
        return queryAllLightsClosure.map({ $0() }) ?? queryAllLightsReturnValue
    }
    //MARK: - queryAllLightStates

    var queryAllLightStatesCallsCount = 0
    var queryAllLightStatesCalled: Bool {
        return queryAllLightStatesCallsCount > 0
    }
    var queryAllLightStatesReturnValue: Observable<[LightStateModel]>!
    var queryAllLightStatesClosure: (() -> Observable<[LightStateModel]>)?

    func queryAllLightStates() -> Observable<[LightStateModel]> {
        queryAllLightStatesCallsCount += 1
        return queryAllLightStatesClosure.map({ $0() }) ?? queryAllLightStatesReturnValue
    }
    //MARK: - toggleLight

    var toggleLightCallsCount = 0
    var toggleLightCalled: Bool {
        return toggleLightCallsCount > 0
    }
    var toggleLightReceivedId: Int?
    var toggleLightReceivedInvocations: [Int] = []
    var toggleLightReturnValue: Completable!
    var toggleLightClosure: ((Int) -> Completable)?

    func toggleLight(withId id: Int) -> Completable {
        toggleLightCallsCount += 1
        toggleLightReceivedId = id
        toggleLightReceivedInvocations.append(id)
        return toggleLightClosure.map({ $0(id) }) ?? toggleLightReturnValue
    }
}

