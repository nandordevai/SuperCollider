(
~bm = EventPatternProxy();
~br = EventPatternProxy();
)

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

(
~br.source = Pbind(
    \dur, 4,
    \legato, 1,
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