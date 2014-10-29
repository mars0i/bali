initialnts6.md
====

### See summary below

##### Notes:

Maybe everyone has farming analogues fixed.  Or rather, maybe, peasants
as centers of power wrt rice growing.  And the religious variants are
what are communicated.

So the first popco experiment is to show that you can get division of
what spreads depending on whether royal or peasant, i.e. without any
interaction with NetLogo.

And maybe that's enough.

To integrate this with NetLogo, the idea would be to set the bias on
transmission due to successful analogy very low.  (Maybe by changing
the function that determines the probability of transmission.)  So
that although you get a bias, it's extremely noisy.  (Or maybe the
default level noisiness is enough.)  But then you add in success bias.
So that just by the default bias, you get a very noisy tendency to
adopt the personal-farmer religious ideas, but with success bias you
get more.

In practice what my hypothesis is, is that the conceptions of the
brahmans was known to the peasants, but it was also known that it wasn't
for them.  But then some people adapted it (by substitution, which I'm
not modeling), and considered it as a possibility, and some adopted it,
because it could fit, analogically.  And then it spread through
success bias.

So with the default bias, with very clear, simple analogical structures
like those in crime3, I still get a distribution of outcomes.  Maybe
when success bias is added, I'll instead get a narrower distribution.
But maybe the analogies in the bali sim won't be as clear.

It would be interesting and valuable to make it go the other way: To
show that success bias can overcome the subtleties of analogy bias.  And
then push back on the original analogies.  Maybe that's another project,
or maybe I've already illustrated that with the sanday simulations in
the CASM paper.

Maybe this is the way to do my sim:   Show that the brahman
conceptions don't spread--not by analogy, and not by success bias.
Then show that the peasant variation spreads, but not that reliably.
But then success bias tunes it up, because it's only when you get lots
of the components of the analogy that you get suppression of noisy
cropplan choices.

So for that last plan, I'll need a measure of how close it is to the
correct analogy, and use that to drive the noise-suppressor variable.
Maybe this could just be a domain mean, like what I plot in the bias
scatterplots.


##### Summary:

After running the popco-free two-channel NetLogo simulation:

1. Just run a regular, NetLogo-free popco bias simulations, in which the
biases are brahman vs peasant/rice-farmer.  This will produce a
distribution of outcomes that are nevertheless biased.  (Possibly weaken
the effect by reducing the probability of transmission.)

	Now argue, without actually combining the simulations, that if you had
	both the weak popco bias--to get the ball rolling--and also a
	reinforcing noise suppression that creates success bias, you would get
	an effect as in the real world.


2. To create a *combined* popco/NetLogo simulation:

	a. Create a measure of fit to the psychological situation
	with rice farming (maybe just a per-domain mean), and let
	noise suppression be a function of that.

	b. Let probability of transmission of propositions be a function
	*both* of their activations *and* of success of the speaker
	subak.

	One natural way to do this would be to insert the success bias
	where "trust" operates in popco. This is currently a constant
	multiplier in `update-propn-net-from-utterances` in listen.clj,
	but that's designated as a spot that can be fancied up with
	a function instead.  Let the function be a function of
	success.  Or the modification could be on the probability 
	of transmission, which is not realistic, but simple.

	c. So in this scheme, NetLogo is sending the successfulness of
	each subak over to popco, and then popco sends back a
	noise-supression value for each subak back.  This could be done
	for all subaks at once: Send all of the success biases to popco,
	then wait for popco to do a full timestep, then send back
	suppression values to NetLogo.  Or maybe have a many-to-one
	mapping of ticks between them.  (Maybe also send back to NetLogo
	other info to be displayed.  Or maybe I can display the popco
	stuff through Clojure, in another window.)
