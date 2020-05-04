enum LightStateType {

    case on
    case off

    var toggledValue: Self {
        switch self {
        case .on:
            return .off
        case .off:
            return .on
        }
    }

}
