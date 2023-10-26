import Foundation
import UIKit

final public class ResultingLoader: UIView {
    public init(
        size: ResultingLoaderSize = .large(),
        animationSpeed: ResultingLoaderAnimationSpeed = .normal()
    ) {
        self.size = size
        self.animationSpeed = animationSpeed
        super.init(frame: .zero)
        pinViews()
    }
    
   public required init?(coder: NSCoder) {
        self.size = .large()
        self.animationSpeed = .normal()
        super.init(coder: coder)
        pinViews()
    }
    
    /// indicates wheter loader isAnimating or not
    public var isAnimating: Bool { _isAnimating }
    
    /// size of the loader squared frame
    /// - note: `didSet` stops all ongoing animations if incoming value differs from previous one
    public var size: ResultingLoaderSize {
        didSet {
            guard oldValue != size else { return }
            onSizeDidChange()
        }
    }
    
    /// animation speed for both loading state and any resulting state (`.finish()` and `result`)
    /// - note: new value will be applied on next `start()` call
    public var animationSpeed: ResultingLoaderAnimationSpeed
    
    public var loaderColor: UIColor = .loaderStroke {
        didSet {
            guard loaderColor != oldValue else { return }
            circleLayer.strokeColor = loaderColor.cgColor
            circleLayer.setNeedsDisplay()
        }
    }
    
    public func start() {
        startAnimation()
    }
        
    /// stops animations
    /// - Parameter result: if  `result == .some()` - proceeds to result state;  if `.none` - hides itslef and stops animations
    public func finish(result: ResultingLoaderResult? = nil) {
        self._result = result
        if result != nil {
            animateFullStroke()
        } else {
            unregisterObservers()
            circleLayer.removeAllAnimations()
            isHidden = true
            _isAnimating = false
            onCompletion?()
        }
    }
    
    /// - preformed on any animation finishers
    /// (both `finish()` and `result.didSet`)
    public var onCompletion: (() -> Void)?
       
    private var didBecomeActiveObserver: NSObjectProtocol?
    private var _dimension: CGFloat { size.loaderDimensionValue }
    private var _duration: Double { animationSpeed.duration }
    private var _result: ResultingLoaderResult?
    private var _isAnimating = false
    
    private let resultImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    // MARK: - layers
    private let circleLayer = CAShapeLayer().then {
        $0.lineWidth = 3
        $0.lineCap = .round
    }
    private var circlePath: UIBezierPath {
        UIBezierPath(
           arcCenter: CGPoint(
               x: _dimension / 2,
               y: _dimension / 2
           ),
           radius: _dimension / 2,
           startAngle: 0,
           endAngle: CGFloat.pi * 2,
           clockwise: true
       )
    }
    
    // MARK: - layer animations
    private let rotateAnimation = CABasicAnimation(
        keyPath: #keyPath(CAShapeLayer.transform)
    ).then {
        $0.valueFunction = CAValueFunction(name: .rotateZ)
        $0.fromValue = 0
        $0.toValue = CGFloat.pi * 2
        $0.repeatCount = .infinity
    }
    private let endStrokeAnimation = CABasicAnimation(
        keyPath: #keyPath(CAShapeLayer.strokeEnd)
    ).then {
        $0.toValue = 0.51
        $0.fromValue = 1
        $0.repeatCount = .infinity
        $0.autoreverses = true
    }
    private let startStrokeAnimation = CABasicAnimation(
        keyPath: #keyPath(CAShapeLayer.strokeStart)
    ).then {
        $0.toValue = 0.49
        $0.fromValue = 0
        $0.repeatCount = .infinity
        $0.autoreverses = true
    }
    private var dynamicConstraints = [NSLayoutConstraint]()
}

