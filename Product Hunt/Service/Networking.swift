//
//  Networking.swift
//  Product Hunt
//
//  Created by Yash Nayak on 19/04/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import Foundation

enum Route
{
    // Cases
    case post
    case datefilter(selectedDatePass: String)
    case comments(postId: Int)
    
    
    // Path
    func path() -> String {
        switch self {
        case .post:
            // Get the tech posts of Current Date
            // Ref - https://api.producthunt.com/v1/docs/posts/posts_index_get_the_tech_posts_of_today
            return "posts"
            
        case .datefilter(let selectedDatePass):
            // Request a specific day with the `day` parameter
            // Ref - https://api.producthunt.com/v1/docs/posts/posts_index_request_a_specific_day_with_the_%60day%60_parameter_(tech_category)
            print("Netwoking Swift DatePassed"+selectedDatePass)
            return "posts?day=\(selectedDatePass)"
            
        case .comments:
            // Get the latest comments of post with post_id
            // Ref - https://api.producthunt.com/v1/docs/comments_and_comment_threads/comments_index_get_the_latest_comments
            return "comments"
        }
    }
    
    // URL Parameters - query
    func urlParameters() -> [String : String]
    {
        let date = Date()
        switch self {
        case .post:
            let postParameters = ["search[featured]": "true",
                                  "scope": "public",
                                  "created_at": String(describing: date),
                                  "per_page": "20"]
            return postParameters
            
            
        case .datefilter:
            let postParameters = ["search[featured]": "true",
                                  "scope": "public",
                                  "created_at": String(describing: date),
                                  "per_page": "20"]
            return postParameters
            
        case .comments(let postID):
            let commentsParameters = ["search[post_id]": String(describing: postID),
                                      "scope": "public",
                                      "created_at": String(describing: date),
                                      "per_page": "5"]
            return commentsParameters
        }
    }
    
    
    // Headers
    // Ref - https://api.producthunt.com/v1/docs/posts/posts_index_get_the_tech_posts_of_today
    func headers() -> [String: String]
    {
        let urlHeaders = ["Authorization" : "Bearer 92517803437d68e4832533a405da656b1de3b6203e998530ec4e468ef4a0dc3f",
                          "Accept": "application/json",
                          "Content-Type": "application/json",
                          "Host": "api.producthunt.com"]
        return urlHeaders
    }
    
    // Body
    // If http body is needed for Post request
    func body() -> Data?
    {
        switch self {
        case .post:
            return Data()
        default:
            return nil
        }
    }
}


class Networking
{
    // Singleton
    static let shared = Networking()
    
    // Base URL of Product Hunt API
    let baseUrl = "https://api.producthunt.com/v1/"
    let session = URLSession.shared
    
    // model: Decodable  - If you want parse the data into a decodable object
    func fetch(route: Route,completion: @escaping (Data) -> Void) {
        
        var fullUrlString = URL(string: baseUrl.appending(route.path()))
        fullUrlString = fullUrlString?.appendingQueryParameters(route.urlParameters())
        
        var getReuqest = URLRequest(url: fullUrlString!)
        getReuqest.allHTTPHeaderFields = route.headers()
        
        
        session.dataTask(with: getReuqest) { (data, response, error) in
            if let data = data {
                completion(data)
            }
            else
            {
                print(error?.localizedDescription ?? "Error")
            }
            }.resume()
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
    // This is formatting the query parameters with an ascii table reference therefore we can be returned a json file
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}


extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}
