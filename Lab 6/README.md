In lab 6, we created an alarm clock that had a visual stimulus on top of an auditory one and
allowed the user to switch between two different audios. We did this by creating a module that
counted every clock edge as 1 second, which allowed our 24 hour clock to run. When the set
alarm time was equal to the clock time, the alarm would “ring” (play the sound, light the light,
and show the animation) for a total of 31 clock edges (so like 31 seconds). We did this by
creating multiple ROMs using the IP catalog, with each one representing a different musical note. We
then cycled through the notes producing two different sounds from different combinations of the
notes. We then created a flashing visual animation on the alarm clock display through 2 cases:
draw and clear, which alternated continuously to create a flashing effect. The image was created
by providing x and y parameters with r, g, b parameters to the video_driver that would
implement the visual design on the display. Finally, we connected that audio piece with our
visual display, so that when the alarm rang it would enable the sound to play and the display to
be activated, creating a light, audio, and animation show when the alarm rang.
