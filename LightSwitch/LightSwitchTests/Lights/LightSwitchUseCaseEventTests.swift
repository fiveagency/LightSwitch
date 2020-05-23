import XCTest
import RxSwift
import RxTest
import RxCocoa
@testable import LightSwitch

class LightsUseCaseEventTests: XCTestCase {

    private var lightsUseCase: LightsUseCaseProtocol!
    private var lightsRepository: LightsRepositoryProtocolMock!
    private var lightModelSubject: PublishSubject<[LightModel]>!
    private var lightStateModelSubject: PublishSubject<[LightStateModel]>!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        lightsRepository = LightsRepositoryProtocolMock()
        lightsUseCase = LightsUseCase(lightsRepository: lightsRepository)
        lightModelSubject = PublishSubject<[LightModel]>()
        lightStateModelSubject = PublishSubject<[LightStateModel]>()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // queryLightsWithState should return same result regardless of order of model and state events
    func testQueryLightsWithState_When_Model_Before_State() throws {
        lightsRepository.queryAllLightsReturnValue = lightModelSubject
        lightsRepository.queryAllLightStatesReturnValue = lightStateModelSubject

        let lightModels = [LightModel].stub(withCount: 3)
        let lightStateModels = [LightStateModel].stub(withCount: 3)

        let numberOfLightsWithStates = self.lightsUseCase
            .queryLightsWithState()
            .map { $0.count }

        scheduler
            .createColdObservable([.next(10, lightModels)])
            .bind(to: lightModelSubject)
            .disposed(by: disposeBag)

        scheduler
            .createColdObservable([.next(20, lightStateModels)])
            .bind(to: lightStateModelSubject)
            .disposed(by: disposeBag)

        let result = scheduler.record(numberOfLightsWithStates, disposeBag: self.disposeBag)

        scheduler.start()

        XCTAssertEqual(result.events, [.next(20, 3)])
    }

    // queryLightsWithState should return same result regardless of order of model and state events
    func testQueryLightsWithState_When_Model_After_State() throws {
        lightsRepository.queryAllLightsReturnValue = lightModelSubject
        lightsRepository.queryAllLightStatesReturnValue = lightStateModelSubject

        let lightModel = LightModel.stub(withId: 1)
        let lightStateModel = LightStateModel.stub(withId: 1)

        let numberOfLightsWithStates = self.lightsUseCase
            .queryLightsWithState()
            .map { $0.count }

        scheduler
            .createColdObservable([.next(10, [lightStateModel])])
            .bind(to: lightStateModelSubject)
            .disposed(by: disposeBag)

        scheduler
            .createColdObservable([.next(20, [lightModel])])
            .bind(to: lightModelSubject)
            .disposed(by: disposeBag)

        let result = scheduler.record(numberOfLightsWithStates, disposeBag: self.disposeBag)

        scheduler.start()

        XCTAssertEqual(result.events, [.next(20, 1)])
    }

}
