

import Foundation
import UIKit

protocol  NetworkProtocol {
    func userDeleteRequest(username: String, complection: @escaping ((Result<UserResponseData, Error>) -> Void))
    func userGetRequest(username: String , completion: @escaping (Result<UserResponseData, Error>) -> Void)
    func userPostRequest(
        id: Int,
        username: String,
        firstname: String,
        lastname: String,
        email: String,
        password: String,
        phone: String,
        userStatus: Int,
        completion: @escaping(Result<UserResponseData,Error>) -> Void)
    func userLogin(username: String, password: String, completion: @escaping (Result<LoginUserResponse, Error>) -> Void)
    func getPets(status: String, completion: @escaping (Result<[PetsResponseData], Error>) -> Void)
    func uploadPetPhoto(id: Int, paramName: String, fileName: String, image: UIImage)
    func backgroundUpdatePets(completion: @escaping ([PetsResponseData]) -> Void)
}

struct NetworkService: NetworkProtocol {

    func backgroundUpdatePets(completion: @escaping ([PetsResponseData]) -> Void) {
        
        let url = URL(string: "https://petstore.swagger.io/v2/pet/findByStatus?status=sold")
        let session = URLSession.shared
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            if let error = error {
                print("Error: \(error)")
            }
            
            if let httpResponse  = response as? HTTPURLResponse {
                print("Response HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            
            do {
                let curretnPetData = try decoder.decode([PetsResponseData].self, from: data)
                //                print(curretnPetData)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    func uploadPetPhoto(id: Int, paramName: String, fileName: String, image: UIImage) {
        
        let url = URL(string: "https://petstore.swagger.io/v2/pet/\(id)/uploadImage")
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        guard url != nil else { return }
        
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data) { responseData, response, error in
            
            if let error = error {
                print("Error: \(error)")
            }
            
            if let httpResponse  = response as? HTTPURLResponse {
                switch httpResponse.statusCode{
                case 200..<300:
                    print("Success: \(httpResponse.statusCode)")
                case 400..<500:
                    print("Request error: \(httpResponse.statusCode)")
                case 500..<600:
                    print("Server error: \(httpResponse.statusCode)")
                default:
                    print("Other error: \(httpResponse.statusCode)")
                }
            }
            
            guard let responseData = responseData else {return}
            
            let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
            
            if let json = jsonData as? [String: Any] { print(json) }
        } .resume()
    }
    
    func userLogin(username: String, password: String, completion: @escaping (Result<LoginUserResponse,Error>) -> Void) {
        request(route: .loginUser(username, password), method: .get, completion: completion)
    }
    
    func userDeleteRequest(username: String, complection: @escaping ((Result<UserResponseData, Error>) -> Void)) {
        request(route: .deleteUser(username), method: .delete, completion: complection)
    }
    
    func userGetRequest(username: String , completion: @escaping (Result<UserResponseData, Error>) -> Void) {
        request(route: .getUser(username), method: .get, completion: completion)
    }
    
    func getPets(status: String, completion: @escaping (Result<[PetsResponseData], Error>) -> Void) {
        request(route: .getPets(status), method: .get, completion: completion)
    }
    
    func userPostRequest(
        id: Int,
        username: String,
        firstname: String,
        lastname: String,
        email: String,
        password: String,
        phone: String,
        userStatus: Int,
        completion: @escaping(Result<UserResponseData,Error>) -> Void) {
        let params = [
            "id": id,
            "username": username,
            "firstname": firstname,
            "lastname": lastname,
            "email": email,
            "password": password,
            "phone": phone,
            "userStatus": userStatus
            
        ] as [String : Any]
        request(route: .createUser, method: .post, parameters: params, completion: completion)
    }
    
    private func request<T: Decodable>(route: Route,
                                       method: Method,
                                       parameters: [String: Any]? = nil,
                                       completion: @escaping  (Result<T, Error>) -> Void) {
        
        guard let request =  createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data,response,error in
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
                let responseString = String(data: data, encoding: .utf8) ?? "Could not stringify our data"
                
                print("The response is: \(responseString)")
            } else if let  error = error {
                result = .failure(error)
                print("The error is: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion, method: method)
            }
            
        }.resume()
    }
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> Void, method: Method) {
        
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode (T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func createRequest(route: Route,
                       method: Method,
                       parameters: [String: Any]? = nil) -> URLRequest? {
        
        let urlString = Route.baseUrl + route.path
        guard let url = URL(string: urlString) else {return nil}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
                
            case .post,.delete:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
                print(params)
                print("Body data is: \(bodyData)")
            }
        }
        return urlRequest
    }
}
