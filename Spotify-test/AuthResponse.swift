//
//  AuthResponse.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/1/21.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}


//{
//    "access_token" = "BQC2sPEbYWHuBDYort8vfAvnI4cGJG9r3yNK9JRXmpJ3zVROT8hyxgeAlufPLb7wEY-uES5GVMT4cDs3XIcSuyQj5wsvhufPHTSt4VoZ64iOvv0rTCQTPKK47by5tbACZKQS6UX6dnZuFq1UcRa0ubbg8k-4";
//    "expires_in" = 3600;
//    "refresh_token" = "AQCLi2Fx7JvlaeynbWEsUoCxpSbxcR_lLwJiKWcjNkoodDymuqC7GPkkx6YOpTcXjQwodW2QsBQ5jKMSMhlJaC5YVLBu-LV51JL5SPbOA7UbZOXKfRj86BjFei6JC1hHiQE";
//    scope = "user-read-private";
//    "token_type" = Bearer;
//}
