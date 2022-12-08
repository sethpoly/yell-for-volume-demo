//
//  Date+Extension.swift
//  YellForVolume
//
//  Created by Seth Polyniak on 12/8/22.
//

import Foundation

extension Date {
    func toString(dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
