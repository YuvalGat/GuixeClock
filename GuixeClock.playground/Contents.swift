/*:
 # Guixé Clock
 This playground was inspired by the [Guixé Clock](http://www.guixe.com/products/ALESSI/Wall_Clocks.html) created by Martí Guixé.
 
 The idea of this clock is to generate sentences: The clock's hands form an arrow, and if you follow the back of the arrow to its front, you'll get a sentence (i.e. Food is Desire).
 
 The original clock isn't very interactive: You can't change the words on the clock or the colours of it.
 
 This playground lets you create and customise your own Guixé clock, allowing you to pick colours for the hands, background and clock itself, and change the words which appear on it.
 
 Customising the clock is very easy: In order to change a word, simply click it to enter a new one. If you want to change the colours, simply choose a colour from the right.
 
 The generated sentence will appear below the clock itself.
 
 - Note:
 In order to get the coordinates of the arrow based on time and other variables (such as lengths of specific parts of the arrow), I had to use a lot of mathematics. For your convenience, I made a PDF file with the corresponding variables and equations using LaTeX and TikZ. It can be found
 
 To get started, open the Assistant Editor and drag the view divider to the left, until you see the whole frame.
 If you are using a MacBook with a small display, make sure you scroll down to see the entirety of the frame (if you use two fingers to scroll, make sure you don't scroll inside the frame but in the grey area around it).
 */

import UIKit
import PlaygroundSupport

let clock = Clock()

PlaygroundPage.current.liveView = clock

