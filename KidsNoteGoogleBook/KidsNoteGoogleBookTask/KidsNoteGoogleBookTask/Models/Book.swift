//
//  Book.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation


public struct BookResponse: Codable {
    public let kind: String
    public let totalItems: Int
    public let items: [BookItem]?
}

public struct BookItem: Codable {
    public let kind: String
    public let id: String
    public let etag: String
    public let selfLink: String
    public let volumeInfo: VolumeInfo
    public let saleInfo: SaleInfo?
    public let accessInfo: AccessInfo?
}

public struct VolumeInfo: Codable {
    public let title: String
    public let authors: [String]?
    public let publisher: String?
    public let publishedDate: String?
    public let description: String?
    public let industryIdentifiers: [IndustryIdentifier]?
    public let pageCount: Int?
    public let categories: [String]?
    public let averageRating: Double?
    public let ratingsCount: Int?
    public let imageLinks: ImageLinks?
    public let language: String
    public let readingModes: ReadingModes?
}

public struct ReadingModes: Codable {
    public let text:Bool
    public let image:Bool
}

public struct IndustryIdentifier: Codable {
    public let type: String
    public let identifier: String
}

public struct ImageLinks: Codable {
    public let smallThumbnail: String?
    public let thumbnail: String?
}

public struct SaleInfo: Codable {
    public let country: String
    public let saleability: String
    public let isEbook: Bool
    public let listPrice: Price?
    public let retailPrice: Price?
    public let buyLink: String?
}

public struct Price: Codable {
    public let amount: Double
    public let currencyCode: String
}

public struct AccessInfo: Codable {
    public let country: String
    public let viewability: String
    public let embeddable: Bool
    public let publicDomain: Bool
    public let textToSpeechPermission: String
    public let epub: EpubInfo?
    public let pdf: PdfInfo?
    public let webReaderLink: String?
}

public struct EpubInfo: Codable {
    public let isAvailable: Bool
    public let acsTokenLink: String?
}

public struct PdfInfo: Codable {
    public let isAvailable: Bool
    public let acsTokenLink: String?
}

