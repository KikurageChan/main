//
//  DateExt.swift
//  MyExtension
//
//  Created by 木耳ちゃん on 2016/12/03.
//  Copyright © 2016年 NetGroup. All rights reserved.
//

import Foundation

extension Date {
    /**
     Dateを生成します(デフォルトは2年11月30日午前0時0分0秒0ナノ秒)
     */
    static func instantiate(_ calendar: Calendar? = nil, year: Int = 0, month: Int = 0, day: Int = 0, hour: Int = 0, minute: Int = 0, second: Int = 0, nanosecond: Int = 0) -> Date {
        let components = DateComponents(calendar: calendar ?? Calendar.current, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        return components.date!
    }
    
    static var now: Date { return Date() }
    
    func isDateInToday(_ calendar: Calendar? = nil) -> Bool { return (calendar ?? Calendar.current).isDateInToday(self) }
    func isDateInTomorrow(_ calendar: Calendar? = nil) -> Bool { return (calendar ?? Calendar.current).isDateInTomorrow(self) }
    func isDateInWeekend(_ calendar: Calendar? = nil) -> Bool { return (calendar ?? Calendar.current).isDateInWeekend(self) }
    func isDateInYesterday(_ calendar: Calendar? = nil) -> Bool { return (calendar ?? Calendar.current).isDateInYesterday(self) }
    func isDateInBeginningOfMonth(_ calendar: Calendar? = nil) -> Bool { return (calendar ?? Calendar.current).isDateInBeginningOfMonth(self) }
    func isDateInEndOfMonth(_ calendar: Calendar? = nil) -> Bool { return (calendar ?? Calendar.current).isDateInEndOfMonth(self) }
    
    func year(_ calendar: Calendar? = nil) -> Int {
        return (calendar ?? Calendar.current).component(.year, from: self)
    }
    
    func month(_ calendar: Calendar? = nil) -> Int {
        return (calendar ?? Calendar.current).component(.month, from: self)
    }
    
    func day(_ calendar: Calendar? = nil) -> Int {
        return (calendar ?? Calendar.current).component(.day, from: self)
    }
    
    func hour(_ calendar: Calendar? = nil) -> Int {
        return (calendar ?? Calendar.current).component(.hour, from: self)
    }
    
    func minute(_ calendar: Calendar? = nil) -> Int {
        return (calendar ?? Calendar.current).component(.minute, from: self)
    }
    
    func second(_ calendar: Calendar? = nil) -> Int {
        return (calendar ?? Calendar.current).component(.second, from: self)
    }
    
    func nanosecond(_ calendar: Calendar? = nil) -> Int {
        return (calendar ?? Calendar.current).component(.nanosecond, from: self)
    }
    /**
     ```
     yy     西暦年  2桁             2012年 -> 12
     yyyy   西暦年  2桁             2012年 -> 2012
     M      月                     8月 -> 8
     MM     月(ゼロ埋め)             8月 -> 08
     d      月に対する日             3日 -> 3
     dd     月に対する日(ゼロ埋め)     3日 -> 03
     e      曜日                   2011年8月30日 -> 3
     E      曜日(漢字)              2011年8月30日 -> 火
     a      午前/午後               13:00 -> 午後
     h      時(12時間制)            13時 -> 1
     hh     時(12時間制ゼロ埋め)      13時 -> 01
     H      時(24時間制             13時 -> 13
     HH     時(24時間制ゼロ埋め)      13時 -> 13
     m      分                     3分 -> 3
     mm     分(ゼロ埋め)             3分 -> 03
     s      秒                     3秒 -> 3
     ss     秒(ゼロ埋め)             3秒 -> 03
     S      ミリ秒                 3ミリ秒 -> 3
     SSS    ミリ秒(ゼロ埋め)         3ミリ秒 -> 003
     ```
     */
    func format(text: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = text
        return dateFormatter.string(from: self)
    }
    /**
     Dateの差分を示します
     
     例を示します
     ```
     let a = Date.instantiate(year: 2017, month: 11, day: 11, hour: 12, minute: 0)
     let b = Date.instantiate(year: 2017, month: 11, day: 12, hour: 12, minute: 0)
     
     //aからみてbは+1日
     a.diff(.day, to: b).day    // 1
     ```
     */
    func diff(_ calendar: Calendar? = nil, component: Calendar.Component, to: Date) -> DateComponents {
        return (calendar ?? Calendar.current).dateComponents([component], from: self, to: to)
    }
    
    static func diffString(date: Date) -> String {
        let diff = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date, to: Date.now)
        let month = diff.month ?? 0
        let day = diff.day ?? 0
        let hour = diff.hour ?? 0
        let minute = diff.minute ?? 0
        
        if month >= 6 {
            return "半年以上前"
        } else if 0 < month && month < 6 {
            return "\(month)ヶ月前"
        } else {
            if day >= 30 {
                return "1ヶ月以上前"
            } else if 0 < day && day < 30 {
                return "\(day)日前"
            } else {
                if hour >= 24 {
                    return "1日前"
                } else if 0 < hour && hour < 24 {
                    return "\(hour)時間前"
                } else {
                    if minute >= 60 {
                        return "1時間前"
                    } else if 0 < minute && minute < 60 {
                        return "\(minute)分前"
                    } else {
                        return "1分以内"
                    }
                }
            }
        }
    }
}
