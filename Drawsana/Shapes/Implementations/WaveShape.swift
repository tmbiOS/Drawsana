//
//  WaveShape.swift
//  Drawsana
//
//  Created by Andrey Rudenko on 04.12.2020.
//  Copyright © 2020 Asana. All rights reserved.
//

import Foundation

public class WaveShape: ShapeWithTwoPoints, ShapeWithStrokeState, ShapeSelectable {

  public static let type = "WaveShape"
  public var id = UUID().uuidString
  public var a: CGPoint = .zero
  public var b: CGPoint = .zero
  public var strokeColor: UIColor = .black
  public var strokeWidth: CGFloat = 1
  public var capStyle: CGLineCap = .round
  public var joinStyle: CGLineJoin = .round
  public var dashPhase: CGFloat?
  public var dashLengths: [CGFloat]?
  private let amplitude: Double
  private let frequency: Double

  public var transform: ShapeTransform = .identity

  public func apply(userSettings: UserSettings) {
  }

  private enum CodingKeys: String, CodingKey {
    case id, a, b, strokeWidth, transform, type, amplitude, frequency
  }

  public init(amplitude: Double, frequency: Double) {
    self.amplitude = amplitude
    self.frequency = frequency
  }

  public required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    let type = try values.decode(String.self, forKey: .type)
    if type != WaveShape.type {
      throw DrawsanaDecodingError.wrongShapeTypeError
    }

    id = try values.decode(String.self, forKey: .id)
    a = try values.decode(CGPoint.self, forKey: .a)
    b = try values.decode(CGPoint.self, forKey: .b)
    strokeWidth = try values.decode(CGFloat.self, forKey: .strokeWidth)

    transform = try values.decodeIfPresent(ShapeTransform.self, forKey: .transform) ?? .identity

    amplitude = try values.decode(Double.self, forKey: .amplitude)
    frequency = try values.decode(Double.self, forKey: .frequency)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(WaveShape.type, forKey: .type)
    try container.encode(id, forKey: .id)
    try container.encode(a, forKey: .a)
    try container.encode(b, forKey: .b)
    try container.encode(strokeWidth, forKey: .strokeWidth)
    try container.encode(amplitude, forKey: .amplitude)
    try container.encode(frequency, forKey: .frequency)

    if !transform.isIdentity {
      try container.encode(transform, forKey: .transform)
    }
  }

  public func render(in context: CGContext) {
    transform.begin(context: context)

    context.setLineCap(capStyle)
    context.setLineJoin(joinStyle)
    context.setLineWidth(strokeWidth)
    context.setStrokeColor(strokeColor.cgColor)
    if let dashPhase = dashPhase, let dashLengths = dashLengths {
      context.setLineDash(phase: dashPhase, lengths: dashLengths)
    } else {
      context.setLineDash(phase: 0, lengths: [])
    }

    let path = UIBezierPath()

    let width = Double(rect.width)
    let height = Double(rect.height)

    let waveLength = width / frequency

    path.move(to: a)

    for x in stride(from: 0, through: width, by: 5) {
      let relativeX = x / waveLength
      let sine = sin(relativeX)
      let y = amplitude * sine + Double(a.y)
      path.addLine(to: CGPoint(x: x + Double(a.x), y: y))
    }

    let tanB = CGFloat(tan(height / width))
    var arcTanB = atan(tanB)
    print(tanB)
    print(arcTanB)
    print("\n")

    if (a.x < b.x && a.y > b.y) || (a.x > b.x && a.y > b.y) {
      //1 //2
      arcTanB = -arcTanB
    } else {
    }

    path.apply(CGAffineTransform(rotationAngle: arcTanB))
    path.stroke()

    let angle = atan2(b.y - a.y, b.x - a.x)
    let arcAmount = CGFloat.pi / 4
    let radius = strokeWidth * 12

    // Nudge arrow out past end of line a little so it doesn't let the line below show through when it's thick
    let arrowOffset = CGPoint(angle: angle, radius: strokeWidth * 2)

    let startPoint = b + arrowOffset
    let point1 = b + CGPoint(angle: angle + arcAmount / 2 + CGFloat.pi, radius: radius) + arrowOffset
    let point2 = b + CGPoint(angle: angle - arcAmount / 2 + CGFloat.pi, radius: radius) + arrowOffset

    context.setLineWidth(0)
    context.move(to: startPoint)
    context.addLine(to: point1)
    context.addLine(to: point2)
    context.fillPath()

    transform.end(context: context)
  }
}
