Change log
====

#### From Janssen's original v.2 to my initial version Bali3a.nlogo:

* Bug fix: In `imitatebestneighbors`, old version, subaks would not
imitate during months when their crop was lying fallow.  Initially I
changed this by putting a switch in the UI that would allow turning this
behavior, which I believe is not intended, on and off.  Eventually I may
remove the switch and simply use only the new behavior that imitates
whether fallow or not.

* Bug fix: In `setup`, in final outer `ask subaks` block, in last line of code
which adds to list in `damneighbors`, replaced `self` with `myself`,
which appears to be what was intended.  Original version just collected
repeated instances of the same subak in its own `damneighbors`.
(This does not appear to be a change that affects function.  I don't
see `damneighbors` used anywhere.)

* Changes some of the limits in the plots in the UI.

* Added other reporting objects in UI:

    * Crop plan distribution histogram
    
    * Info on the modal crop plan and modal start month.

* Changed code for coloring of subaks to show cropplans and months.
Now the month color is displayed in the patch behind the subak, and
the subak color represents the cropplan.

* Added UI switch and code that can cause display of the subak number
and month number over each subak.

* Added UI switches that allow excluding individual cropplans, plus
buttons that allow including or excluding all crop plans.  (Excluding
all is a useful step if you want to include only a few crop
plans--i.e. then you can just enable a isolated plans.)

* Added code to `go` routine so that the `viewdamsubaks` switch would
also turn the `damsubak` and `subakdam` links on and off while the
model is running.

* Added comments, reformatted some lines, renamed some variables
globally.  I've tried to be conservative, and in most (all?) cases,
the old code is still there, but commented out, or I added a comment
describing the change.

* Commented out some code that couldn't possibly do anything.  (e.g.
in `setup` there were two `ask subaks` blocks that duplicated some of
the same variable-setting operations, so I left only the later version
uncommented.)

* Removed old sliders for number of subaks (`num-subaks`) and number *
of dams (`num-dams`), which weren't doing anything--their values were
fixed.

* Removed chooser `nrcropplans` that allowed switching between the first
six cropplans and all 21 of them.  This function is superceded by
switches to select croppolans individually.
