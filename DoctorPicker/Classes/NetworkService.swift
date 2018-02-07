//
//  NetworkService.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 07.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    
    // MARK: - Singleton
    
    static var shared = NetworkService()
    private init() {}
    
    // MARK: - Constants
    
    fileprivate let baseURL = "https://api.docdoc.ru/public/rest/1.0.9/"
    fileprivate let user = "partner.13703"
    fileprivate let password = "ZZdFmtJD" // open pass in let - only for demo app
    
    // MARK: - Requests
    
    func request() {
        
        let path = "speciality/city=moscow/onlySimple=1"
        let url = baseURL + path
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        
        Alamofire.request(url,
                          method: .get,
                          headers: headers).response { [weak self] response in
//                            guard let data = response else {
//                                print("Не удалось получить JSON: ", response.error ?? "нет данных")
//                                return
//                            }
                            
                            let request = response.request?.url?.absoluteString ?? ""
                            print("Запрос данных: ", request)
                            print("Data: ", response.data)
                            dump(response.data!)

                            

                            
                            //            let filteredJSONFeeds = json["near_earth_objects"][stringDate].array?.filter{
                            //                $0["close_approach_data"][0]["orbiting_body"] == "Earth" }
                            //            let asteroids  = filteredJSONFeeds?.map { Asteroid(json: $0) } ?? []
                            //
                            //            self?.updateCache(with: asteroids, on: stringDate)
                            //
                            //            completion(asteroids)
        }
    }    
}
