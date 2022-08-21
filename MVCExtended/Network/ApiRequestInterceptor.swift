import Alamofire
import KeychainAccess
import Foundation
import RxAlamofire
import RxSwift


class ApiRequestInterceptor: RequestInterceptor {
    let baseURL: URL?
    let keychain = Keychain()
    
    private var accessToken: String? {
        didSet {
            do {
                try keychain.set(accessToken ?? "", key: "accessToken")
            }
            catch let error {
                print(error)
            }
        }
    }
    
    private var refreshToken: String? {
        didSet {
            do {
                try keychain.set(refreshToken ?? "", key: "refreshToken")
            }
            catch let error {
                print(error)
            }
        }
    }
    
    
    init(baseURL: URL? = nil) {
        self.baseURL = baseURL
        let accessToken = keychain["accessToken"]
        let refreshToken = keychain["refreshToken"]
        do {
            try keychain.set("", key: "accessToken")
            try keychain.set("", key: "refreshToken")
        } catch {
            
        }
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let bearerToken = "Bearer \(accessToken ?? "")"
        urlRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        switch response?.statusCode ?? -1 {
        case 401:
            authenticate { result in
                completion(result)
            }
        default:
            completion(.doNotRetryWithError(error))
        }
    }
    
    func authenticate(completion: @escaping (RetryResult) -> Void) {
        getOrRefreshToken(isRefreshToken: accessToken != "") { retryResult in
            completion(retryResult)
            
        }
    }
    
    private func path(_ path: String) -> String {
        return (baseURL != nil) ? "\(baseURL!.absoluteString)/api\(path)" : path
    }
    
    func getOrRefreshToken (isRefreshToken: Bool, completion: @escaping (RetryResult) -> Void) {
        makeRequest(isRefreshToken: isRefreshToken) { retryResult in
            completion(retryResult)
        }
    }
    
    func makeRequest(isRefreshToken: Bool, completion: @escaping (RetryResult) -> Void) {
        let refreshTokenParams = [
            "accessToken": self.accessToken,
            "password":self.refreshToken]
        let publicLoginParams = [
            "userName": "public@domain.com",
            "password":"passw0rd"]
        
        let refreshTokenPath = path("/Account/refreshToken")
        let publicLoginPath = path("/Account/login")
        AF.request(isRefreshToken ? refreshTokenPath: publicLoginPath, method: .post, parameters: isRefreshToken ? refreshTokenParams as Parameters : publicLoginParams as Parameters, encoding: JSONEncoding.default)
            .responseData { response in
                switch response.response?.statusCode {
                case 200 :
                    if let data = response.data {
                        do {
//                            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
//                            self.accessToken = loginResponse.accessToken
//                            self.refreshToken = loginResponse.refreshToken
                            completion(.retry)
                        } catch {
                            completion(.doNotRetry)
                        }
                    }else {
                        completion(.doNotRetry)
                    }
                case 401:
                    self.makeRequest(isRefreshToken: false) { retryResult in
                        completion(retryResult)
                    }
                default:
                    completion(.doNotRetry)
                }
                
            }
    }
}

extension Error {
    
    func isUnauthorized() -> Bool {
        return statusCode == 401
    }
    
    var statusCode: Int {
        
        guard let afError = self as? AFError else {
            return (self as NSError).userInfo["statusCode"] as? Int ?? -1
        }
        return afError.responseCode ?? 401
        
    }
}
