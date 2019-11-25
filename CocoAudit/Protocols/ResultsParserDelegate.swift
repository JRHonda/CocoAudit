//
//  ResultsParserDelegate.swift
//  CocoAudit
//
//  Created by Justin Honda on 11/24/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Foundation

@objc protocol ResultsParserDelegate {
    func parseResults(results: AnyObject) -> Any?
}
