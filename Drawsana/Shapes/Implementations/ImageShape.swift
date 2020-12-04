//
//  ImageShape.swift
//  Drawsana
//
//  Created by Andrey Rudenko on 04.12.2020.
//  Copyright © 2020 Asana. All rights reserved.
//

import Foundation

public class ImageShape: ShapeWithTwoPoints, ShapeSelectable {
  public static let type = "ImageShape"
  public var id = UUID().uuidString
  public var a: CGPoint = .zero
  public var b: CGPoint = .zero
  public var strokeWidth: CGFloat = 0.0

  private var image: UIImage
  private var imageName: String

  public var transform: ShapeTransform = .identity

  public func apply(userSettings: UserSettings) {
  }

  private enum CodingKeys: String, CodingKey {
    case id, a, b, strokeWidth, transform, type, imageName
  }

  public init(withImageName name: String) {
    self.imageName = name
    self.image = UIImage(named: imageName)!
  }

  public required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    let type = try values.decode(String.self, forKey: .type)
    if type != ImageShape.type {
      throw DrawsanaDecodingError.wrongShapeTypeError
    }

    id = try values.decode(String.self, forKey: .id)
    a = try values.decode(CGPoint.self, forKey: .a)
    b = try values.decode(CGPoint.self, forKey: .b)
    strokeWidth = try values.decode(CGFloat.self, forKey: .strokeWidth)

    transform = try values.decodeIfPresent(ShapeTransform.self, forKey: .transform) ?? .identity
    imageName = try values.decode(String.self, forKey: .imageName)
    image = UIImage(named: imageName)!
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(ImageShape.type, forKey: .type)
    try container.encode(id, forKey: .id)
    try container.encode(a, forKey: .a)
    try container.encode(b, forKey: .b)
    try container.encode(strokeWidth, forKey: .strokeWidth)

    if !transform.isIdentity {
      try container.encode(transform, forKey: .transform)
    }

    try container.encode(imageName, forKey: .imageName)
  }

  public func render(in context: CGContext) {
    transform.begin(context: context)
    image.draw(in: rect)
    transform.end(context: context)
  }
}
