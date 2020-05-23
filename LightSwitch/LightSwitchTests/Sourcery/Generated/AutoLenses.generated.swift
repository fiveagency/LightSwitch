// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@testable import LightSwitch

// swiftlint:disable variable_name

struct Lens<Whole, Part> {

    let get: (Whole) -> Part
    let set: (Part, Whole) -> Whole

    var affine: Affine<Whole, Part> {
        return Affine<Whole, Part>(
            tryGet: self.get,
            trySet: self.set
        )
    }

    /**
    Compose operator for lenses that allows us to make changes to nested structs.

    - Returns: Composition of two lenses

    Example usage:
    ```
    struct House {
        let location: Location
        ...
    }

    struct Location {
        let address: Address
        ...
    }

    struct Address {
        let streetName: String
        ...
    }

    let someAddress = Address(streetName: "Broadway", ...)
    let someLocation = Location(address: someAddress, ...)
    let someHouse = House(location: someLocation, ...)

    let houseLocationStreetLens = (House.locationLens * Location.addressLens * Address.streetNameLens)
    houseLocationStreetLens.set("Hollywood Bld", someHouse)
    ```
    */
    static func * <Subpart>(lhs: Lens<Whole, Part>, rhs: Lens<Part, Subpart>) -> Lens<Whole, Subpart> {
        return Lens<Whole, Subpart>(
            get: { whole in rhs.get(lhs.get(whole)) },
            set: { subpart, whole in lhs.set(rhs.set(subpart, lhs.get(whole)), whole) }
        )
    }

    static func * <Subpart>(lhs: Lens<Whole, Part>, rhs: Affine<Part, Subpart>) -> Affine<Whole, Subpart> {
        return lhs.affine * rhs
    }

    static func * <Subpart>(lhs: Affine<Whole, Part>, rhs: Lens<Part, Subpart>) -> Affine<Whole, Subpart> {
        return lhs * rhs.affine
    }

    static func * <Subpart>(lhs: Lens<Whole, Part?>, rhs: Lens<Part, Subpart>) -> Affine<Whole, Subpart> {
        return lhs.affine * Part?.prism.affine * rhs.affine
    }

}

struct Prism<Whole, Part> {

    let tryGet: (Whole) -> Part?
    let set: (Part) -> Whole

    var affine: Affine<Whole, Part> {
        return Affine<Whole, Part>(
            tryGet: self.tryGet,
            trySet: { part, _ in self.set(part) }
        )
    }

}

struct Affine<Whole, Part> {

    let tryGet: (Whole) -> Part?
    let trySet: (Part, Whole) -> Whole?

    static func * <Subpart>(lhs: Affine<Whole, Part>, rhs: Affine<Part, Subpart>) -> Affine<Whole, Subpart> {
        return Affine<Whole, Subpart>(
            tryGet: { whole in lhs.tryGet(whole).flatMap(rhs.tryGet) },
            trySet: { (subpart, whole) in lhs.tryGet(whole).flatMap { rhs.trySet(subpart, $0) }.flatMap { lhs.trySet($0, whole) } }
        )
    }

}

extension Optional {

    static var prism: Prism<Optional,Wrapped> {
        return Prism<Optional,Wrapped>.init(
            tryGet: { $0 },
            set: Optional.some)
    }

}

extension LightModel {
  static let idLens = Lens<LightModel, Int>(
    get: { $0.id },
    set: { id, lightModel in
       LightModel(
            id: id, 
            name:  lightModel.name
       )
    }
  )
  static let nameLens = Lens<LightModel, String>(
    get: { $0.name },
    set: { name, lightModel in
       LightModel(
            id:  lightModel.id, 
            name: name
       )
    }
  )
}

extension LightStateModel {
  static let idLens = Lens<LightStateModel, Int>(
    get: { $0.id },
    set: { id, lightStateModel in
       LightStateModel(
            id: id, 
            state:  lightStateModel.state
       )
    }
  )
  static let stateLens = Lens<LightStateModel, LightStateType>(
    get: { $0.state },
    set: { state, lightStateModel in
       LightStateModel(
            id:  lightStateModel.id, 
            state: state
       )
    }
  )
}


