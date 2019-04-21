//
//  Comment.swift
//  Product Hunt
//
//  Created by Yash Nayak on 19/04/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import Foundation

struct Comment {
    // Modeling the properties we want back from the JSON Data
    var body : String?
    // What is the point of initalizing the data?
    init(body: String) {
        self.body = body
    }
}

extension Comment: Decodable {
    // Creating  our case statements to iterate over the data in the JSON File
    
    enum additionalKeys: String, CodingKey {
        // Creating case statements that are nested within the posts list embedded with dictionaries
        case body
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: additionalKeys.self)
        // Return No BOdy if API does not return any Comment
        let body = try container.decodeIfPresent(String.self, forKey: .body) ?? "No body"
        self.init(body: body)
    }
}

struct Comments: Decodable {
    let comments: [Comment]
}
