import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
@testable import LightSwitch

class LightSwitchUseCaseEventTests: QuickSpec {

    private var lightsUseCase: LightsUseCaseProtocol!
    private var lightsRepository: LightsRepositoryProtocolMock!
    private var lightModelSubject: PublishSubject<[LightModel]>!
    private var lightStateModelSubject: PublishSubject<[LightStateModel]>!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {

        beforeEach {
            self.lightsRepository = LightsRepositoryProtocolMock()
            self.lightsUseCase = LightsUseCase(lightsRepository: self.lightsRepository)
            self.lightModelSubject = PublishSubject<[LightModel]>()
            self.lightStateModelSubject = PublishSubject<[LightStateModel]>()
            self.scheduler = TestScheduler(initialClock: 0)
            self.disposeBag = DisposeBag()
        }

        describe("queryLightsWithState") {

            it("will have expected result if models arrive before states") {
                self.lightsRepository.queryAllLightsReturnValue = self.lightModelSubject
                self.lightsRepository.queryAllLightStatesReturnValue = self.lightStateModelSubject

                let lightModels = [LightModel].stub(withCount: 3)
                let lightStateModels = [LightStateModel].stub(withCount: 3)

                let numberOfLightsWithStates = self.lightsUseCase
                    .queryLightsWithState()
                    .map { $0.count }

                self.scheduler
                    .createColdObservable([.next(10, lightModels)])
                    .bind(to: self.lightModelSubject)
                    .disposed(by: self.disposeBag)

                self.scheduler
                    .createColdObservable([.next(20, lightStateModels)])
                    .bind(to: self.lightStateModelSubject)
                    .disposed(by: self.disposeBag)

                expect(numberOfLightsWithStates)
                    .events(
                        scheduler: self.scheduler,
                        disposeBag: self.disposeBag)
                    .to(equal([.next(20, 3)]))
            }

            it("will have expected result if states arrive before models") {
                self.lightsRepository.queryAllLightsReturnValue = self.lightModelSubject
                self.lightsRepository.queryAllLightStatesReturnValue = self.lightStateModelSubject

                let lightModels = [LightModel].stub(withCount: 3)
                let lightStateModels = [LightStateModel].stub(withCount: 3)

                let numberOfLightsWithStates = self.lightsUseCase
                    .queryLightsWithState()
                    .map { $0.count }

                self.scheduler
                    .createColdObservable([.next(10, lightStateModels)])
                    .bind(to: self.lightStateModelSubject)
                    .disposed(by: self.disposeBag)

                self.scheduler
                    .createColdObservable([.next(20, lightModels)])
                    .bind(to: self.lightModelSubject)
                    .disposed(by: self.disposeBag)

                expect(numberOfLightsWithStates)
                    .events(
                        scheduler: self.scheduler,
                        disposeBag: self.disposeBag)
                    .to(equal([.next(20, 3)]))
            }

        }

    }

}
