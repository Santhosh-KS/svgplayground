import Foundation
/*
 <svg version="1.1"
 width="300" height="200"
 xmlns="http://www.w3.org/2000/svg">
 
 <rect width="100%" height="100%" fill="red" />
 
 <circle cx="150" cy="100" r="80" fill="green" />
 
 <text x="150" y="125" font-size="60" text-anchor="middle" fill="white">SVG</text>
 
 </svg>
 */

enum Node {
  indirect case el(String, [(String, String)], [Node])
  case text(String)
}

let s = Node.el("svg",
                [("version", "1.1"), ("width","300"), ("height", "300"), ("xmlns", "http://www.w3.org/2000/svg")],
                [.el("rect", [("width", "100%"), ("height", "100%"), ("fill", "red")], []),
                 .el("circle", [("cx", "150"), ("cy", "100"), ("r","80")], []),
                 .el("text", [("x","150"), ("y","150"), ("font-size", "60"), ("text-anchor", "middle"), ("fill", "white")], [.text("SVG")])]
)

  //dump(s)

extension Node: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    self = .text(value)
  }
}

Node.el("svg",
        [("version", "1.1"), ("width","300"), ("height", "300"), ("xmlns", "http://www.w3.org/2000/svg")],
        [.el("rect", [("width", "100%"), ("height", "100%"), ("fill", "red")], []),
         .el("circle", [("cx", "150"), ("cy", "100"), ("r","80")], []),
         .el("text", [("x","150"), ("y","150"), ("font-size", "60"), ("text-anchor", "middle"), ("fill", "white")], ["SVG"])]
)

func svg(_ attrs: [(String, String)], _ children: [Node]) -> Node {
  return .el("svg", attrs, children)
}

func rect(_ attrs: [(String, String)]) -> Node {
  return .el("rect", attrs, [])
}

func circle(_ attrs: [(String, String)]) -> Node {
  return .el("circle", attrs, [])
}

func text(_ attrs: [(String, String)], _ children: [Node]) -> Node {
  return .el("text", attrs, children)
}

enum MeasurementUnit:String {
  case percent = "%"
  case pixel = "px"
  case millimeter = "mm"
  case centimeter = "cm"
  case inches = "inch"
  case none = ""
}

svg([("version", "1.1"), ("width","300"), ("height", "300"), ("xmlns", "http://www.w3.org/2000/svg")],
    [rect([("width", "100%"), ("height", "100%"), ("fill", "red")]),
     circle( [("cx", "150"), ("cy", "100"), ("r","80")]),
     text([("x","150"), ("y","150"), ("font-size", "60"), ("text-anchor", "middle"), ("fill", "white")], ["SVG"])]
)


func xmlns(_ value: String="http://www.w3.org/2000/svg") -> (String, String) {
  return ("xmlns", value)
}

func version(_ value:String="1.1") -> (String, String) {
  return ("version", value)
}

func width(_ value: Int, _ suffix:MeasurementUnit = .none) -> (String, String) {
  return ("width", "\(value)\(suffix.rawValue)")
}

func height(_ value: Int, _ suffix:MeasurementUnit = .none) -> (String, String) {
  return ("height", "\(value)\(suffix.rawValue)")
}

// TODO: make it pass color object
func fill(_ value: String) -> (String, String) {
  return ("fill", "\(value)")
}

func cx(_ value: Int) -> (String, String) {
  return ("cx", "\(value)")
}

func cy(_ value: Int) -> (String, String) {
  return ("cy", "\(value)")
}

func r(_ value: Int) -> (String, String) {
  return ("r", "\(value)")
}

func x(_ value: Int) -> (String, String) {
  return ("x", "\(value)")
}

func y(_ value: Int) -> (String, String) {
  return ("y", "\(value)")
}

func fontSize(_ value: Int) -> (String, String) {
  return ("font-size", "\(value)")
}

enum AnchorPoint:String {
  case left = "left"
  case right = "right"
  case middle = "middle"
}

func textAnchor(_ value: AnchorPoint) -> (String, String) {
  return ("text-anchor", value.rawValue)
}

let n = svg([version(), width(300), height(200), xmlns()],
            [rect([width(100, .percent), height(100, .percent), fill("red")]),
             circle( [cx(150), cy(100), r(80), fill("green")]),
             text([x(150), y(125), fontSize(60), textAnchor(.middle), fill("white")], ["SVG"])]
)


func render(_ node:Node) -> String {
  switch node {
    case let .el(tag, attributes, children):
      let formattedAttrs = attributes.map { key, value in
        "\(key)=\"\(value)\""
      }.joined(separator: " ")
      let formattedChildren = children.map(render).joined()
      return "<\(tag) \(formattedAttrs)>\(formattedChildren)</\(tag)>"
    case let .text(string):
      return string
  }
}

print(render(n))

import WebKit

let webView = WKWebView(frame: .init(x: 0, y: 0, width: 500, height: 700))
webView.loadHTMLString("<header>"+render(n)+"</header>", baseURL: nil)

import PlaygroundSupport
PlaygroundPage.current.liveView = webView
