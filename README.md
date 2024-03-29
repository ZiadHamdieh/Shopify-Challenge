# ShopifyChallenge

### Cocoapods used

1. SDWebImage

___________________


I devoted a total of 6 hours to this challenge. I am quite happy with some of the ways that I approached this problem, and a little less so with others. In the interest of growth, I compiled a couple of things that I think I could have done better.

### Known Issues with the project

* Some matched cards' doodles some times like to come back to life even though they have no business being there. This could be due to a shady interaction with the cell's dequeueing process. 

* I wasn't sure about the metric used for card matching. The first thought that came to mind was the shape of the doodles, but I then noticed that almost all of them looked different (not enough exact doodle replicas for 10+ matching pairs) so my next thought was color. Unfortunately the color(s) named in the JSON wasn't representative of the doodle's color in the image - possibly a trick I missed?. I also tried seeing a pattern in the product_IDs and other JSON key:value pairs but didn't see one! I blame this one on lack of sleep :). 

In order to keep the ball rolling, I decided to create a dummy array holding the colors of each product.

### In retrospect

Things I learned from this challenge:

* I had initially over-designed the network layer, which led to me focusing on details (e.g. handling URLSession responses & errors) which were maybe out of scope and most of which I ultimately scrapped. I could have invested this time towards coding the algorithm for the randomization of the cards, or towards a header to keep track of the matched cards.

* Dealing with portrait/landscape mode turned out more challenging than I had initially imagined, potentially caused (I believe) by the dequeuing of cells that had already been matched or uncovered. In hindsight, I should have devoted a higher percentage of my time towards this particular part of the challenge.
