//
//  Errors.swift
//  
//
//  Created by Vitor Dinis on 24/10/2022.
//

import Foundation


public enum GetOrganizationsError: Error {
    case badURL
    case notModified
    case decodeDataError
    case decodeJSONError
}

public enum SearchOrganizationsError: Error {
    case badURL
    case notModified
    case decodeError
}
