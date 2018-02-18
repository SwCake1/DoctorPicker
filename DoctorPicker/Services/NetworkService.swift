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
    
    fileprivate let city = "1"
    fileprivate let count = "15"
    
    // MARK: - Public functions
    
    func getSpecList(completion: @escaping ([Speciality]?)->()) {
        
        let url = specListURL()
        
        getObjects(ofType: SpecList.self, fromUrl: url) { (SpecList) in
            completion(SpecList?.list)
        }
    }
    
    func getDoctors(bySpecialityId id: String , completion: @escaping ([Doctor]?)->()) {
        
        let url = doctorListURL(forSpecialityId: id)
        
        getObjects(ofType: DoctorList.self, fromUrl: url) { (DoctorList) in
            completion(DoctorList?.list)
        }
    }
    
    // MARK: - Connection processing
    
    // Get Specialities/Doctors objects from DocDoc API via JSON and decoding
    fileprivate func getObjects<T: Decodable>(ofType type: T.Type, fromUrl url: String, completion: @escaping (T?)->()) {
        
        let headers = header()
        
        Alamofire.request(url,
                          method: .get,
                          headers: headers).responseData { [weak self] response in
                            guard let data = response.value else {
                                print("Response don't received: ", response.error ?? "no error data")
                                return
                            }
                            
                            print("Object request: ", response.request?.url?.absoluteString ?? "")
                            
                            if let objectList = self?.decode(to: type, from: data) {
                                completion(objectList)
                            }
        }
    }
    
    // MARK: - Connection config
    
    fileprivate func header() -> [String:String] {
        
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        return ["Authorization": "Basic \(base64Credentials)"]
    }
    
    fileprivate func specListURL() -> String {
        
        let path = "speciality/city/\(city)/onlySimple/1"
        return baseURL + path
    }
    
    fileprivate func doctorListURL(forSpecialityId id: String) -> String {
        
        let path = "doctor/list/start/0/count/\(count)/city/\(city)/speciality/\(id)"
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

