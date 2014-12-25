Notes on experiments with Bali sims #3
====

The following claims need to be tested with multiple runs, e.g. with
Behavior Space.

With only the traditional crop varieties, with medium rainfall:

When pestgrowth-rate and pestdispersal-rate are at their maximum values
of 2.4 and 1.5, the reduction with ignore-neighbors-prob = 0.5 seems to
come mainly from waterstress.  Pestloss doesn't increase.


When pestgrowth-rate and pestdispersal-rate are at their intermediate values
2.2 and 1.0, the reduction with ignore-neighbors-prob = 0.5 seems to
come more from pestloss, or from both pestloss and waterstress.
HOWEVER, sometimes the effect of religion is very weak, if any.  
Maybe because pest tran isn't such a problem, so random planting
patterns aren't so much worse than slightly less random patterns?


When pestgrowth-rate and pestdispersal-rate are at their lowest values
2.0 and 0.6, the reduction with ignore-neighbors-prob = 0.5 is not
large, but it seems to come mainly from pestloss.  Spiritual influence
seems pretty effective.


With low rainfall, and high pest tran, you can actually get an increase
in yield and then a decrease as the big lower-left network becomes
uniform, because of waterstress. But random = 0.5 is still worse.
