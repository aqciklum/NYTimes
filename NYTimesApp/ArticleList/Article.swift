//
//  Article.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 29/08/2025.

// Wrapper struct for the API response
struct NYTResponse: Codable {
    let results: [Article]
}

struct Article: Codable, Identifiable {
    let url: String?
    let id: Int?
    let source: String?
    let publishedDate: String?
    let section: String?
    let author: String?
    let type: String?
    let title: String?
    let abstract: String?
    let media: [ArticleMedia]?
    
    public init(url: String? = nil, id: Int? = nil, source: String? = nil, publishedDate: String? = nil, section: String? = nil, author: String? = nil, type: String? = nil, title: String? = nil, abstract: String? = nil, media: [ArticleMedia]? = nil) {
        self.url = url
        self.id = id
        self.source = source
        self.publishedDate = publishedDate
        self.section = section
        self.author = author
        self.type = type
        self.title = title
        self.abstract = abstract
        self.media = media
    }

    var articlImageUrl: String? {
         media?.first?.mediaMetaData?.first(where: { $0.format == "Standard Thumbnail" })?.url
    }

    var detailViewThumb: String? {
        media?.first?.mediaMetaData?.max(by: { $0.size < $1.size})?.url
    }

    enum CodingKeys: String, CodingKey {
        case url
        case id
        case source
        case publishedDate = "published_date"
        case section
        case author = "byline"
        case type
        case title
        case abstract
        case media
    }
}

struct ArticleMedia: Codable {
    let mediaMetaData: [MediaMetadata]?
    enum CodingKeys: String, CodingKey {
        case mediaMetaData = "media-metadata"
    }
}

struct MediaMetadata: Codable {
    let url: String?
    let format: String?
    let height: Int?
    let width: Int?
    var size: Int {
        (width ?? 0) * (height ?? 0)
    }
}
