@testable import LightSwitch

// sourcery: AutoMockable
extension LightsRepositoryProtocol {}
// sourcery: AutoLenses
extension LightModel {}
// sourcery: AutoLenses
extension LightStateModel {}

extension LightModel: StubProtocol {

    static func stub(withId id: Int = 1) -> Self {
        return LightModel(
            id: id,
            name: "Light \(id)")
    }

}

extension LightStateModel: StubProtocol {

    static func stub(withId id: Int = 1) -> Self {
        return LightStateModel(
            id: id,
            state: .on)
    }

}
