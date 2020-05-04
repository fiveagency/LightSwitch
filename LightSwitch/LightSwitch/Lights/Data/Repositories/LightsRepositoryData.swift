struct LightsRepositoryData {

    static let lightModels: [LightModel] = [
        LightModel(id: 1, name: "Kitchen Lights"),
        LightModel(id: 2, name: "Bathroom Lights"),
        LightModel(id: 3, name: "Garden Lights")
    ]

    static let lightStateModels: [LightStateModel] = [
        LightStateModel(id: 1, state: .on),
        LightStateModel(id: 2, state: .off),
        LightStateModel(id: 3, state: .off)
    ]

}
