import AppKit

enum NearEdge {
    case Left
    case Right
    case Bottom
    case Top
}

class MouseState {
    var mouseLocation: CGPoint?
    
    var mouseDownLocation: CGPoint?
    var globalMouseDownLocation: CGPoint?
    
    var mouseUpLocation: CGPoint?
    var inView = false
    var nearLeftEdge = false
    var nearRightEdge = false
    var nearTopEdge = false
    var nearBottomEdge = false
    var draggingThatStartedLocally = false
    var uuid = UUID()

    var mouseDownNearEdges: [Edge] = []
    var viewTracking: NSView
    
    weak var localDragDelegate: MouseStateLocalDrag?
    
    init(view: NSView) {
        viewTracking = view
    }

    func pointInView(_ point: CGPoint?) -> Bool {
        guard let point = point else { return false }
        return viewTracking.frame.contains(point)
    }
    
    func localLocationInView(_ point: CGPoint?) -> CGPoint? {
        guard let point = point else { return nil }
        guard viewTracking.frame.contains(point) else { return nil }
        return viewTracking.convert(point, from: nil)
    }
    
    func mouseLocation(location: CGPoint) {
        mouseLocation = location
    }
    
    func leftMouseDown(location: CGPoint) {
        mouseDownNearEdges = []
        mouseDownLocation = location
        guard viewTracking.frame.contains(location) else { return }
        let localPoint = viewTracking.convert(location, from: viewTracking.window?.contentView)
        if localPoint.x > viewTracking.frame.width - 10.0 { mouseDownNearEdges.append(.Right) }
        if localPoint.x < 10.0 { mouseDownNearEdges.append(.Left) }
//        if abs(viewTracking.frame.height - localMouseDownLocation.y) < 5.0 { mouseDownNearEdges.append(.Top) }
//        if localMouseDownLocation.y < 5.0 { mouseDownNearEdges.append(.Bottom) }
    }

    func leftMouseUp(location: CGPoint) {
        mouseDownLocation = nil
    }
    
    func leftMouseDragged(location: CGPoint, event: NSEvent) {
        guard let mouseDownLocation = mouseDownLocation else { return }
        let dX = location.x - mouseDownLocation.x
        let dY = location.y - mouseDownLocation.y
        mouseDownNearEdges.forEach { localDragDelegate?.dragging(from: $0, dX: dX, dY: dY) }
    }
}
