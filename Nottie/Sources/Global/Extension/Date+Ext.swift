//
//  Date+Ext.swift
//  Nottie
//
//  Created by jun on 4/21/25.
//

import Foundation

extension Date {
    func toNotificationDateComponents() -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
}
