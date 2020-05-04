struct LightViewModel: Equatable {

    let id: Int
    let name: String
    let isOn: Bool

    init(from lightWithState: LightWithState) {
        self.id = lightWithState.light.id
        self.name = lightWithState.light.name
        self.isOn = lightWithState.lightState.state == .on ? true : false
    }

}
