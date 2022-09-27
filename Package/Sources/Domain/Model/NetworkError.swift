//
//  NetworkError.swift
//  
//
//  Created by Yoshiki Hemmi on 2022/09/27.
//

public enum NetworkError: Error {
    case networkError(code: Int, description: String)
    case decodeError(reason: String)
    case irregularError(info: String)
}
