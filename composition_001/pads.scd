(
~pm = EventPatternProxy();
~pr = EventPatternProxy();
)

(
var root = [0, 7, 9, 11];
~pm.source = Pbind(
    \degree, Pxrand(
        [root, root+4, root+3],
        inf
    ),
    \root, -7,
    \octave, 5,
);
)

(
~pr.source = Pbind(
    \dur, 8,
    \legato, 1,
);
)

(
~pads = Pchain(
    ~pdefs,
    Pbind(
        \scale, ~scale,
        \midiout, ~iac2,
        \amp, 1,
    ),
    ~pr,
    ~pm,
).play(~link, quant:4);
)
~pads.stop;