Interjector
=====
Helper script for managing between-turn checks within other scripts

NOTE: Current release is **bespoke for my configuration** and will likely not work for anyone else. Feel free to modify for your own needs if you understand ash scripting, but it is not ready for general consumption. All of my realm scripts depend on this.



Installation
----------------
Run this command in the graphical CLI:
<pre>
git checkout https://github.com/linzinha/interjector.git
</pre>



Commands
----------------
**full:** default, runs all behaviors in the script  
**nofam:** does not check familiar handling, useful for areas like FantasyRealm

Checks
----------------
**Digitize:** If a digitized monster is ready to be fought
**Sausage:** If a Sausage monster is ready to be fought
**Robot:** If Autumn-maton is ready to be sent
**Animal:** If you should swap your familiar for item drops
