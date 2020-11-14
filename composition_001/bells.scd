(
~bellsMelody = EventPatternProxy();
~bellsRhythm = EventPatternProxy();
)

(
var maxDeg = 18;
var weights = Array.fill(maxDeg + 1, 1) ++ 5;
~bellsMelody.source = Pbind(
    \degree, Pseq(
        Array.fill(
            // 4,
            16,
            Pseed(
                6134,
                // Pwrand(
                //     (0..maxDeg) ++ [\rest],
                //     weights.normalizeSum,
                //     inf
                // )
                Pmeanrand(0, maxDeg).round
                // Pbrown(0, maxDeg, 1)
                // Phprand(0, maxDeg, 1, inf)
            ).iter,
            inf
        ),
        inf
    ),
    \root, 0,
    \octave, 5,
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
                    [0.4, 0.8, 1.2],
                    [4, 2, 1].normalizeSum,
                    inf
                ),
            ).iter,
            inf
        ),
        inf
    )
));
)

(
~bells = Pchain(
    ~pdefs,
    Pbind(
        \scale, ~scale,
        \midiout, ~iac,
        \amp, Pexprand(0.5, 1.0, inf),
    ),
    ~bellsRhythm,
    ~bellsMelody
).play(~link, quant:4);
)
~bells.stop;