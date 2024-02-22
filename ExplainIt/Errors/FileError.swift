//
//  FileError.swift
//  ExplainIt
//
//  Created by Vakhtang on 22.02.2024.
//

import Foundation

enum FileError: Error {
    case fileNotFound
    case unableToReadContents
    case other(Error)
}
