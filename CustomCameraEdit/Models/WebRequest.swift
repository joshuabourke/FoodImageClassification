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
