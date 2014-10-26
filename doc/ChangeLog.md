Changes from original version
====

* Added comments, reformatted some lines, renamed some variables
globally.

* In `imitatebestneighbors`, old version, subaks would not imitate during
months when their crop was lying fallow.  Initially I changed this by
putting a switch in the UI that would allow turning this behavior,
which I believe is not intended, on and off.  Eventually I may remove
the switch and simply use only the new behavior that imitates whether
fallow or not.

* In `setup`, in final outer `ask subaks` block, in last line of code
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
buttons that to include or exclude all crop plans.  (The second is
useful if you only want to include a few crop plans.)

* Added code to `go` routine so that the `viewdamsubaks` switch would
also turn the `damsubak` and `subakdam` links on and off while the
model is running.

* Removed old sliders for number of subaks (`num-subaks`) and number *
of dams (`num-dams`), which weren't doing anything--their values were
fixed.

* Removed chooser `nrcropplans` that allowed switching between the
first six cropplans and all 21 of them.  This function superceded by 
switches to select croppolans individually.
