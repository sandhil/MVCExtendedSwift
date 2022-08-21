

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

struct ApiRequest {
    
    let method: HTTPMethod
    let url: URLConvertible
    let parameters: [String: Any]? = nil
    let encoding: ParameterEncoding = URLEncoding.default
    let headers: [String: String]? = nil
    
}

class APIClient {
    
    let baseURL: URL?
    var headers = HTTPHeaders()
    
    let interceptor: ApiRequestInterceptor!
    
    init(baseURL: URL? = nil) {
        self.baseURL = baseURL
        interceptor = ApiRequestInterceptor(baseURL: baseURL)
    }
    
    func load<T: Decodable>(expecting: T.Type, request: ApiRequest) -> Single<[T]>{
        return string(request.method, request.url, parameters: request.parameters, encoding: request.encoding, interceptor: interceptor)
            .map { try [T].fromJSON($0) }
            .asSingle()
    }
    
    func load<T: Decodable>(expecting: T.Type, request: ApiRequest) -> Single<T>{
        return string(request.method, request.url, parameters: request.parameters, encoding: request.encoding, interceptor: interceptor)
            .map { try T.fromJSON($0) }
            .asSingle()
    }
}

enum DecodableError: Error {
    case illegalInput
}

extension Decodable {
    
    static func fromJSON(_ string: String?) throws -> Self {
        guard string != nil else { throw DecodableError.illegalInput }
        let data = string!.data(using: .utf8)!
        return try JSONDecoder().decode(self, from: data)
    }
    
}
