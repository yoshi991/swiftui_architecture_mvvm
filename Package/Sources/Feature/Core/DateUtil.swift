//
//  DateUtil.swift
//  
//
//  Created by Yoshiki Hemmi on 2022/09/29.
//

import Foundation

public class DateUtil {
    
    public static let shared = DateUtil()
    
    private let dateFormatter = DateFormatter()
    
    private init() {}
    
    public func formatDate(from date: Date, format: FormatType) -> String {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    public enum FormatType: String {
        case YYYYMMDD = "yyyy/MM/dd"
    }
}
