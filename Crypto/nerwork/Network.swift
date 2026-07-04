//
//  Network.swift
//  ArabicBiker
//
//  Created by RAYED AL NOOM on 13/12/2022.
//

import Foundation
import SwiftUI
struct LaravelErrorResponse: Decodable
{
    let message: String
}




var timeoutVal:TimeInterval = 90

class Network {
    


#if DEBUG
public static var urlBase: String = ""
//    public static let urlBase: String = "https://pulpo.pulposoft.net/api/"

#else
public static var urlBase: String = ""
//    public static let urlBase: String = "https://pulpo.pulposoft.net/api/"

#endif

    public enum NetworkError: Error {
        case invalidateSession(String)
        case notAutherized
        case serverError(LaravelErrorResponse)
        case invalidResponse(Int, String)
        case connectivity
        case decodingError(Error, Data, Int?)
        case timeout

    }
    
    
    
    public enum APIs  {
        public static var Login = "login"
    }
    
 
    
    public enum Routes
    {
        case Login
        
        func url() -> String {
            switch self {
//            case .def:
//                return "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=egypt&key=AIzaSyAcmjU9Dtvs-vOETYHmWXpt7wxb1bJhUAw"
            case .Login:
                return Network.urlBase + APIs.Login
            
            }
        }
    }
    

    public enum HTTPMethods: String
    {
        case GET
        case DELETE
        case JSON_POST
        case PUT
        case POST
    }
    
    public enum NetwokrActionStatus: Equatable
    {

        
        case notReady
        case idle
        case busy
        case error(NetworkError)
        
        
        public static func == (lhs: Network.NetwokrActionStatus, rhs: Network.NetwokrActionStatus) -> Bool {
            switch rhs {
            case .error(_):
                if case .error(_) = lhs {
                    return true
                }
            default:
                return rhs == lhs
            }
            
            return false
        }
    }
    
