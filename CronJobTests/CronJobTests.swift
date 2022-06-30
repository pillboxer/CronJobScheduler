//
//  CronJobTests.swift
//  CronJobTests
//
//  Created by Henry Cooper on 29/06/2022.
//

import XCTest
@testable import CronJobScheduler

class CronJobTestCase: XCTestCase {

    private let model = CronJobTestModel()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    func testParserParsesCorrectly() throws {
        var commands: [String] = []
        let random = Int.random(in: 0..<100)
        for _ in 0..<random {
            let command = model.randomInstruction
            commands.append(command)
        }
        let time = model.randomTime
        commands.append(time)
        let parser = CronJobParser()
        let instructions = try awaitPublisher(parser.parse(input: commands))
  
        XCTAssert(instructions.count == random)
    }
    
    func testFormatterFormatsCorrectly() throws {
        let formatter = CronJobFormatter()

        let instructionsA = model.instructionGroupA
        let expectedA = model.expectedFormattedResultsA
        let formattedDateA = dateFormatter.date(from: model.currentTimeA)
        
        let instructionsB = model.instructionGroupB
        let expectedB = model.expectedFormattedResultsB
        let formattedDateB = dateFormatter.date(from: model.currentTimeB)
        
        CronJobTimeManager.time = formattedDateA ?? CronJobTimeManager.time
        let resultsA = try awaitPublisher(formatter.format(instructionsA))

        CronJobTimeManager.time = formattedDateB ?? CronJobTimeManager.time
        let resultsB = try awaitPublisher(formatter.format(instructionsB))
         
        XCTAssert(resultsA == expectedA && resultsB == expectedB)
    }

}
