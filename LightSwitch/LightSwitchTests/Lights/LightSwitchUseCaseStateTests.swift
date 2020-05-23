import XCTest
import RxSwift
import RxBlocking
@testable import LightSwitch

class LightSwitchUseCaseStateTests: XCTestCase {

    private var lightsUseCase: LightsUseCaseProtocol!
    private var lightsRepository: LightsRepositoryProtocolMock!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        lightsRepository = LightsRepositoryProtocolMock()
        lightsUseCase = LightsUseCase(lightsRepository: lightsRepository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // queryLightsWithState returns empty array when there are zero lights and zero states
    func testQueryLightsWithState_With_No_Lights() throws {
        // Arrange
        lightsRepository.queryAllLightsReturnValue = .just([])
        lightsRepository.queryAllLightStatesReturnValue = .just([])

        let lightsWithStateCount = lightsUseCase
            .queryLightsWithState()
            .map { $0.count }

        // Act + Assert
        XCTAssertEqual(try lightsWithStateCount.toBlocking().first(), 0)
    }

    // queryLightsWithState returns an array with three elements when there are three lights and three states
    func testQueryLightsWithState_With_Three_Lights() throws {
        // Arrange
        let lightModels = [LightModel].stub(withCount: 3)
        let lightStateModels = [LightStateModel].stub(withCount: 3)

        lightsRepository.queryAllLightsReturnValue = .just(lightModels)
        lightsRepository.queryAllLightStatesReturnValue = .just(lightStateModels)

        let lightsWithStateCount = lightsUseCase
            .queryLightsWithState()
            .map { $0.count }

        // Act + Assert
        XCTAssertEqual(try lightsWithStateCount
            .toBlocking()
            .first(), 3)
    }

    // queryLightsWithState returns empty array when light and state ids don't match
    func testQueryLightsWithState_With_Light_Without_State() throws {
        // Arrange
        let lightModel = LightModel.stub(withId: 1)
        let lightStateModel = LightStateModel.stub(withId: 2)

        lightsRepository.queryAllLightsReturnValue = .just([lightModel])
        lightsRepository.queryAllLightStatesReturnValue = .just([lightStateModel])

        let lightsWithStateCount = lightsUseCase
            .queryLightsWithState()
            .map { $0.count }

        // Act + Assert
        XCTAssertEqual(try lightsWithStateCount.toBlocking().first(), 0)
    }

    // areAllLightsOff return false if all lights are on
    func testAreAllLightsOff_If_All_Are_On() throws {
        // Arrange
        let lightModels = [LightModel].stub(withCount: 3)
        let lightStateModels = [LightStateModel].stub(withCount: 3)

        lightsRepository.queryAllLightsReturnValue = .just(lightModels)
        lightsRepository.queryAllLightStatesReturnValue = .just(lightStateModels)

        let areAllOff = lightsUseCase.areAllLightsOff()

        // Act + Assert
        XCTAssertFalse(try areAllOff.toBlocking().first()!)
    }

    // areAllLightsOff return true if all lights are off
    func testAreAllLightsOff_If_All_Are_Off() throws {
        // Arrange
        let lightModels = [LightModel].stub(withCount: 3)
        let lightStateModels = [LightStateModel]
            .stub(withCount: 3)
            .map { $0.modify(state: .off) }

        lightsRepository.queryAllLightsReturnValue = .just(lightModels)
        lightsRepository.queryAllLightStatesReturnValue = .just(lightStateModels)

        let areAllOff = lightsUseCase.areAllLightsOff()

        // Act + Assert
        XCTAssertTrue(try areAllOff.toBlocking().first()!)
    }

    // toggleLight will call toggleLight on repositoryLevel with id as a parameter and finish successfully
    func testToggleLight_Is_Called_And_Completed() throws {
        // Arrange
        lightsRepository.toggleLightReturnValue = .empty()

        // Act
        let toggleLight = lightsUseCase
            .toggleLight(withId: 2)
            .toBlocking()
            .materialize()

        // Assert
        let timesCalled = lightsRepository.toggleLightCallsCount
        let parameterPassed = lightsRepository.toggleLightReceivedInvocations.first!

        guard
            case .completed(_) = toggleLight
        else {
            XCTFail()
            return
        }
        XCTAssertEqual(timesCalled, 1)
        XCTAssertEqual(parameterPassed, 2)
    }

}

