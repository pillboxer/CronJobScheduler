//
//  CronJobParser.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 29/06/2022.
//

import Combine
import Foundation

/// Parses a given input into one or more CronJobInstructions
class CronJobParser: ObservableObject {

    private let validMinutesRange = 0...59
    private let validHoursRange = 0...23
    
    enum ParseError: CronJobError {
        case incorrectArgumentCount(componentCount: Int)
        case invalidMinutes
        case invalidHour
        
        var errorDescription: String? {
            switch self {
            case .incorrectArgumentCount(let count):
                return String(format: NSLocalizedString("cron_job_parser_error_incorrect_argument_count", comment: ""), String(describing: count))
            case .invalidMinutes:
                return String(format: NSLocalizedString("cron_job_parser_error_invalid_minutes", comment: ""))
            case .invalidHour:
                return String(format: NSLocalizedString("cron_job_parser_error_invalid_hour", comment: ""))
            }
        }
    }
    
    func parse(input: [String]) -> AnyPublisher<[CronJobInstruction], ParseError>  {
        Future { [self] promise in
            var instructions: [CronJobInstruction] = []
            for command in input {
                let words = command.components(separatedBy: .whitespaces)
                let count = words.count
                
                if let last = input.last,
                    last == command && words.count == 1 {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    CronJobTimeManager.time = dateFormatter.date(from: last) ?? CronJobTimeManager.time
                    break
                }
                
                if count != 3 {
                    return promise(.failure(.incorrectArgumentCount(componentCount: count)))
                }
                
                let arg1 = words[0]
                let arg2 = words[1]
                let arg3 = words[2]
                
                if !(minutesAreValid(arg1)) {
                    return promise(.failure(.invalidMinutes))

                }
                else if !hourIsValid(arg2) {
                    return promise(.failure(.invalidHour))
                }
                else {
                    let instruction = CronJobInstruction(minutesPastTheHour: Int(arg1), hourOfTheDay: Int(arg2), pathToInstruction: arg3)
                    instructions.append(instruction)
                }
                
            }
            promise(.success(instructions))
        }.eraseToAnyPublisher()
    }
    
}

extension CronJobParser {
    
    private func minutesAreValid(_ minutes: String) -> Bool {
        let int = Int(minutes) ?? -1
        let firstWordIsWildcard = minutes == "*"
        if firstWordIsWildcard { return true }
        return validMinutesRange.contains(int)
    }
    
    private func hourIsValid(_ hour: String) -> Bool {
        let int = Int(hour) ?? -1
        let firstWordIsWildcard = hour == "*"
        if firstWordIsWildcard { return true }
        return validHoursRange.contains(int)
    }
}
