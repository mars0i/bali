Plan1.md
====

## a plan:

#### In creating the two-channel NetLogo simulation:

Note that at present the determination of success takes place in code
embedded in `imitatebestneighbor`.  

1. This should be abstracted out into a separate function.  Then
	I can code the second transmission channel outside of
	`imitatebestneighbor` in a separate function, and use the same
	success-returning function.

	Then in the combined version, the success-returning function can
	be called to get data to send to popco.

2. And in the combined version, the second-channel transmission
function will get the suppression value from popco, rather than
from subaks in NetLogo.

#### After running the popco-free two-channel NetLogo simulation:

Just run a regular, NetLogo-free popco bias simulations, in which the
biases are brahman vs peasant/rice-farmer.  This will produce a
distribution of outcomes that are nevertheless biased.  (Possibly weaken
the effect by reducing the probability of transmission.)

Now argue, without actually combining the simulations, that if you had
both the weak popco bias--to get the ball rolling--and also a
reinforcing noise suppression that creates success bias, you would get
an effect as in the real world.


#### To create a *combined* popco/NetLogo simulation:

1. Create a measure of fit to the psychological situation
	with rice farming (maybe just a per-domain mean), and let
	noise suppression be a function of that.

2. Let probability of transmission of propositions be a function
	*both* of their activations *and* of success of the speaker
	subak.

	(One natural way to do this would be to insert the success bias
	where "trust" operates in popco. This is currently a constant
	multiplier in `update-propn-net-from-utterances` in listen.clj,
	but that's designated as a spot that can be fancied up with
	a function instead.  Let the function be a function of
	success.  Or the modification could be on the probability 
	of transmission, which is not realistic, but simple.)

3. So in this scheme, NetLogo is sending the successfulness of
	each subak over to popco, and then popco sends back a
	noise-supression value for each subak back.  This could be done
	for all subaks at once: Send all of the success biases to popco,
	then wait for popco to do a full timestep, then send back
	suppression values to NetLogo.  Or maybe have a many-to-one
	mapping of ticks between them.  (Maybe also send back to NetLogo
	other info to be displayed.  Or maybe I can display the popco
	stuff through Clojure, in another window.)
