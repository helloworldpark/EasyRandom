# EasyRandom
EasyRandom is a random number generator written in Swift.

## Examples
#### Discrete Random Generator
Generate discrete items using ```ERDiscreteBuilder<T>```.
```Swift
let discreteBuilder = ERDiscreteBuilder<String>()
_ = discreteBuilder.append(x: "Foo", p: 0.42).append(x: "Bar", p: 0.58)
let discreteRandoms = discreteBuilder.create().generate(count: 10000)
for foobar in discreteRandoms {
    print(foobar)
}
```
<p align="center">
<img src="https://github.com/helloworldpark/helloworldpark.github.com/blob/master/images/2017-01-01-foobar.png">
</p>
#### Continuous Random Generator
Generate continuous random numbers using ```ERContinuousFactory```.
```Swift
// Instantiate factory
let continuousFactory = ERContinuousFactory(from: 0.0, to: M_PI)
// Using Probability Density Function
let byPDF = continuousFactory.pdf { sin($0) }.generate(count: 10000)
for x in byPDF {
    print("\(x)")
}

// Using Cumulative Density Function
let byCDF = continuousFactory.cdf { 0.5 - 0.5*cos($0) }.generate(count: 10000)
for x in byCDF {
    print("\(x)")
}

// Using Inverse Cumulative Density Function
let byICDF = continuousFactory.inverseCDF { acos(1.0 - 2.0 * $0) }.generate(count: 10000)
for x in byICDF {
    print("\(x)")
}
// Results should be same
```
<p align="center">
<img src="https://github.com/helloworldpark/helloworldpark.github.com/blob/master/images/2017-01-01-conti01.png">
<img src="https://github.com/helloworldpark/helloworldpark.github.com/blob/master/images/2017-01-01-conti02.png">
<img src="https://github.com/helloworldpark/helloworldpark.github.com/blob/master/images/2017-01-01-conti03.png">
</p>

Note that the integral of probability density function need not be 1. The module will compensate for it.

## Implementation
### Random Number Generation
The random numbers are generated by ```arc4random()``` included in ```Framework```.
### Discrete Random Generator
Once you instantiate ```ERDiscrete<T>```, it holds a table of integers and its corresponding cumulative density. For a given random number ```u``` between 0 and 1, ```ERDiscrete``` searches for the range the ```u``` would belong on the table. In terms of mathematics, it searches for inverse image using the table constructed above.
### Continuous Random Generator
There are 3 different implementations of Continuous Random Generator.
#### Using PDF
Note that the PDF need not have the property of its integral being 1. The generator constructs pseudo-inverse cumulative density distribution by calculating integrals and spline interpolation. Generating might be quite a costly job, since the generator increases the number of partitions for spline interpolation until the norm(the maximum width of the partitions of the given interval) is sufficiently small(it is set to be 0.01).
#### Using CDF
For the CDF implementation, the generator uses Root Finding Algorithm, which is implemented by Bisection Algorithm.
#### Using Inverse CDF
The calculation is the lightest. It merely calculates the function.

## Installation
You can install EasyRandom via CocoaPods
```CocoaPods
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'EasyRandom', '~> 0.9.2'
end
```

## Requirements
 - iOS 8.0 or higher
 - macOS 10.10 or higher
 - Xcode 8.2 or higher

## License
MIT License.