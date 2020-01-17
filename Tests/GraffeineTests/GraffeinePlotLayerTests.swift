import XCTest
@testable import Graffeine

class GraffeinePlotLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeinePlotLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.vectorPlots) as? GraffeinePlotLayer
        sampleData = SampleData()
    }

    func test_plot_layer_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_data_with_7_values_then_it_should_have_7_sublayer_plots() {
        sampleData.applyVectorPlots(to: graffeineView)
        graffeineView.layoutIfNeeded()
        XCTAssertEqual(subject.sublayers!.count, 7)
    }
}
