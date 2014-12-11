ArchitectureNotes6.md
====
Distillation of ArchitectureNotes6.md, q.v. for additional info.

----

key:

	SP: spiritual peasant propositions
	SB: spiritual brahmanic propositions
	WP: worldly peasant propositions
	WB: worldly brahmanic propositions

----

2. WP=>SP: High activation of WP (vs SB) should bias transmission toward
SP (vs. WB).<br/></br>

3. Success should bias transmission of whatever the successful
individual believes (`trustworthiness`).<br/></br>

4. Noise-suppression in NetLogo should be linked to (e.g.) mean activn of SP in popco:<br/>
In a linked simulation, the spiritual float value for a subak should be a function of its mean
SP activn.<br/></br>

5. As a result, success (yield) in NetLogo will be correlated with mean
activn of SP<br/>(under conditions that allow the spiritual float to have an effect).<br/></br>

Here's the pattern:

![alt text](TransmissionBiases.pdf?raw=true "transmission biases figure")

<div align="center">
<img src="TransmissionBiases.pdf">
</div>

which can be summarized like this:

<div align="center">
<img src="TransmissionBiasesSummary.pdf"/>
</div>

(Note that "SP" in these figures is playing two roles: It represents both
activations of individual spiritual-peasant propositions, and the mean
activation of all spiritual-peasant propositions.)

i.e. this is how the combined NetLog-popco Bali system should work:

1. Only WP, not WB propns are present in popco.  they are pushed up by
the environment.  This biases transmission of SP over SB.  (Note that
not all of the WP propns are really what one would *observe* "in
nature".  Some of the propns capture ways of thinking about subaks, for
example.  However, if we think of the subak system as pre-existing, but
without ideal religious values, it still makes sense to have the WP
propns emphasized by the env.  Not doubt the real evolution was more
subtle, and maybe it would be worth modeling that later.)

2. When mean SP activn is high, spiritual float in NetLogo is high.

3. When there is a nonzero ignore-pestneighbor probability, the spiritual float for an
   individual makes the prob of ignoring pestneighbors lower.

4. This lowering due to the spiritual float will make sucess more likely.

5. Transmission is further biased by success.  i.e. there is a trustworthiness variable or other function
in popco that is a function of yield in NetLogo.

------

A popco-only analogue of the preceding is to simply cause
trustworthiness in popco to be a function of mean SP activation.  (This
does not obviate the value of doing a full linked simulation; see
ArchitectureNotes6.md.)

1. Only WP, not WB propns are present in popco.  This biases
transmission of SP over SB.

2. When a sender's mean SP activn is high, its trustworthinesss is high.

i.e. this just creates a loop within popco from the loop that went from SP to
noise suppression to success to SP in the NetLogo-popco system:

<div align="center">
<img src="TransmissionBiasesPopcoOnly.pdf"/>
</div>


(Again, "SP" plays two roles, representing represents both individual
spiritual-peasant propositions activations and mean activation of all
spiritual-peasant propositions.)

