import RxDataSources

struct SectionOfLightViewModels {

    var header: String
    var items: [Item]

}

extension SectionOfLightViewModels: SectionModelType {

    typealias Item = LightViewModel

    init(original: SectionOfLightViewModels, items: [Item]) {
        self = original
        self.items = items
    }

}
