//
//  CurvedShape.swift
//  Drawsana
//
//  Created by Andrey Rudenko on 04.12.2020.
//  Copyright © 2020 Asana. All rights reserved.
//

import UIKit

public class CurvedShape: ShapeWithTwoPoints, ShapeWithStrokeState, ShapeSelectable {
  public static let type = "CurvedShape"
  public var id = UUID().uuidString
  public var a: CGPoint = .zero
  public var b: CGPoint = .zero
  public var strokeColor: UIColor = .black
  public var strokeWidth: CGFloat = 1
  public var capStyle: CGLineCap = .round
  public var joinStyle: CGLineJoin = .round
  public var dashPhase: CGFloat?
  public var dashLengths: [CGFloat]?

  public var transform: ShapeTransform = .identity

  public func apply(userSettings: UserSettings) {
  }

  private enum CodingKeys: String, CodingKey {
    case id, a, b, strokeWidth, transform, type
  }

  public init() {
  }

  public required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    let type = try values.decode(String.self, forKey: .type)
    if type != CurvedShape.type {
      throw DrawsanaDecodingError.wrongShapeTypeError
    }

    id = try values.decode(String.self, forKey: .id)
    a = try values.decode(CGPoint.self, forKey: .a)
    b = try values.decode(CGPoint.self, forKey: .b)
    strokeWidth = try values.decode(CGFloat.self, forKey: .strokeWidth)

    transform = try values.decodeIfPresent(ShapeTransform.self, forKey: .transform) ?? .identity
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(CurvedShape.type, forKey: .type)
    try container.encode(id, forKey: .id)
    try container.encode(a, forKey: .a)
    try container.encode(b, forKey: .b)
    try container.encode(strokeWidth, forKey: .strokeWidth)

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

    let curveСoefficient: CGFloat
    let heightAndWeight = rect.height + rect.width

    switch heightAndWeight {

    case 0...40:
      curveСoefficient = heightAndWeight / 15

    case 40...150:
      curveСoefficient = heightAndWeight / 12

    case 150...:
      curveСoefficient = heightAndWeight / 10

    default:
      curveСoefficient = rect.midY / 15
    }

    let controlQuadCurvePoint = CGPoint(x: rect.midX, y: rect.midY - curveСoefficient)
    context.move(to: a)
    context.addQuadCurve(to: b, control: controlQuadCurvePoint)
    context.strokePath()

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
