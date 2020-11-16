(
~bellsMelody = EventPatternProxy();
~bellsRhythm = EventPatternProxy();
)

(
var maxDeg = 18;
var weights = Array.fill(maxDeg + 1, 1) ++ 5;
~bellsMelody.source = Pbind(
    \degree, Pseq(
        [0] ++ Array.fill(
            15,
            Pseed(
                6134,
                Pmeanrand(0, maxDeg).round
            ).iter,
            inf
        ),
        inf
    ),
    \root, -7,
    \octave, 5,
    \amp, Pseq(
        Array.fill(
            16,
            Pexprand(0.5, 1.0, inf).iter
        ),
        inf
    ),
);
)

(
~bellsRhythm.source = Pbind(
    \dur, 1,
    \legato, Pseq(
        Array.fill(
            16,
            Pseed(
                165,
                Pwrand(
                    [1/4, 6/4],
                    [4, 1].normalizeSum,
                    inf
                ),
            ).iter,
            inf
        ),
        inf
    )
);
)

(
~bells = Pchain(
    ~pdefs,
    Pbind(
        \scale, ~scale,
        \midiout, ~iac1,
    ),
    ~bellsRhythm,
    ~bellsMelody
).play(~link, quant:4);
)
~bells.stop;