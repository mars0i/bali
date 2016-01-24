Notes on the NetLogo model's details
===

Note that the *num-subaks* and *num-dams* sliders in the upper left
corner of the NetLogo model are non-functional because they have both
the max and min values set to the number that other parts of the model
(e.g.  what's in the text files, I assume) take for granted.  I suspect
that these sliders should be altered only with great care.

The *nrcropplans* chooser, which presumably represents the number of
cropping plans, does allow switching from 21 to 6 plans, but this would
be a non-standard option, I guess.

Neither the Info tab nor the ODD pdf explain what the different turtle
shapes and lines, etc. represent.  Here's what I've figured out, I
think:

There are no raw turtles; everything is a breed.  There are
**subaks** and **dams**.

There are also breeds that represent links between subaks and/or dams.
These breeds' names are concatenations of "subak" and "dam".

**Subaks** are round.

**Dams** are square.

**damdam** links between dams are blue.

**subaksubak** links between subaks are green.

**damsubak** and **subakdam** links between dams and subaks are blue,
but they're not displayed by default.  The *viewdamsubaks* toggle
controls this.

If you choose to have subaks colored with their cropping plans, the
subaks can seem to disappear, because some of the cropping plans are
colored with black (or something near to black).  You can change the
background color of the display by executing, for example:

`ask patches [set pcolor gray]`

after clicking on the *setup* button.

There's something funny going on with the cropping plans.  If you
choose the option to color subaks with cropping plans, most but not
all of them end up being black--every time.  The exceptional subaks
that are non-black are not the same each time.  It looks like most of
them are ending up with the same cropping plan, represented by SCC=0,
I think.  Note however that the color is a calculated value, so maybe
the calculation is just mapping a bunch of cropping plans into black.
this means that 


