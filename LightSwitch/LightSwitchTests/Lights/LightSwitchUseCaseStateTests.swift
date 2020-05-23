import Quick
import Nimble
import RxNimble
import RxSwift
@testable import LightSwitch

class LightSwitchUseCaseStateTests: QuickSpec {

    private var lightsUseCase: LightsUseCaseProtocol!
    private var lightsRepository: LightsRepositoryProtocolMock!
    private var disposeBag: DisposeBag!
    override func spec() {

        beforeEach {
            self.lightsRepository = LightsRepositoryProtocolMock()
            self.lightsUseCase = LightsUseCase(lightsRepository: self.lightsRepository)
            self.disposeBag = DisposeBag()
        }

        describe("queryLightsWithState") {

            it("returns empty array when there are zero lights and zero states") {
                // Arrange
                self.lightsRepository.queryAllLightsReturnValue = .just([])
                self.lightsRepository.queryAllLightStatesReturnValue = .just([])

                let lightsWithStateCount = self.lightsUseCase
                    .queryLightsWithState()
                    .map { $0.count }

                // Act + Assert
                expect(lightsWithStateCount).first.to(equal(0))
            }

            it("returns an array with three elements when there are three lights and three states") {
                // Arrange
                let lightModels = [LightModel].stub(withCount: 3)
                let lightStateModels = [LightStateModel].stub(withCount: 3)

                self.lightsRepository.queryAllLightsReturnValue = .just(lightModels)
                self.lightsRepository.queryAllLightStatesReturnValue = .just(lightStateModels)

                let lightsWithStateCount = self.lightsUseCase
                    .queryLightsWithState()
                    .map { $0.count }

                // Act + Assert
                expect(lightsWithStateCount).first.to(equal(3))
            }

            it("returns empty array when light and state ids don't match") {
                // Arrange
                let lightModel = LightModel.stub(withId: 1)
                let lightStateModel = LightStateModel.stub(withId: 2)

                self.lightsRepository.queryAllLightsReturnValue = .just([lightModel])
                self.lightsRepository.queryAllLightStatesReturnValue = .just([lightStateModel])

                let lightsWithStateCount = self.lightsUseCase
                    .queryLightsWithState()
                    .map { $0.count }

                // Act + Assert
                expect(lightsWithStateCount).first.to(equal(0))
            }

        }

        describe("areAllLightsOff") {

            it("returns false when all lights are on") {
                // Arrange
                let lightModels = [LightModel].stub(withCount: 3)
                let lightStateModels = [LightStateModel].stub(withCount: 3)

                self.lightsRepository.queryAllLightsReturnValue = .just(lightModels)
                self.lightsRepository.queryAllLightStatesReturnValue = .just(lightStateModels)

                let areAllOff = self.lightsUseCase.areAllLightsOff()

                // Act + Assert
                expect(areAllOff).first.to(beFalse())
            }

            it("returns true when all lights are off") {
                // Arrange
                let lightModels = [LightModel].stub(withCount: 3)
                let lightStateModels = [LightStateModel]
                    .stub(withCount: 3)
                    .map { LightStateModel.stateLens.set(.off, $0) }

                self.lightsRepository.queryAllLightsReturnValue = .just(lightModels)
                self.lightsRepository.queryAllLightStatesReturnValue = .just(lightStateModels)

                let areAllOff = self.lightsUseCase.areAllLightsOff()

                // Act + Assert
                expect(areAllOff).first.to(beTrue())
            }

        }

        describe("toggleLight") {

            it("will call toggleLight on repositoryLevel with id as a parameter and finish successfully") {
                // Arrange
                self.lightsRepository.toggleLightReturnValue = .empty()

                // Act
                let toggleLight = self.lightsUseCase
                    .toggleLight(withId: 2)
                    .toBlocking()
                    .materialize()

                // Assert
                let timesCalled = self.lightsRepository.toggleLightCallsCount
                let parameterPassed = self.lightsRepository.toggleLightReceivedInvocations.first!

                guard
                    case .completed(_) = toggleLight
                else {
                    fail("Completable returned an error")
                    return
                }

                expect(timesCalled).to(equal(1))
                expect(parameterPassed).to(equal(2))
            }

        }

    }

}

