// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum ApiError: Error {
    case invalidUrl
    case serverConnectionIssue
    case networkIssue
    case decodingIssue
    case unknownIssue
    case timeOut
    case fileNotFound
}

struct ApiUrlConstants  {
    static let baseUrl: String = "newsapi.org"
    static let apiVersion: String = "/v2/"
    static let schema: String = "https"
    static let apiToken: String = "b25d307b4c6647afb670f45925aaf001"
    static let apiTokenKey: String = "apiKey"
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol EndPoint {
    var method: HTTPMethod { get }
    var endPoint: String { get  }
    var queryParams: [String: Any] { get }
    var bodyParams: [String: Any] { get }
    
    @available(iOS 15.0.0, *)
    func request<T: Codable>(fromService: DataServices) async throws -> T
    
    func request<T: Codable>(fromService: DataServices, completion: @escaping @Sendable (Result<T, ApiError>) -> Void)
}

public extension EndPoint {
    
     func generateURLRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = ApiUrlConstants.schema
        components.host =  ApiUrlConstants.baseUrl
        components.path = ApiUrlConstants.apiVersion + self.endPoint
        components.queryItems = self.queryParams.queryItems
        let apiToken = URLQueryItem(name: ApiUrlConstants.apiTokenKey, value: ApiUrlConstants.apiToken)
        components.queryItems?.append(apiToken)
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        // Setting body parameters
        if !bodyParams.isEmpty {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
                request.httpBody = jsonData
            } catch {
                print("Error serializing body parameters: \(error.localizedDescription)")
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    @available(iOS 15.0.0, *)
    func request<T: Codable>(fromService: DataServices = URLSession.shared) async throws -> T {
        guard let request = self.generateURLRequest() else {
            throw ApiError.invalidUrl
        }
        return try await fromService.data(for: request)
    }
    
    func request<T: Codable>(fromService: DataServices = URLSession.shared, completion: @escaping @Sendable (Result<T, ApiError>) -> Void)  {
        guard let request = self.generateURLRequest() else {
            debugPrint("Url Failure")
            completion(.failure(ApiError.invalidUrl))
            return
        }
        fromService.dataTask(for: request, completion: completion)
    }
}

public protocol DataServices {
    func dataTask<T: Codable>(for request: URLRequest, completion: @escaping @Sendable(Result<T, ApiError>) -> Void)
    
    @available(iOS 15.0.0, *)
    func data<T: Codable>(for request: URLRequest) async throws -> T
}

extension URLSession: DataServices {
    
    public func dataTask<T: Codable>(for request: URLRequest, completion: @escaping @Sendable(Result<T, ApiError>) -> Void) {
        
        let task: URLSessionDataTask = dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(self?.handleError(error: error) ?? ApiError.unknownIssue))
                return
            }
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(ApiError.decodingIssue))
            }
        }
        task.resume()
    }
    
    @available(iOS 15.0.0, *)
    public func data<T: Codable>(for request: URLRequest) async throws -> T {
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError.decodingIssue
        }
    }
    
    private func handleError(error: Error?) -> ApiError {
        guard let error else { return ApiError.unknownIssue}
        // hanlde server errors here
        return ApiError.serverConnectionIssue
    }
}

class MockDataServices: DataServices {
    enum Constants {
        static let fileName = "SampleJson"
    }
    
    
    func dataTask<T>(for request: URLRequest, completion: @escaping @Sendable(Result<T, ApiError>) -> Void) where T : Decodable {
        do {
            let data = try Data.fromJSON(fileName: Constants.fileName)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(ApiError.decodingIssue))
        }
    }
    
    func data<T>(for request: URLRequest) async throws -> T where T : Decodable {
        let data = try Data.fromJSON(fileName: Constants.fileName)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

private class TestBundleClass { }

extension Data {
    static func fromJSON(fileName: String) throws -> Data {
        let bundle = Bundle(for: TestBundleClass.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw ApiError.fileNotFound
        }
        return try Data(contentsOf: url)
    }
}

extension Dictionary where Key == String, Value: Any {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        for (key, value) in self {
            if let array = value as? [Any] {
                for arrayValue in array {
                    items.append(URLQueryItem(name: key, value: "\(arrayValue)"))
                }
            } else {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        return items
    }
}



