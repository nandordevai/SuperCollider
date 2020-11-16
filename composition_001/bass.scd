(
~bm = EventPatternProxy();
~br = EventPatternProxy();
)

// slow
(
~bm.source = Pbind(
    \degree, Pseq(
        Array.fill(
            4,
            Pseed(
                1245,
                Pxrand([0, 1, 5, 7], 4)
            ).iter,
            inf
        ),
        inf
    ),
    \octave, 3,
    \root, -7,
);
)

// fast
(
~bm.source = Pbind(
    \degree, Place([0, [1, 7], [5, 3, 7]], inf),
    \octave, 4,
    \root, -7,
);
)

// slow
(
~br.source = Pbind(
    \dur, 4,
    \legato, 1,
);
)

// fast
(
~br.source = Pbind(
    \dur, 0.25, //4, 0.25,
    \legato, 0.5, //1,
);
)

(
~bass = Pchain(
    ~pdefs,
    Pbind(
        \midiout, ~iac3,
        \scale, ~scale,
        \amp, 1,
    ),
    ~bm,
    ~br,
).play(~link, quant:4);
)
~bass.stop;