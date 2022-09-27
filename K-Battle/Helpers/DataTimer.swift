//
//  DataTimer.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/26/22.
//

import Foundation

class DataTimer {
    static var shared = DataTimer()

    var startDate: Date!
    var endDate: Date!

    private init() {
        check()
        print(self.startDate)
    }

    func check() {
        guard
            let startDate = UserDefaults.standard.object(forKey: "kStartDate") as? Date,
            let endDate = Calendar.current.nextDate(after: startDate, matching: DateComponents(hour:0), matchingPolicy: .nextTime)

              
               
        else {
            self.resetDates()
            return
        }

        var interval = Date().timeIntervalSince(endDate)
        guard interval < 0 else {
            self.resetUserData()
            self.resetDates()
            return
        }

        self.startDate = startDate
        self.endDate = endDate

        // log remaining time
        interval = abs(interval)
        let log: [Int] = [86400.0, 3600.0, 60.0].map { value in
            guard interval > value else { return 0 }

            let returnValue = Int(floor(interval / value))
            interval.formTruncatingRemainder(dividingBy: value)
            return returnValue
        }
        print("Remaining: \(log[0])d \(log[1])h \(log[2])m \(Int(interval))s")
    }

    private func resetUserData() { }

    private func resetDates() {
        print("resetting Dates")
        self.startDate = Date()
        self.endDate = Calendar.current.nextDate(after: startDate, matching: DateComponents(hour:0), matchingPolicy: .nextTime)
        UserDefaults.standard.set(startDate, forKey: "kStartDate")
    }
}

