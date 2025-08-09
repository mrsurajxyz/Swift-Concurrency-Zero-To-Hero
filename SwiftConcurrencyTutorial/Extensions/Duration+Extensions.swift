//
//  Duration+Extensions.swift
//  SwiftConcurrencyTutorialTests
//
//  Created by Haider Ashfaq on 09/08/2025.
//

import Foundation

public extension Duration {
    var secondsDouble: Double {
        let c = components
        return Double(c.seconds) + Double(c.attoseconds) / 1_000_000_000_000_000_000.0
    }
}
