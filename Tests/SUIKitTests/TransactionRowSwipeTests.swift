import Foundation
import XCTest
@testable import SUIKit

final class TransactionRowSwipeTests: XCTestCase {
    func testInitiallyHorizontalDragThatFinishesVerticalClosesPartialReveal() {
        // onChanged may already have moved the row -30 points. The final drag
        // direction must still produce a settled state rather than return early.
        XCTAssertEqual(resolve(x: -30, y: 100, predictedX: -200), .closed)
    }

    func testVerticalFinishPreservesAnAlreadyRevealedAction() {
        XCTAssertEqual(resolve(x: 20, y: 100, predictedX: 200, wasRevealed: true), .revealed)
    }

    func testVerticalFinishNeverUsesProjectedDistanceToDelete() {
        XCTAssertEqual(resolve(x: -20, y: 100, predictedX: -300, wasRevealed: true), .revealed)
    }

    func testHorizontalRevealAndFullSwipeKeepExistingThresholds() {
        XCTAssertEqual(resolve(x: -60, y: 10, predictedX: -60), .revealed)
        XCTAssertEqual(resolve(x: -150, y: 10, predictedX: -150), .delete)
        XCTAssertEqual(resolve(x: 80, y: 10, predictedX: 80, wasRevealed: true), .closed)
    }

    func testFastShortHorizontalDragCanRevealButCannotDelete() {
        XCTAssertEqual(TransactionRowSwipeOutcome.resolveHorizontal(translation: -20, velocity: -2000, origin: 0), .revealed)
    }

    func testLongHorizontalDragDeletesOnlyAfterActualTravel() {
        XCTAssertEqual(TransactionRowSwipeOutcome.resolveHorizontal(translation: -145, velocity: 0, origin: 0), .delete)
    }

    func testReverseHorizontalDragClosesPreviouslyRevealedRow() {
        XCTAssertEqual(TransactionRowSwipeOutcome.resolveHorizontal(translation: 80, velocity: 0, origin: -72), .closed)
    }

    func testShortHorizontalDragSettlesBackToClosed() {
        XCTAssertEqual(TransactionRowSwipeOutcome.resolveHorizontal(translation: -20, velocity: 0, origin: 0), .closed)
    }

    private func resolve(
        x: Double, y: Double, predictedX: Double, wasRevealed: Bool = false
    ) -> TransactionRowSwipeOutcome {
        TransactionRowSwipeOutcome.resolve(
            translation: CGSize(width: x, height: y),
            predictedEndTranslation: CGSize(width: predictedX, height: y),
            wasRevealed: wasRevealed
        )
    }
}
