import Foundation
import Combine

public struct BrowsrLib {
    
    /// Authenticate with Github
    ///  ~NOT NEEDED~
    func authenticate() {
        
    }
    
    /// Lists all organizations, in the order that they were created on GitHub.
    ///  [Source](https://docs.github.com/en/rest/orgs/orgs#list-organizations)
    /// - Parameters:
    ///     - since: An organization ID. Only return organizations with
    ///       an ID greater than this ID.
    ///     - pageSize: The number of results per page (max 100).
    ///       Default: 30
    static public func getOrganizations(since: Int64? = nil, pageSize: Int64? = nil) -> Future<[Organization], GetOrganizationsError> {
        return Future<[Organization], GetOrganizationsError> { promise in
            guard var urlComponents = URLComponents(string: "https://api.github.com/organizations") else {
                promise(.failure(.badURL))
                return
            }
            var queryItems = [URLQueryItem]()
            
            if let since = since {
                queryItems.append(URLQueryItem(name: "since", value: String(since)))
            }
            
            if let pageSize = pageSize {
                queryItems.append(URLQueryItem(name: "per_page", value: String(pageSize)))
            }
            
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                promise(.failure(.badURL))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([Organization].self, from: data)
                        promise(.success(decodedData))
                    } catch let error {
                        print("Error: JSON decoding failed - \(error.localizedDescription)")
                        promise(.failure(.decodeJSONError))
                    }
                }
            }.resume()
        }
    }
    
    /// Searches for organizations with the search input.
    ///  [Source](https://docs.github.com/en/rest/search#constructing-a-search-query)
    /// - Parameters:
    ///     - search: The search input with which the search will be performed.
    /// example https://api.github.com/search/users?q=anon+type:org
    /// sort example: https://api.github.com/search/users?q=anon+type:org&sort=login&order=asc
    
    static public func searchOrganizations(search: String) -> Future<[Organization], SearchOrganizationsError> {
        return Future<[Organization], SearchOrganizationsError> { promise in
            guard var urlComponents = URLComponents(string: "https://api.github.com/search/users") else {
                promise(.failure(.badURL))
                return
            }
            let queryItems = [URLQueryItem(name: "q", value: "\(search)+type:org")]
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                promise(.failure(.badURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(SearchResponse.self, from: data)
                        promise(.success(decodedData.items))
                    } catch let error {
                        print("Error: JSON decoding failed - \(error.localizedDescription)")
                        promise(.failure(.decodeJSONError))
                    }
                }
            }.resume()
        }
    }
}

struct SearchResponse: Codable {
    let totalCount: Int64
    let incompleteResults: Bool
    let items: [Organization]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