    public static func withTimeout<T>(timeout: TimeInterval, operation: @escaping () async throws -> T) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }
            
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                throw NetworkError.timeout
            }
            
            guard let result = try await group.next() else {
                throw NetworkError.timeout
            }
            
            group.cancelAll()
            
            return result
        }
    }
    
    private static func makeRequest(route: Routes, method: HTTPMethods, auth: Bool = true,isPut:Bool = false) throws -> URLRequest
    {
        @AppStorage("UserToken") var UserToken: String = ""
        @AppStorage("cachedUserToken") var cachedUserToken: String = ""

//        let session: Session = Session.shared
        var q = route.url()
//        if !q.contains("http"){
//                q=cachedUserToken+q
//        }

        let encodedLink = q.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
//        var request = URLRequest(url: URL(string: route.url())!)
        var request = URLRequest(url:  URL(string: encodedLink)!  ) //: route.url())!)

        // laravel

//        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("b7dcbb3bee57ed51b8bcc5e4ec8dd62a", forHTTPHeaderField: "x-auth-app-token")

        
        
//        request.setValue(UUID().uuidString, forHTTPHeaderField: "Postman-Token")

        if method == .JSON_POST || method == .POST //|| method == .JSON_PUT
        {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = HTTPMethods.POST.rawValue //isPut ? HTTPMethods.JSON_PUT.rawValue :  HTTPMethods.POST.rawValue
//            request.httpMethod
        }
        else
        {
            request.httpMethod = method.rawValue
        }
        
        

        if auth {
           
//            guard session.customer != nil else {
//                throw NetworkError.invalidateSession("Local session is invalid can't make auth request")
//            }
            
//            request.setValue("\(session.customer!.accessToken)" , forHTTPHeaderField: "x-auth-token")
            request.setValue("Bearer "+UserToken , forHTTPHeaderField: "Authorization")

            
            
        }
      
        return request
        
    }
    
    public static func UPLOAD2<T: Decodable>(route: Routes, auth: Bool = true, fieldName: String, extraFields: [String: String], fileData: Data,fileExtension: String = "png") async throws -> T {
        
        var request = try makeRequest(route: route, method: .POST, auth: auth)
                 
                 let boundary = "Boundary-\(UUID().uuidString)"
                 request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                 
                 
                 
                 
                 var httpBody: Data = Data()
                 
                 // Additional fields
                 for field in extraFields{
                     httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
                     httpBody.append("Content-Disposition:form-data; name=\"\(field.key)\"\r\n\r\n".data(using: .utf8)!)
                     httpBody.append(field.value.data(using: .utf8)!)
                     httpBody.append("\r\n".data(using: .utf8)!)
                 }
                 
                 
                 
                 httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
                 httpBody.append("Content-Disposition:form-data; name=\"\(fieldName)\"; filename=\"\(fieldName).\(fileExtension)\"\r\n".data(using: .utf8)!)
                 httpBody.append("Content-Type: image/\(fileExtension)\r\n\r\n".data(using: .utf8)!)
                 httpBody.append(fileData)
                 httpBody.append("\r\n".data(using: .utf8)!)
                 httpBody.append("--\(boundary)--".data(using: .utf8)!)
                 
                 request.httpBody = httpBody
                 
                 
                 let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
                 
                 return try Network.makeResponse(data: data, urlResponse: urlResponse)
    }

    private static func makeResponse<T: Decodable>(data: Data, urlResponse: URLResponse) throws -> T
    {
        if let resp  = urlResponse as? HTTPURLResponse
        {
            
//            print(String(data: data, encoding: .utf8))
            
            if (200..<300).contains(resp.statusCode)
            {
                
                
                do {
                                    
                    return try JSONDecoder().decode(T.self, from: data)
                }
                catch(let error)
                {
                    print("docoding issue \(error.localizedDescription)")
                    throw NetworkError.decodingError(error, data, resp.statusCode)
                }
                
                
                
                    
            }
            else
            {
                if resp.statusCode == 401
                {
                    Task{@MainActor in
//                        Session.shared.customer = nil
//                        Session.shared.save()
                    }

                    
                    throw NetworkError.notAutherized
                }
                
                
                if let error = try? JSONDecoder().decode(LaravelErrorResponse.self, from: data)
                {
                    throw NetworkError.serverError(error)
                }
                
                throw NetworkError.invalidResponse(resp.statusCode, String(data: data, encoding: .utf8) ?? "no data")
            }
        }
        
        throw NetworkError.connectivity
    }
    
    
    public static func GET<T: Decodable>(route: Routes, auth: Bool = true) async throws -> T {
        

        let request = try makeRequest(route: route, method: .GET, auth: auth)
        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
            
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
 
    }
    
    public static func GETSec<T: Decodable, B: Encodable>(route: Routes, auth: Bool = true,body: B) async throws -> T {
        

        var request = try makeRequest(route: route, method: .GET, auth: auth)
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
            
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
 
    }
    
    public static func DELETE<T: Decodable>(route: Routes, auth: Bool = true) async throws -> T {
        

        let request = try makeRequest(route: route, method: .DELETE, auth: auth)
        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
            
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
 
    }
    
    public static func POST<T: Decodable, B: Encodable>(route: Routes, auth: Bool = true, body: B) async throws -> T {
     
        var request = try makeRequest(route: route, method: .POST, auth: auth)
        
        let encoder = JSONEncoder()
           encoder.outputFormatting = .prettyPrinted
        request.httpBody = try encoder.encode(body)//JSONEncoder().encode(body)
        
        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
            
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
        
    }
    
    public static func UPLOAD3<T: Decodable>(
        method: HTTPMethods = .POST,
        route: Routes,
        auth: Bool = true,
        fieldName: String,
        extraFields: [String: String],
        files: [Data],
        fileExtension: String = "png",
        timeoutInterval: TimeInterval = timeoutVal
    ) async throws -> T {
        
        var request = try makeRequest(route: route, method: method, auth: auth)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        
        // Append extra fields
        for (key, value) in extraFields {
            httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            httpBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            httpBody.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Append multiple image files
        for (index, fileData) in files.enumerated() {
            httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            httpBody.append("Content-Disposition: form-data; name=\"\(fieldName)[\(index)]\"; filename=\"\(fieldName)_\(index).\(fileExtension)\"\r\n".data(using: .utf8)!)
            httpBody.append("Content-Type: image/\(fileExtension)\r\n\r\n".data(using: .utf8)!)
            httpBody.append(fileData)
            httpBody.append("\r\n".data(using: .utf8)!)
        }
        
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = httpBody
        
        let (data, urlResponse) = try await withTimeout(timeout: timeoutInterval) {
            try await URLSession.shared.data(for: request)
        }
        
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
    }
    
    public static func UPLOADMultiImageSameTime<T: Decodable>(
        method: HTTPMethods = .POST,
        route: Routes,
        auth: Bool = true,
        fieldName: String,
        extraFields: [String: String],
        fileDataArray: [Data],
        timeoutInterval: TimeInterval = timeoutVal
    ) async throws -> T {
        var request = try makeRequest(route: route, method: method, auth: auth)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        
        // Add extra fields first
        for (key, value) in extraFields {
            httpBody.append("--\(boundary)\r\n")
            httpBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            httpBody.append(value)
            httpBody.append("\r\n")
        }
        
        // Create images array first
        let imagesMetadata = fileDataArray.map { fileData -> [String: String] in
            let fileName = "compressed_\(Int.random(in: 1000000000...9999999999)).jpg"
            let sizeInKB = Double(fileData.count) / 1024.0
            return [
                "name": fileName,
                "size": "\(String(format: "%.3f", sizeInKB))KB"
            ]
        }
        
        // Add image files using the same filenames
        for (index, fileData) in fileDataArray.enumerated() {
            let fileName = imagesMetadata[index]["name"] ?? ""
            
            httpBody.append("--\(boundary)\r\n")
            httpBody.append("Content-Disposition: form-data; name=\"\(fieldName)[]\"; filename=\"\(fileName)\"\r\n")
            httpBody.append("Content-Type: image/jpeg\r\n\r\n")
            httpBody.append(fileData)
            httpBody.append("\r\n")
        }
        
        httpBody.append("--\(boundary)--\r\n")
        request.httpBody = httpBody
        
        let (data, urlResponse) = try await withTimeout(timeout: timeoutInterval) {
            try await URLSession.shared.data(for: request)
        }
        
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
    }


    
    public static func UPLOAD2<T: Decodable>(method: HTTPMethods = .POST, route: Routes, auth: Bool = true, fieldName: String, extraFields: [String: String], fileData: Data, fileExtension: String = "png", timeoutInterval: TimeInterval = timeoutVal) async throws -> T {
        
        var request = try makeRequest(route: route, method: method, auth: auth)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody: Data = Data()
        
        // Additional fields
        for field in extraFields {
            httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            httpBody.append("Content-Disposition: form-data; name=\"\(field.key)\"\r\n\r\n".data(using: .utf8)!)
            httpBody.append("\(field.value)\r\n".data(using: .utf8)!)
        }
        
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fieldName).\(fileExtension)\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: image/\(fileExtension)\r\n\r\n".data(using: .utf8)!)
        httpBody.append(fileData)
        httpBody.append("\r\n".data(using: .utf8)!)
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = httpBody
        


            let (data, urlResponse) = try await withTimeout(timeout: timeoutInterval) {
                try await URLSession.shared.data(for: request)
            }
            
            return try Network.makeResponse(data: data, urlResponse: urlResponse)

    }
 
    public static func POST_JSON<T: Decodable, B: Encodable>(route: Routes, auth: Bool = true, body: B) async throws -> T {
     
        var request = try makeRequest(route: route, method: .JSON_POST, auth: auth)
        
        
        request.httpBody = try JSONEncoder().encode(body)
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
            
        
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
        
    }
    
    public static func POST_WITHOUTBODY<T: Decodable, B: Encodable>(route: Routes, auth: Bool = true, body: B) async throws -> T {

   
            
        var request = try makeRequest(route: route, method: .POST, auth: auth)

        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }

            
            return try Network.makeResponse(data: data, urlResponse: urlResponse)

    }
    
    public static func PUT_JSON<T: Decodable, B: Encodable>(route: Routes, auth: Bool = true, body: B) async throws -> T {
     
        var request = try makeRequest(route: route, method: .PUT, auth: auth,isPut: true)
        
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
            
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
        
    }
    
    public static func POST<T: Decodable>(route: Routes, auth: Bool = true, body: [String: Any]) async throws -> T {
     
        var request = try makeRequest(route: route, method: .JSON_POST, auth: auth)
        
        request.httpBody =  try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
            
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
        
    }
    
    public static func POST2<T: Decodable>(route: Routes, auth: Bool = true, body: [String: Any]) async throws -> T {
     
        var request = try makeRequest(route: route, method: .POST, auth: auth)
        
        request.httpBody =  try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, urlResponse) = try await withTimeout(timeout: timeoutVal) {
            try await URLSession.shared.data(for: request)
        }
            
        return try Network.makeResponse(data: data, urlResponse: urlResponse)
        
    }
    
    
    

}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
