import AppKit


enum Edge {
    case Right
    case Left
    case Top
    case Bottom
}

enum Resizing {
    case None
    case Start
    case Active
    case End
}

class ChildViewController: NSViewController {

    var mouseState: MouseState?
    
    var rightConstraint: NSLayoutConstraint?
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var leftConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    var constraints: [NSLayoutConstraint] { [rightConstraint, topConstraint, bottomConstraint, leftConstraint, widthConstraint, heightConstraint].compactMap { $0 } }

    var leftNeighbors: [ChildViewController] = []
    var rightNeighbors: [ChildViewController] = []
    var topNeighbors: [ChildViewController] = []
    var bottomNeighbors: [ChildViewController] = []
    
    override func loadView() {
        view = NSView(frame: .zero)
        mouseState = MouseState(view: view)
        mouseState?.localDragDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    

    func activateConstraints() { NSLayoutConstraint.activate(constraints.filter { !$0.isActive }) }
    

    var leftConstantStart: CGFloat?
    var topConstantStart: CGFloat?
    var bottomConstantStart: CGFloat?
    var widthStart: CGFloat?
    var neighborWidthStarts: [CGFloat] = []
    var rightStart: CGFloat?
    
    
    func resizeFromRightEdge(_ dX: CGFloat) {
        if widthStart == nil {
            widthStart = widthConstraint?.constant ?? 0
            neighborWidthStarts = rightNeighbors.compactMap { $0.widthConstraint?.constant ?? 0 }
        }
        widthConstraint?.constant = dX + (widthStart ?? 0)
        for (i, neighbor) in rightNeighbors.enumerated() {
            neighbor.widthConstraint?.constant = neighborWidthStarts[i] - dX
        }
        
    }
    
    func resizeFromLeftEdge(_ dX: CGFloat) {
        
    }
    
    func resizeFromTopEdge(_ dY: CGFloat) {
        
    }
   
    func resizeFromBottomEdge(_ dY: CGFloat) {

    }
    
    func tryResizing(dX: CGFloat, dY: CGFloat, from edge: Edge) {
        switch edge {
        case .Right:
            resizeFromRightEdge(dX)
        case .Left:
            resizeFromLeftEdge(dX)
        case .Top:
            resizeFromTopEdge(dY)
        case .Bottom:
            resizeFromBottomEdge(dY)
        }
    }
}

extension ChildViewController: MouseStateLocalDrag {
    func dragging(from edge: Edge, dX: CGFloat, dY: CGFloat) {
        tryResizing(dX: dX, dY: dY, from: edge)
    }
    
}

protocol MouseStateLocalDrag: AnyObject {
    func dragging(from edge: Edge, dX: CGFloat, dY: CGFloat)
}
