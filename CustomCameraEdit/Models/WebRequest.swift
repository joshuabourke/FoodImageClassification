//
//  WebRequest.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 12/11/21.
//


import Foundation

struct Post: Codable, Identifiable {
    
    let id = UUID()
    var title: String
    var email: String
    var author: String
    
}

class Api {
    
    @Published var posts = [Post]()
    
    func getPosts(completion: @escaping ([Post]) -> ()) {
        guard let url = URL(string: "https://training.xcelvations.com/data/books.json") else {
            print("Invalid URL....")
            
            return }
        
        URLSession.shared.dataTask(with: url) { data, repsonse, error in
            let posts = try! JSONDecoder().decode([Post].self, from: data!)
            print(posts)
            DispatchQueue.main.async {
                completion(posts)
            }
            
        }
        .resume()
    }
    
}


//Food Api web: "https://api.edamam.com/api/food-database/v2/parser?app_id=0ec6a263&app_key=4ed1b4351b462ceb2762f0242ca0b0fc&ingr=Apple&nutrition-type=cooking"

//Properties: id = UUID(), var title: String var title: String, var email: String, var author: String

//Test Api web: "https://training.xcelvations.com/data/books.json"
