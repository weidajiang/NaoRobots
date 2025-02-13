/**
 * (C) Copyright IBM Corp. 2018.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation

/**
 The pagination data for the returned objects.
 */
public struct LogPagination: Codable, Equatable {

    /**
     The URL that will return the next page of results, if any.
     */
    public var nextURL: String?

    /**
     Reserved for future use.
     */
    public var matched: Int?

    /**
     A token identifying the next page of results.
     */
    public var nextCursor: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case nextURL = "next_url"
        case matched = "matched"
        case nextCursor = "next_cursor"
    }

}
