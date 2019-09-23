# ShopifyChallenge

### Cocoapods used

1. SDWebImage

### Known Issues

* I wasn't sure about the metric used for card matching. The first thought that came to mind was the shape of the doodles, but I then realized that almost all of them looked different (not enough exact doodle replicas for 10+ matching pairs) so my next thought was immediately color. Unfortunately @. I also tried seeing a pattern in the product_IDs and other JSON key:value pairs but didn't see one! I blame this one on lack of sleep :). 

In order to keep the ball rolling, I decided to create a dummy array holding the colors of each product. I definitely think I could have done better under this aspect.


### Retrospective

Things I learned from this challenge:

* I had initially over-designed the network layer, which led to me getting lost in details for something that I ultimately scrapped.

* Dealing with portrait/landscape mode turned out more challenging than I had initially imagined, possibly because (I believe) the dequeuing of cells that had already been matched or uncovered. In hindsight, I should have devoted a higher percentage of my time on smoothing out this part of the challenge.
