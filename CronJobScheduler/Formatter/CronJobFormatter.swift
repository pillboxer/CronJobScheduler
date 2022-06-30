//
//  CronJobFormatter.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 29/06/2022.
//

import Foundation
import Combine

/// Formats one or more ``CronJobInstruction``
class CronJobFormatter {
    
    private let calendar = Calendar.current
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    func format(_ instructions: [CronJobInstruction]) -> AnyPublisher<[CronJobDisplayInfo], Never> {
        
        Future { [self] promise in
            var display: [CronJobDisplayInfo] = []
            
            for instruction in instructions {
                let minute = nextMinute(for: instruction)
                let hour = nextHour(for: instruction)
                let time = "\(hour):\(minute)"
                let date = formatter.date(from: time)!
                let string = formatter.string(from: date)
                let isTomorrow = isInstructionTomorrow(instruction: instruction)
                display.append(CronJobDisplayInfo(time: string, day: isTomorrow ? "tomorrow" : "today", instruction: instruction.pathToInstruction))
            }
            promise(.success(display))
        }
        .eraseToAnyPublisher()
    }
    
}

private extension CronJobFormatter {
    
    func nextMinute(for instruction: CronJobInstruction) -> Int {
        // Explicit
        if let minute = instruction.minutesPastTheHour {
            return minute
        }
        // Wildcard in both minutes and hours
        else if instruction.runsEveryHour {
            return calendar.currentMinute(from: CronJobTimeManager.time)
        }
        else {
            // Wildcard in just minutes
            // Look at the current hour
            let hour = calendar.currentHour(from: CronJobTimeManager.time)
            if hour != instruction.hourOfTheDay! {
                return 0
            }
            else {
                return calendar.currentMinute(from: CronJobTimeManager.time)            }
        }
    }
    
    func nextHour(for instruction: CronJobInstruction) -> Int {
        // Explicit
        if let hour = instruction.hourOfTheDay {
            return hour
        }
        else {
            // Wildcard
            let currentMinute = calendar.currentMinute(from: CronJobTimeManager.time)
            // If there was an explicit minute, has that time past? If so, return next hour
            if let minute = instruction.minutesPastTheHour, minute < currentMinute {
                return calendar.next(.hour, from: CronJobTimeManager.time)
            }
            // Otherwise return current hour
            else {
                return calendar.currentHour(from: CronJobTimeManager.time)
            }
        }
    }

    func isInstructionTomorrow(instruction: CronJobInstruction) -> Bool {
        let nextHour = nextHour(for: instruction)
        if nextHour == 0 {
            return true
        }
        if calendar.currentHour(from: CronJobTimeManager.time) > nextHour {
            return true
        }
        return false
    }
    
}
