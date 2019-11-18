//
//  CVESearch.swift
//  CocoAudit
//
//  Created by Justin Honda on 11/17/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Foundation

public typealias PodTitle = String

protocol CVESearchDelegate {
    var podTitles: [PodTitle] { get set }
    var results: [CVEMatch] { get set }
    func search()
}
