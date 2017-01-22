//
//  ConnpassAPI.swift
//  Shinagawa.Swift
//
//  Created by Kazuya Ueoka on 2017/01/22.
//  Copyright © 2017年 fromKK. All rights reserved.
//

import Foundation

struct ConnpassQuery {
    enum Order: Int {
        case updated = 1
        case date = 2
        case new = 3
    }
    
    private (set) var query: [String: Any] = [:]
    
    mutating func eventId(_ eventId: Int) {
        self.query["event_id"] = eventId
    }
    
    mutating func keyword(_ keyword: String) {
        self.query["keyword"] = keyword
    }
    
    mutating func keywordOr(_ keyword: String) {
        self.query["keyword_or"] = keyword
    }
    
    mutating func ym(_ ym: String) {
        self.query["ym"] = ym
    }
    
    mutating func ymd(_ ymd: String) {
        self.query["ymd"] = ymd
    }
    
    mutating func nickname(_ nickname: String) {
        self.query["nickname"] = nickname
    }
    
    mutating func ownerNickname(_ ownerNickname: String) {
        self.query["owner_nickname"] = ownerNickname
    }
    
    mutating func seriesId(_ seriesId: Int) {
        self.query["series_id"] = seriesId
    }
    
    mutating func start(_ start: Int) {
        self.query["start"] = start
    }
    
    mutating func order(_ order: Order) {
        self.query["order"] = order.rawValue
    }
    
    mutating func count(_ count: Int) {
        self.query["count"] = count
    }
    
    private func toString(_ value: Any) -> String? {
        if let result: String = value as? String {
            return result
        } else if let val: Int = value as? Int {
            let result: String = String(val)
            return result
        }
        
        return nil
    }
    
    var queryString: String {
        return self.query.keys.flatMap { (key: String) -> String? in
            guard let val: Any = self.query[key], let value: String = self.toString(val) else { return nil }
            return String(format: "%@=%@", key, value)
            }.joined(separator: "&")
    }
}

struct ConnpassAPI {
    typealias Completion = ([ConnpassEvent]) -> ()
    typealias Failure = (Error?) -> ()
    
    enum Errors: Error {
        case jsonSerialize
    }
    
    func search(_ search: ConnpassQuery? = nil, completion: Completion? = nil, failure: Failure? = nil) {
        var path: String = "https://connpass.com/api/v1/event/"
        if let search: ConnpassQuery = search {
            path += String(format: "?%@", search.queryString)
        }
        guard let url: URL = URL(string: path) else { return }
        
        let session: URLSession = URLSession.shared
        let task: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data: Data = data {
                do {
                    guard let json: [AnyHashable: Any] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [AnyHashable: Any] else {
                        failure?(Errors.jsonSerialize)
                        return
                    }
                    
                    guard let events: [[AnyHashable: Any]] = json.value(with: "events") else { return }
                    completion?(events.flatMap { ConnpassEvent(dictionary: $0) })
                } catch (let error) {
                    failure?(error)
                }
            } else if let error = error {
                failure?(error)
            }
        }
        task.resume()
    }
}

struct ConnpassEvent {
    struct Series {
        var seriesId: Int
        var title: String?
        var url: URL?
        
        init?(dictionary: [AnyHashable: Any]?) {
            guard let seriesId: Int = dictionary?.intValue(with: "id") else { return nil }
            self.seriesId = seriesId
            self.title = dictionary?.value(with: "title")
            
            if let url: String = dictionary?.value(with: "url") {
                self.url = URL(string: url)
            }
        }
    }
    
    enum EventType: String {
        case participation
        case advertisement
    }
    
    var eventId: Int
    var title: String?
    var catchCopy: String?
    var description: String?
    var eventUrl: URL?
    var hashTag: String?
    var startedAt: String?
    var endedAt: String?
    var limit: Int?
    var eventType: EventType?
    var series: Series?
    var address: String?
    var place: String?
    var lat: Double?
    var lon: Double?
    var ownerId: Int?
    var ownerNickname: String?
    var ownerDisplayName: String?
    var accepted: Int?
    var waiting: Int?
    var updatedAt: String?
    
    init?(dictionary: [AnyHashable: Any]) {
        guard let eventId: Int = dictionary.intValue(with: "event_id") else { return nil }
        self.eventId = eventId
        self.title = dictionary.value(with: "title")
        self.catchCopy = dictionary.value(with: "catch")
        self.description = dictionary.value(with: "description")
        
        if let eventUrl: String = dictionary.value(with: "event_url") {
            self.eventUrl = URL(string: eventUrl)
        }
        
        self.hashTag = dictionary.value(with: "hash_tag")
        self.startedAt = dictionary.value(with: "started_at")
        self.endedAt = dictionary.value(with: "ended_at")
        self.limit = dictionary.intValue(with: "limit")
        
        if let eventType: String = dictionary.value(with: "event_type") {
            self.eventType = EventType(rawValue: eventType)
        }
        
        self.series = Series(dictionary: dictionary.value(with: "series"))
        self.address = dictionary.value(with: "address")
        self.place = dictionary.value(with: "place")
        self.lat = dictionary.doubleValue(with: "lat")
        self.lon = dictionary.doubleValue(with: "lon")
        self.ownerId = dictionary.intValue(with: "owner_id")
        self.ownerNickname = dictionary.value(with: "owner_nickname")
        self.ownerDisplayName = dictionary.value(with: "owner_display_name")
        self.accepted = dictionary.intValue(with: "accepted")
        self.waiting = dictionary.intValue(with: "waiting")
        self.updatedAt = dictionary.value(with: "updated_at")
    }
}
