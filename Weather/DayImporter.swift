//
//  DayImporter.swift
//  Weather
//
//  Created by R. Tony Goold on 2015-04-09.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation

enum MinutelyResult {
    case Success(MinutelyData)
    case Failure(NSError)
}

class DayImporter {

    let json: NSDictionary

    init(json: NSDictionary) {
        self.json = json
    }

    // Using optional return type
    func dictToMinutelyData(dict: NSDictionary) -> MinutelyData? {
        if let time = dict["time"] as? Int {
            if let pop = dict["precipProbability"] as? Float {
                var minutely = MinutelyData()
                minutely.time = time
                minutely.pop = pop
                return minutely
            }
        }
        return nil
    }

    // Using tagged enumeration return type
    func toMinutelyData(dict: NSDictionary) -> MinutelyResult {
        if let time = dict["time"] as? Int {
            if let pop = dict["precipProbability"] as? Float {
                var minutely = MinutelyData()
                minutely.time = time
                minutely.pop = pop
                return .Success(minutely)
            }
        }
        return .Failure(NSError())
    }

    func getMinutelyData() -> Array<MinutelyData> {
        var minutelyList = Array<MinutelyData>()
        if let minutelyJson = json["minutely"] as? NSDictionary {
            if let data = minutelyJson["data"] as? Array<NSDictionary> {
                for minutelyData in data {
                    switch toMinutelyData(minutelyData) {
                    case .Success(let minutely):
                        minutelyList.append(minutely)
                    case .Failure:
                        break
                    }
                }
            }
        }
        return minutelyList
    }
}
