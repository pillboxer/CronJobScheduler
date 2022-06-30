//
//  CronJobDisplayInfo.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 30/06/2022.
//

import Foundation

/// Formats a ``CronJobInstruction``
struct CronJobDisplayInfo: CustomStringConvertible, Equatable {
    let time: String
    let day: String
    let instruction: String
    
    var description: String {
        time + " " + day + " " + instruction
    }
}
