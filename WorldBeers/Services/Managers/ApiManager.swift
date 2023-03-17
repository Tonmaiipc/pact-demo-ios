//
//  ApiManager.swift
//  WorldBeers
//
//  Created by Pavlos Simas on 15/12/21.
//

import Foundation

class ApiManager {
    public static let shared = ApiManager()

    func retrieveBeers(toURL: String, success: @escaping (([BeerResponse]) -> Void), fail: @escaping ((HTTPError) -> Void)) {
        ServiceManager.shared.callService(
            urlString: toURL,
            method: .get
        ) { (response: [BeerResponse]) in
            success(response)
        } fail: { error in
            fail(error)
        }
    }
}
