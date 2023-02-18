//
//  APIService.swift
//  GameWikiApp
//
//  Created by Celil Aydın on 4.02.2023.
//

import Foundation
import Combine

struct APIService {
    
    enum APIService : Error {
        case encoding
        case badRequest
    }
    
    let API_KEY = "ad888bd83f084a4da683603c5a630fec"
    
    func fetchGameNamePublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        let result = parseQuery(text: keywords)
        var name = String()
        
        switch result {
        case .success(let query):
            name = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://api.rawg.io/api/games?key=\(API_KEY)&search=\(name)"
        let urlResult = parseUrl(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map({$0.data})
                .decode(type: SearchResults.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func fetchGameDetailPublisher(id: Int) -> AnyPublisher<GameDetails,Error> {
        
        let urlString = "https://api.rawg.io/api/games/\(id)?key=\(API_KEY)"
        let urlResult = parseUrl(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map({$0.data})
                .decode(type: GameDetails.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
    }
    
    private func parseQuery(text: String) -> Result<String,Error> {
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return .success(query)
        } else {
            return .failure(APIService.encoding)
        }
    }
    
    private func parseUrl(urlString: String) -> Result<URL,Error> {
        if let url = URL(string: urlString) {
            return .success(url)
        }else {
            return .failure(APIService.badRequest)
        }
    }
    
}