private extension ResultingLoader {
    func pinViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        circleLayer.path = circlePath.cgPath
        layer.addSublayer(circleLayer)
        addSubview(resultImageView)
        dynamicConstraints = [
            widthAnchor.constraint(equalToConstant: _dimension),
            heightAnchor.constraint(equalToConstant: _dimension),
            resultImageView.widthAnchor.constraint(equalToConstant: _dimension * 0.7),
            resultImageView.heightAnchor.constraint(equalToConstant: _dimension * 0.7)
        ]
        NSLayoutConstraint.activate(
            dynamicConstraints +
            [resultImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
             resultImageView.centerXAnchor.constraint(equalTo: centerXAnchor)]
        )
    }
    
    func registerObservers() {
        guard didBecomeActiveObserver == nil else { return }
        didBecomeActiveObserver = NotificationCenter.default
            .addObserver(
                forName: UIApplication.didBecomeActiveNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                if _result != nil {
                    animateFullStroke()
                } else {
                    startAnimation()
                }
            }
    }
    
    func unregisterObservers() {
        if let didBecomeActiveObserver {
            NotificationCenter.default.removeObserver(didBecomeActiveObserver)
            self.didBecomeActiveObserver = nil
        }
    }
    
    func onSizeDidChange() {
        layer.removeAllAnimations()
        circleLayer.removeAllAnimations()
        circleLayer.removeFromSuperlayer()
        dynamicConstraints.forEach {
            $0.constant =  $0.firstItem === resultImageView
            ? _dimension * 0.7
            : _dimension
        }
        setNeedsLayout()
        circleLayer.path = circlePath.cgPath
        layer.addSublayer(circleLayer)
    }
}

// MARK: - animations
private extension ResultingLoader {
    func startAnimation() {
        registerObservers()
        _isAnimating = true
        isHidden = false
        resultImageView.alpha = 0
        layer.removeAllAnimations()
        circleLayer.removeAllAnimations()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = loaderColor.cgColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 1
        rotateAnimation.duration = 4 / 3 * _duration
        endStrokeAnimation.duration = _duration
        startStrokeAnimation.duration = _duration
        layer.add(rotateAnimation, forKey: "rotateAnimation")
        circleLayer.add(endStrokeAnimation, forKey: "endStrokeAnimation")
        circleLayer.add(startStrokeAnimation, forKey: "startStrokeAnimation")
    }
    
    func animateFullStroke() {
        CATransaction.setCompletionBlock { [weak self] in
            self?.unregisterObservers()
            self?.animateResult()
        }
        let duration = 0.3 * _duration
        let startAnimation = CABasicAnimation(
            keyPath: #keyPath(CAShapeLayer.strokeStart)
        ).then { [weak self] in
            guard let self else { return }
            $0.fromValue = self.circleLayer.presentation()?.strokeStart ?? 0.49
            $0.toValue = 0
            $0.duration = duration
        }
        let endAnimation = CABasicAnimation(
            keyPath: #keyPath(CAShapeLayer.strokeEnd)
        ).then { [weak self] in
            guard let self else { return }
            $0.fromValue = self.circleLayer.presentation()?.strokeEnd ?? 0.51
            $0.toValue = 1
            $0.duration = duration
        }
        CATransaction.begin()
        circleLayer.removeAllAnimations()
        circleLayer.add(startAnimation, forKey: "startAnimation")
        circleLayer.add(endAnimation, forKey: "endAnimation")
        CATransaction.commit()
    }
    func animateResult() {
        guard let _result else { return }
        layer.removeAllAnimations()
        CATransaction.setCompletionBlock { [weak self] in
            self?._isAnimating = false
            self?.onCompletion?()
        }
        self._result = nil
        let finalColor = _result.resultColor.cgColor
        let finalDuration = 0.7 * _duration
        resultImageView.tintColor = _result.imageTintColor
        resultImageView.image = _result.resultImage
        let colorAnimation = CABasicAnimation(
            keyPath: #keyPath(CAShapeLayer.fillColor)
        ).then {
            $0.toValue = finalColor
            $0.duration = finalDuration
            $0.isRemovedOnCompletion = true
        }
        let strokeAnimation = CABasicAnimation(
            keyPath: #keyPath(CAShapeLayer.strokeColor)
        ).then {
            $0.toValue = finalColor
            $0.duration = finalDuration
            $0.isRemovedOnCompletion = true
        }
        circleLayer.fillColor = finalColor
        circleLayer.strokeColor = finalColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 1
        CATransaction.begin()
        circleLayer.add(strokeAnimation, forKey: "strokeAnimation")
        circleLayer.add(colorAnimation, forKey: "colorAnimation")
        UIView.animate(withDuration: finalDuration) { [weak self] in
            self?.resultImageView.alpha = 1
        }
        CATransaction.commit()
    }
}
