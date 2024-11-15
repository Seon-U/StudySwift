import Foundation

struct MusicTrack: Codable {
    var title: String
    var artist: String
    var url: URL
    var playTime: Float
    
    enum CodingKeys: String, CodingKey {
        case title = "songName"
        case artist
        case url
        case playTime
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.url = try container.decode(URL.self, forKey: .url)
        self.playTime = try container.decodeIfPresent(Float.self, forKey: .playTime) ?? 0
    }
}

//swift에서 여러줄 입력을 위해 """를 사용, 이런 식으로 작성했다.
let jsonString = """
[
{
    "songName": "Bohemian Rhapsody",
    "artist": "Queen",
    "url": "https://example.com/music/bohemian_rhapsody.mp3"
},
{
    "songName": "네모네모 스폰지밥",
    "artist": "스폰지송",
    "url": "https://example.com/music/spongeBoB.mp3"
},
]
"""

var decodeMusicTrack: [MusicTrack]?

//jsonString값을 지정된 인코딩(utf8)로 인코딩한 데이터를 반환함
if let jsonData = jsonString.data(using: .utf8) {
    let decoder = JSONDecoder()
    do {
        let musicTrack = try decoder.decode([MusicTrack].self, from: jsonData)
        decodeMusicTrack = musicTrack
        print("Decoded Music Track: \(musicTrack)")
    } catch {
        print("Failed to decode JSON: \(error)")
    }
}

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
if let decodeMusicTrack {
    do {
        let encodedData = try encoder.encode(decodeMusicTrack)
        if let jsonString = String(data: encodedData, encoding: .utf8) {
            print("Encoded JSON String:\n\(jsonString)")
        }
    } catch {
        print("Failed to encode JSON: \(error)")
    }
} else {
    print("decodeMusicTrack에 값이 없습니다.")
}

let filePath = try FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: true)
    .appending(component: "musicTrack.json")


let data = try JSONEncoder().encode(decodeMusicTrack)
let outfile = filePath
try data.write(to: outfile, options: [.atomic, .completeFileProtection])


print("파일경로:\(filePath.path(percentEncoded: false))\n데이터내용:\(data)")

if let newData = try? Data(contentsOf: filePath) {
    let myMusicTrack = try JSONDecoder().decode([MusicTrack].self, from: newData)
    print(myMusicTrack)
}
