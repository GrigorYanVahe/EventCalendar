//
//  NetworkService.swift
//  EventCalendar
//
//  Created by FTLSoft (Vahe) on 12.12.25.
//

import Foundation

final class NetworkService {
    private enum DataProviderType {
        case bundle
        case remoteGitHub
    }
    
    // Change `providerType` property to switch between local and remote data.
    // Use `.bundle` for local data.
    // Use `.remoteGitHub` for remote data from GitHub.
    private static let providerType: DataProviderType = .remoteGitHub
    
    static let shared = NetworkService()
    private let session: URLSession = URLSession.shared
    
    enum Endpoints: String {
        case eventsFilename = "events.json"
        case monthsFilename = "months.json"
        
        private var bundleURL: URL? {
            return Bundle.main.url(forResource: self.rawValue, withExtension: nil)
        }
        
        private var remoteGitHubURL: URL? {
            return URL(string: "https://raw.githubusercontent.com/GrigorYanVahe/EventCalendar/a0107304fd17ef6b0eaf2b78d60f657006e8725d/EventCalendar/Resources/\(self.rawValue)")
        }
        
        var url: URL? {
            return switch providerType {
            case .bundle: bundleURL
            case .remoteGitHub: remoteGitHubURL
            }
        }
    }
    
    enum NetworkError: String, Error {
        case bundleFileMissing = "Bundle file missing"
        case failedToLoadData = "Failed to load data"
        case requestFailed = "Request failed"
        case failedToDecodeData = "Failed to decode data"
        case responseDataIsMissing = "Response data is missing"
    }
    
    func loadEventData(for day: Date, completion: @escaping (Result<[Event], Error>) -> Void) -> URLSessionDataTask? {
        guard let url = Endpoints.eventsFilename.url else {
            completion(.failure(NetworkError.bundleFileMissing))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.responseDataIsMissing))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(formatter)
                
                let result = try decoder.decode([Event].self, from: data).filter({ $0.date.startOfDay == day.startOfDay })
                
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.failedToDecodeData))
            }
        }
        
        task.resume()
        
        return task
    }
    
    func loadMonthData(for month: Date, completion: @escaping (Result<[Date: DaylyData], Error>) -> Void) -> URLSessionDataTask? {
        guard let url = Endpoints.monthsFilename.url else {
            completion(.failure(NetworkError.bundleFileMissing))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.responseDataIsMissing))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let raw = try decoder.decode([String: DaylyData].self, from: data)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                var result: [Date: DaylyData] = [:]
                for (key, value) in raw {
                    if let date = formatter.date(from: key), date.monthAndYearString == month.monthAndYearString {
                        result[date] = value
                    }
                }
                
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.failedToDecodeData))
            }
        }
        
        task.resume()
        
        return task
    }
}
