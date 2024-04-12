//
//  DateFormatter+Style.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 10.04.24.
//

import Foundation


extension DateFormatter {
    static let observationTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    func string(for date: Date?) -> String {
        if let date = date {
            return  self.string(from: date)
        }
        
        return  "Неизвестна дата"
    }
}
