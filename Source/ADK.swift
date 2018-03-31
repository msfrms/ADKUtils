//
// Created by Radaev Mikhail on 30.09.17.
// Copyright (c) 2017 ListOK. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SUtils

public enum Flex {
    case shrink(Float)
    case grow(Float)
    case basis(ASDimension)
}

public enum Spacing {
    case before(Float)
    case after(Float)
}

public enum LayoutPosition {
    case start
    case center
    case end
}

public extension ASLayoutElement {

    public var center: ASLayoutSpec {
        return ASCenterLayoutSpec(
                horizontalPosition: .center,
                verticalPosition: .center,
                sizingOption: .minimumSize,
                child: self)
    }

    public var shrink: Self { return self.flex(.shrink(1.0)) }
    public var stretch: Self { return self.alignSelf(.stretch) }
    public static var grow: ASLayoutSpec { return ASLayoutSpec().flex(.grow(1.0)) }

    public func alignSelf(_ align: ASStackLayoutAlignSelf) -> Self {
        self.style.alignSelf = align
        return self
    }

    public func spacing(_ spacing: Spacing) -> Self {
        switch spacing {
        case .before(let value):
            self.style.spacingBefore = CGFloat(value)
        case .after(let value):
            self.style.spacingAfter = CGFloat(value)
        }
        return self
    }

    public func preferred(size: CGSize) -> Self {
        self.style.preferredSize = size
        return self
    }

    public func preferred(width: CGFloat) -> Self {
        return self.preferred(size: CGSize(width: width, height: self.style.preferredSize.height))
    }

    public func preferred(height: CGFloat) -> Self {
        return self.preferred(size: CGSize(width: self.style.preferredSize.width, height: height))
    }

    public func flex(_ flex: Flex) -> Self {
        switch flex {
        case .shrink(let value):
            self.style.flexShrink = CGFloat(value)
        case .grow(let value):
            self.style.flexGrow = CGFloat(value)
        case .basis(let value):
            self.style.flexBasis = value
        }

        return self
    }

    public func overlay(_ element: ASLayoutElement) -> ASLayoutSpec {
        return ASOverlayLayoutSpec(child: self, overlay: element)
    }

    public func relative(vertical: ASRelativeLayoutSpecPosition, horizontal: ASRelativeLayoutSpecPosition) -> ASLayoutSpec {
        return ASRelativeLayoutSpec(
                horizontalPosition: horizontal,
                verticalPosition: vertical,
                sizingOption: [],
                child: self)
    }

    public func insets(_ insests: UIEdgeInsets) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: insests, child: self)
    }
}

public extension ASEditableTextNode {
    public var attributedTextOrEmpty: NSAttributedString { return attributedText.getOrElse(NSAttributedString()) }
}

public extension ASTextNode {
    public var attributedTextOrEmpty: NSAttributedString { return attributedText.getOrElse(NSAttributedString()) }
}

public extension ASButtonNode {

    private struct AssociatedKeys {
        static var commandKey = "adk_button_command_key"
    }

    private var command: Command? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.commandKey) as? Command }

        set {
            let value: Command? = newValue as Command?
            value.foreach { command in
                objc_setAssociatedObject(
                        self,
                        &AssociatedKeys.commandKey,
                        command,
                        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
             }
        }
    }

    public func add(command: Command, event: ASControlNodeEvent) {
        self.addTarget(self, action: #selector(handle), forControlEvents: event)
        self.command = command
    }

    @objc private func handle() {
        self.command?.execute()
    }
}
