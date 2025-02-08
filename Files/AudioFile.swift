//
//  AudioFile.swift
//  Aupare
//
//  Created by Akshat on 08/02/25.
//


import Foundation

struct AudioFile: Identifiable {
    let id = UUID()
    let url: URL
    let name: String
    
    init(url: URL) {
        self.url = url
        self.name = url.lastPathComponent
    }
}