//
//  main.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 29/06/2022.
//

import Combine
import Foundation

var subscriptions: Set<AnyCancellable> = []

private let io = IOManager()
io.start()
subscribeToInput()

private func subscribeToInput() {
    io.log(.input)
    io.requestInput().sink { input in
        subscribeToParser(parsing: input) }
        .store(in: &subscriptions)
}

private func subscribeToParser(parsing input: [String]) {
    io.log(.parse)
    let parser = CronJobParser()
    parser.parse(input: input)
        .sink { completion in
            if case let .failure(error) = completion {
                io.handleError(error)
            }
        } receiveValue: { instructions in
            subscribeToFormatter(formatting: instructions)
        }.store(in: &subscriptions)
}

private func subscribeToFormatter(formatting instructions: [CronJobInstruction]) {
    io.log(.format)
    let formatter = CronJobFormatter()
    formatter.format(instructions)
        .sink { infos in
            for info in infos {
                print(info.description)
            }
        }
        .store(in: &subscriptions)
}


