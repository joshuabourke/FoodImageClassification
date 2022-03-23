//
//  CodableBundleExtension.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 23/12/21.
//

import Foundation

extension Bundle {
    
    func decodeFoodJSON <x: Decodable>(_ type: x.Type, from filename: String) -> x? {
        guard let json = url(forResource: filename, withExtension: nil) else {
            print("Failed to locate \(filename) in app bundle.")
            return nil
        }
        do {
            let jsonData = try Data(contentsOf: json)
            let decoder = JSONDecoder()
            let result = try decoder.decode(x.self, from: jsonData)
            return result
        } catch {
            print("Failed to load and decode JSON \(error)")
            return nil
        }
    }
    
    func decode <T: Codable>(_ file: String) -> T {
        //1. Locate the Json File.
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in Bundle")
        }
        //2. Create a property for the data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from Bundle")
        }
        //3. Create a Decoder
        let decoder = JSONDecoder()
        
        //4. Create a property for the decoded data
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from Bundle")
        }
        
        //5. Return ready-to-use data
        return loaded
    }
}
