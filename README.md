## DCModalSegue

DCModalSegue is a subclass of UIStoryboardSegue which make a slight **pushed back** animation when presented. The presenting animation is inspired by [Gmail App](https://itunes.apple.com/us/app/gmail-email-from-google/id422689480?mt=8) and [Sunrise Calendar.](https://itunes.apple.com/us/app/sunrise-calendar./id599114150?mt=8)


### Screencast

![DCModalSegue GIF Demo](http://d.pr/i/UaZK+)

### Installation

With [CocoaPods] (http://cocoapods.org/), just add line below to your `Podfile` then `pod install`,

```
pod 'DCModalSegue'
```

Otherwise, download manually and then drag **DCModalSegue** folder to your Xcode project.

Finally, ensure **QuartzCore.framework** is added to your project.

### Usage

Create segue in storyboard:

1. Like normal storyboard segue, **control drag** from one scene (or a control) to the scene you want to present.
2. Select the segue type as `custom`.
3. Enter `DCModalSegue` in the `Segue Class` field inside the inspector.
4. That's it :-)

To dismiss the presented view controller, use `[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];` 
instead of `[self dismissViewControllerAnimated:YES completion:nil];`

There is also an unwind segue action created for you (thus no code is needed to dismiss the controller), 
you can set up the dismiss action by control drag to the exit icon (see below) and select the action `modalDonePresenting:`.

![Control Drag to Exit](http://d.pr/i/78KD+)

### Notice

* ARC only
* Unwind segue is only provided in iOS 6
* Now support only portrait iPhone

### Contributions

As an experimental project, there are a lot could be done better. 
So feel free to fork or submit an issue. :-)

### Thanks

Some ideas from [KNSemiModalViewController](https://github.com/kentnguyen/KNSemiModalViewController) and [GC3DFlipTransitionStyleSegue](https://github.com/GlennChiu/GC3DFlipTransitionStyleSegue).

### Contact

Created by [David Chang](https://twitter.com/zetachang).

### License

It's MIT Licese. See file LICENSE for more info.
