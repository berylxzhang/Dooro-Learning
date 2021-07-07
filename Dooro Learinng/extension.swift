//
//  extension.swift
//  Dooro Learinng
//
//  Created by Beryl Zhang on 7/5/21.
//

import Foundation
import KMPlaceholderTextView

extension UITextView{
    func centerVertically() {
        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        self.contentInset.top = topCorrect
    }
}
