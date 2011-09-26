:date: 2011-09-26 16:00:00
:tags: neuroscience, software, spotlight, guest post, opensesame, sebastiaan mathot
:author: Sebastiaan Mathôt
:author_email: s.mathot@vu.nl

In the spotlight: OpenSesame
============================

I suspect that many of you will not be familiar with me or my software, so
let's start with a brief introduction. My name is Sebastiaan Mathôt. I'm the
lead developer of OpenSesame_, a graphical tool for creating psychological and
neuroscientific experiments.

About OpenSesame
----------------

The reason that I started working on OpenSesame, aside from the inherent
pleasure that a geek like myself derives from developing software, was my
dissatisfaction with the tools that were available. Not that there's a shortage
of experiment building software, not at all. And for people with reasonable
programming skills there are many viable options: MatLab/ Octave in combination
with the `Psychophysics Toolbox`_, Python in combination with VisionEgg_ or
PsychoPy_, to name but a few (most of these are, incidentally, available through
NeuroDebian). But for people with relatively modest programming skills, such as
most students doing a Bachelor's or Master's project, there aren't that many
options. In my experience, people will generally end up using a proprietary
program, such as E-Prime, Inquisit, or what have you. These offer a reasonably
intuitive graphical interface, but at a price. First, these packages are
expensive and, due to licensing restrictions, people are frequently unable to
install them on their personal computers. Second, they are limited in their
functionality and in their interoperability with other software.

.. figure:: pics/blog/opensesame_stimulus.png

   One of the unique features of OpenSesame is the ability to draw your
   stimuli. You can combine this what-you-see-is-what-you-get approach with
   scripting, to easily create flexible stimulus displays.

Therefore, I wanted to develop a graphical environment for building
experiments, centered around the Python programming language. The idea was to
give users the type of comprehensive graphical interface that they have come to
expect from proprietary packages, but for free, and without taking away any of
the power that Python has to offer. And, almost a year, 12 public releases, and
more than 10,000 downloads later, the result is OpenSesame!

Back-end independence
---------------------

In this post I want to highlight one of OpenSesame's features: back-end
independence. This may sound a bit technical and boring, but it's not. Well...
maybe a little boring. In fact, it should be a little boring, because it's a
feature that you're not supposed too notice, unless you need it.

So what do I mean by "back-end independence"? Experiments are all about
presenting stimuli. Most often visual stimuli on a computer display, sometimes
sounds, tactile stimuli, etc. From the perspective of a programmer, there are
many ways to present such stimuli. Put differently, there are many programming
libraries that you can use.

For example, if you want to write a program that controls a computer display,
you can use a Python library called PyGame_. PyGame has been designed with
video-games in mind, but, experiments being conceptually so similar (although
not typically as entertaining), it is also well suited for creating
experiments. For this reason, I initially designed OpenSesame around PyGame.

This seemed like a good idea at the time, but there was a huge drawback. If
people wanted to use OpenSesame, they were forced to use PyGame as well. It was
a package deal, so if PyGame didn't support a particular feature, neither did
OpenSesame. That wasn't very nice. And it also wasn't necessary, because there
was nothing in OpenSesame that inherently required PyGame. It was just an
arbitrary design choice that I had made at the outset.

So I decided to decouple the "back-end" (i.e., all the functions that had been
handled by PyGame up to that point) from the rest of OpenSesame. This means
that the user can now choose which back-end he or she wants to use for
controlling the display etc. Importantly, OpenSesame continues to function in
the same way, regardless of which back-end is selected. For users who don't
care or know what a back-end is, let alone which back-end they prefer, PyGame
still serves as a default.

.. figure:: pics/blog/opensesame_backend.png

   You can easily select your favorite back-end using the graphical interface.
   The same experiment can be run, (usually) completely unmodified, using any
   of the three available back-ends.

So what's the upshot of all this? Right now, the most direct benefit is that
you can use OpenGL and PsychoPy in your OpenSesame experiments. PsychoPy in
particular provides lots of functions (drawing Gabor patches etc.) that are
very convenient when creating experiments. Previously, users couldn't use
these, because PsychoPy doesn't play nice with PyGame (even though it actually
uses, or can use, PyGame under the hood). Now they can, so that's a definite
plus. And in the future I may add more back-ends, depending on popular demand.
For example, VisionEgg is another library for creating experiments. VisionEgg
is quite popular and could probably be used as a back-end as well.

This means that users of OpenSesame now have both a comprehensive graphical
interface and powerful programming libraries at their disposal. They can
choose. Most of the experiment can usually be created using the GUI, which is
especially appealing for the less tech-savvy among us. But, for more
complicated parts, Python scripting can be used and, consequently, users have
access to a wide range of libraries.

I think that OpenSesame's back-end independence is a nice example (one of many,
I hasten to add) of how free software can work together. If it hadn't been
possible to use PsychoPy and OpenGL in OpenSesame, I would have probably ended
up duplicating lots of functionality. That would have been very time consuming.
Time that I have now spent on refining other parts of OpenSesame, unique parts
and not simply duplicates of existing functionality.

And ultimately, I believe that this type of interoperability is why free
software will continue to grow.

.. _PyGame: http://pygame.org
.. _PsychoPy: http://psychopy.org/
.. _VisionEgg: http://www.visionegg.org/
.. _Psychophysics Toolbox: http://psychtoolbox.org
.. _OpenSesame: http://www.cogsci.nl/opensesame


