//
//  CronJobStep.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 30/06/2022.
//

import Foundation

/// Represents a step in the scheduling process
enum CronJobStep: String {
    case input
    case parse
    case format
}
