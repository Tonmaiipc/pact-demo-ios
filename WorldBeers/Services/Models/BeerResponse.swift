//
//  BeerResponse.swift
//  WorldBeers
//
//  Created by Pavlos Simas on 15/12/21.
//

import Foundation

class BeerResponse: Decodable, Equatable {
    static func == (lhs: BeerResponse, rhs: BeerResponse) -> Bool {
        return lhs.name == rhs.name &&
        lhs.abv == rhs.abv &&
        lhs.tagline == rhs.tagline &&
        lhs.image_url == rhs.image_url &&
        lhs.ibu == rhs.ibu
    }

    let name: String?
    let tagline: String?
    let image_url: String?
    let abv: Double?
    let ibu: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case tagline
        case image_url
        case abv
        case ibu
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.image_url = try container.decodeIfPresent(String.self, forKey: .image_url)
        self.abv = try container.decodeIfPresent(Double.self, forKey: .abv)
        self.ibu = try container.decodeIfPresent(Double.self, forKey: .ibu)
    }
}
