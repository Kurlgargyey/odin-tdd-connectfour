# odin-tdd-connectfour

This is a practice project for test driven development following The Odin Project curriculum. The task was to make a Connect Four type game.

## Challenges
When I started out writing the tests, I found it pretty difficult not to unconsciously add uncovered code as I was switching to the code side. I think this issue stemmed from a lack of planning on my part. I should think a little more deeply about how I want the program to be organized before laying out the test.

I also think I might have written more tests than I should have. A lot of the methods I wrote should have been private methods, and I think you're not supposed to test those. I didn't **really** understand interface vs. implementation until after this practice.

Still, I believe I practiced the red-green-refactor cycle decently well. My initial passing code was like 66% longer than the final version, because I was able to condense a lot of the victory detection methods.