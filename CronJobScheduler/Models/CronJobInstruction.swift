//
//  CronJobInstruction.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 29/06/2022.
//

import Foundation

/// Raw struct for a given instruction
struct CronJobInstruction {
    
    // Nil implies wild card
    let minutesPastTheHour: Int?
    let hourOfTheDay: Int?
    let pathToInstruction: String
    
    init(minutesPastTheHour: Int?, hourOfTheDay: Int?, pathToInstruction: String) {
        self.minutesPastTheHour = minutesPastTheHour
        self.hourOfTheDay = hourOfTheDay
        self.pathToInstruction = pathToInstruction
    }
    
}

extension CronJobInstruction {
    
    var runsEveryHour: Bool {
        hourOfTheDay == nil
    }
    
    var runsEveryMinute: Bool {
        minutesPastTheHour == nil
    }
    
}
