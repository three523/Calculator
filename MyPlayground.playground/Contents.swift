import Cocoa

let reg = "[0-9]\\(|\\)[0-9]"

let string = "2(2+2)(2+2)2(2+2)+2"

do {
    let regex = try NSRegularExpression(pattern: reg)
    let results = regex.matches(in: string,
                                range: NSRange(string.startIndex..., in: string))
    results.forEach { re in
        print(re.range)
    }
} catch let error {
    print("invalid regex: \(error.localizedDescription)")
}
