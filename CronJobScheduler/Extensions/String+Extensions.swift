//
//  String+Extensions.swift
//  CronJobScheduler
//
//  Created by Henry Cooper on 29/06/2022.
//

import Foundation

extension String {
    
    // Courtesy of https://stackoverflow.com/questions/33058676/how-to-remove-multiple-spaces-in-strings-with-swift-2
    var condensedWhitespace: String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
