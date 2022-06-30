//
//  IOManager.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 29/06/2022.
//

import Foundation
import Combine
import OSLog

/// Handles console input and output
class IOManager: ObservableObject {
        
    private let stdin = FileHandle.standardInput
    
    private enum OutputType {
        case standard
        case error
    }
    
    func start() {
        let usage = NSLocalizedString("cron_job_scheduler_usage", comment: "")
        output(usage)
    }
    
    func log(_ step: CronJobStep) {
        os_log(.debug, "Logging step: %@", step.rawValue.capitalized)
    }
    
    func handleError(_ error: CronJobError) {
        output(error.localizedDescription, of: .error)
    }
    
    func requestInput() -> AnyPublisher <[String], Never> {
        // Self has no strong ref. to closure, so capturing self strongly appropriate here
        Future { promise in
            var input: [String] = []
            while let line = readLine(strippingNewline: true) {
                if line == "" { break }
                input.append(line)
            }
            promise(.success(input))
        }
        .eraseToAnyPublisher()
    }
    
}

private extension IOManager {
    
    private func output(_ string: String, of type: OutputType = .standard) {
        let prefix = type == .error ? "***** Error: " : ""
        let suffix = type == .error ? " ***** \n\n" : ""
        fputs(prefix + string + suffix, type == .standard ? stdout : stderr)
    }
    
}
