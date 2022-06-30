//
//  Calendar+Extensions.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 29/06/2022.
//

import Foundation

extension Calendar {
    
     func next(_ component: Calendar.Component, from date: Date) -> Int {
        let next = self.date(byAdding: component, value: 1, to: date)!
        let nextComponent = self.component(component, from: next)
        return nextComponent
    }
    
    func currentHour(from date: Date) -> Int {
        return component(.hour, from: date)
    }
    
    func currentMinute(from date: Date) -> Int {
        component(.minute, from: date)
    }
    
    
        
}
