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
    
    // MARK: - Public functions
    
    func getSpecList(completion: @escaping (SpecList?)->()) {
        
        let url = specListURL()
        let headers = header()
        
        Alamofire.request(url,
                          method: .get,
                          headers: headers).responseData { [weak self] response in
                            guard let data = response.value else {
                                print("Response don't received: ", response.error ?? "no error data")
                                return
                            }
                            
                            print("Specilities request: ", response.request?.url?.absoluteString ?? "")
                            
                            let specList = self?.decode(to: SpecList.self, from: data)
                            completion(specList!)
        }
    }
    
    func getDoctors(bySpecialityId id: Int , completion: @escaping (SpecList?)->()) {
        
        let url = specListURL()
        let headers = header()
        
        Alamofire.request(url,
                          method: .get,
                          headers: headers).responseData { [weak self] response in
                            guard let data = response.value else {
                                print("Response don't received: ", response.error ?? "no error data")
                                return
                            }
                            
                            print("Specilities request: ", response.request?.url?.absoluteString ?? "")
                            
                            let specList = self?.decode(to: SpecList.self, from: data)
                            completion(specList!)
        }
    }
    
    
    // MARK: - Connection config
    
    fileprivate func header() -> [String:String] {
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        return ["Authorization": "Basic \(base64Credentials)"]
    }

    fileprivate func specListURL() -> String {
        
        let path = "speciality/city=moscow/onlySimple=1"
        return baseURL + path
    }
    
    fileprivate func doctorListURL(forSpecialityId id: Int) -> String {
        
        let path = "doctor/list/start/city=moscow/specialityID=\(id)"
        return baseURL + path
    }
    
    // MARK: - Generation
    
    // Initiate object/struct from JSON data
    fileprivate func decode<T:Decodable>(to: T.Type, from jsonData: Data?) -> T? {
        guard let jsonData = jsonData else {
            return nil
        }
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedObject
        } catch let error {
            print("Parse error: \(error.localizedDescription)")
            return nil
        }
    }
    

    
}

