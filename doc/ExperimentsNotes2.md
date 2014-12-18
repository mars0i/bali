Notes on experiments with Bali sims #2
====

What is the effect of success bias compared to analogy bias?

Here are two ways to test what success bias contributes on top of
analogy bias in two ways:

1. In popco alone, see what effect simple success bias (e.g. as a
   function of per-person/subak mean activation of spiritual-peasant
   propositions) has on the distribution (and perhaps paths) of run mean
   activations.

2. In NetLogo-popco, see what effect NetLogo success bias (e.g. as a
   crop yield) has on the distribution (and perhaps paths) of run mean
   activations.


A separate (and maybe more interesting) question is this:  What does
analogy bias contribute in addition to success bias?

The general answer should be that it fosters certain non-random patterns
on which selection can act.  I'd argue that this is useful, in general,
since these will be patterns that have a greater chance of matching
world patterns.  Analogy is a heuristic for coadaptation of beliefs
that is continuous with other methods of generalization.

Here are ways to experiment for this question:

1. In popco alone, see what effect adding analogy has on simple
   success bias.  Hypothesis: Without analogy, success bias on SP
   propositions will have a harder time getting started, and will take
   longer to get where it's going.  And the distribution of end states
   might be broader.  
   [This would especially be true if I weaken the
   influence of analogy.  This might involve changing parameters in
   the analogy net, so that it's harder to get an analogy going.  Or
   it might be by making the influence of the analogy net on the
   proposition net weaker.  Or maybe more directly, lowering the
   probability of uttering or the weight added on links to SALIENT
   when an utterance is received.]

2. Can I do an analogous test using NetLogo-popco?  Yes, why not?
   Since noise-suppression in NetLogo will be a function of average
   spiritual-peasant activation in popco, a broader distribution of
   spiritual-peasant activations will produce less noise suppression,
   hence less effect of spiritual-peasant propositions to select on in
   NetLogo, hence a noisier effect back to success-bias in popco
   influencing who is listened to in popco.  Whereas adding analogy
   should focus the noisy set of propositions and allow more cohesive,
   stronger effects to suppress noise and hence generate success-bias.

###### *That* would be a nice thing to show: Random variation isn't enough.

Note that there's a little bit of artificiality here, since I'm assuming
that the collection of spiritual-peasant propositions facilitates
noise-supression, and therefore success.
