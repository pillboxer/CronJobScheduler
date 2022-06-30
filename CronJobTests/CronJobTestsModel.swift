//
//  CronJobUsageTestsModel.swift
//  CronJobTests
//
//  Created by Henry Cooper on 29/06/2022.
//

import Foundation
struct CronJobTestModel {
    
    private let instruction = "some instruction"
    
    var randomInstruction: String {
        "\(randomMinute()) \(randomHour()) bin/some/instruction/path"
    }
    
    var randomTime: String {
        "\(randomHour(withWildcard: false)):\(randomMinute(withWildcard: false))"
    }
    
    var instructionGroupA: [CronJobInstruction] {
        [CronJobInstruction(minutesPastTheHour: 30, hourOfTheDay: 1, pathToInstruction: instruction),
         CronJobInstruction(minutesPastTheHour: 45, hourOfTheDay: nil, pathToInstruction: instruction),
         CronJobInstruction(minutesPastTheHour: nil, hourOfTheDay: nil, pathToInstruction: instruction),
         CronJobInstruction(minutesPastTheHour: nil, hourOfTheDay: 19, pathToInstruction: instruction)]
    }
    
    var expectedFormattedResultsA: [CronJobDisplayInfo] {
        [CronJobDisplayInfo(time: "01:30", day: "tomorrow", instruction: instruction),
         CronJobDisplayInfo(time: "16:45", day: "today", instruction: instruction),
         CronJobDisplayInfo(time: "16:10", day: "today", instruction: instruction),
         CronJobDisplayInfo(time: "19:00", day: "today", instruction: instruction)]
    }
    
    var currentTimeA: String {
        "16:10"
    }
    
    var instructionGroupB: [CronJobInstruction] {
        [CronJobInstruction(minutesPastTheHour: 21, hourOfTheDay: 3, pathToInstruction: instruction),
         CronJobInstruction(minutesPastTheHour: 17, hourOfTheDay: nil, pathToInstruction: instruction),
         CronJobInstruction(minutesPastTheHour: nil, hourOfTheDay: nil, pathToInstruction: instruction),
         CronJobInstruction(minutesPastTheHour: 57, hourOfTheDay: 10, pathToInstruction: instruction),
         CronJobInstruction(minutesPastTheHour: 59, hourOfTheDay: 23, pathToInstruction: instruction)]
    }
    
    var expectedFormattedResultsB: [CronJobDisplayInfo] {
        [CronJobDisplayInfo(time: "03:21", day: "tomorrow", instruction: instruction),
         CronJobDisplayInfo(time: "23:17", day: "today", instruction: instruction),
         CronJobDisplayInfo(time: "22:46", day: "today", instruction: instruction),
         CronJobDisplayInfo(time: "10:57", day: "tomorrow", instruction: instruction),
         CronJobDisplayInfo(time: "23:59", day: "today", instruction: instruction)]
    }
    
    var currentTimeB: String {
        "22:46"
    }
    
}

private extension CronJobTestModel {
    
    func randomMinute(withWildcard: Bool = true) -> String {
        let wildcard = "*"
        let minutes = 0...59
        let randomMinute = Int.random(in: minutes)
        let stringMinute = String(randomMinute)
        var array = [stringMinute]
        if withWildcard { array.append(wildcard) }
        return array.randomElement()!
    }
    
    func randomHour(withWildcard: Bool = true) -> String {
        let wildcard = "*"
        let hours = 0...23
        let randomHour = Int.random(in: hours)
        let stringHour = String(randomHour)
        var array = [stringHour]
        if withWildcard { array.append(wildcard) }
        return array.randomElement()!
    }
    
}
