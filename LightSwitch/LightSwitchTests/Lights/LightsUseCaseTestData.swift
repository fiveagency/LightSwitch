@testable import LightSwitch

extension LightModel: StubProtocol {

    static func stub(withId id: Int = 1) -> Self {
        return LightModel(
            id: id,
            name: "Light \(id)")
    }

}

extension LightModel {

    func modify(
        id: Int? = nil,
        name: String? = nil
    ) -> Self {
        return LightModel(
            id: id ?? self.id,
            name: name ?? self.name)
    }

}

extension LightStateModel: StubProtocol {

    static func stub(withId id: Int = 1) -> Self {
        return LightStateModel(
            id: id,
            state: .on)
    }

}

extension LightStateModel {

    func modify(
        id: Int? = nil,
        state: LightStateType? = nil
    ) -> Self {
        return LightStateModel(
            id: id ?? self.id,
            state: state ?? self.state)
    }

}
