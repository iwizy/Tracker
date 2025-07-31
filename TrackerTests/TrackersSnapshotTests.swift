//
//  TrackersSnapshotTests.swift
//  Tracker
//
//  Created by Alexander Agafonov on 01.08.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testMainScreenSnapshot() {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image(on: .iPhone13))
    }
}
