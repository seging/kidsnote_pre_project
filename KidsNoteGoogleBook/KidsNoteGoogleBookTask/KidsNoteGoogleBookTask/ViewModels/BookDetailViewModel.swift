//
//  BookDetailViewModel.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation
import Combine

public class BookDetailViewModel: ObservableObject {
    public let book: BookItem
    
    public init(book: BookItem) {
        self.book = book
    }
}
