//
//  FoodInfoRequest.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 18/11/21.
//

import Foundation


enum NetworkError: Error {
    
    case badURL
    case badID
}

class FoodInfoRequest {
    
    @available(iOS 15.0.0, *)
    func getFoodInfo(foodSearch: String) async throws -> [Parsed] {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "edamam.com"
        components.queryItems = [
        URLQueryItem(name: "app_id", value: "0ec6a263"),
        URLQueryItem(name: "app_key", value: "4ed1b4351b462ceb2762f0242ca0b0fc"),
        URLQueryItem(name: "ingr", value: foodSearch)]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }   
        
       let parsed = try? JSONDecoder().decode(ApiResponse.self, from: data)
        return parsed?.parsed ?? []
    
    }
}

//"https://api.edamam.com/api/food-database/v2/parser?app_id=0ec6a263&app_key=4ed1b4351b462ceb2762f0242ca0b0fc&ingr=Blue%20Berry&nutrition-type=cooking"






//enum FoodInfoRequestError: Error {
//    case noDataAvailable
//    case canNotProccessData
//}
//
//struct FoodInfoRequest{
//
//    let resourceURL: URL
//    let API_Key = "4ed1b4351b462ceb2762f0242ca0b0fc"
//    let API_ID = "0ec6a263"
//    var foodNameRequest = ""
//
//    init(foodCode: String) {
//
//
//let resourseString = "https://api.edamam.com/api/food-database/v2/parser?app_id=\(API_ID)app_key=\(API_Key)=\(foodNameRequest)&nutrition-type=cooking"
//
//        guard let resourceURL = URL(string: resourseString) else {fatalError()}
//        self.resourceURL = resourceURL
//    }
//
//    func getFoodInfo (completion: @escaping(Result<[FoodInfoRequest], FoodInfoRequestError>) -> Void) {
//        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
//            guard let jsonData = data else {
//                completion(.failure(.noDataAvailable))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let apiResponse = try decoder.decode(APIResponse.self, from: jsonData)
//                let foodInfoDetail = apiResponse.parsed
//            } catch {
//                completion(.failure(.canNotProccessData))
//            }
//        }
//        dataTask.resume()
//    }
//
//}
