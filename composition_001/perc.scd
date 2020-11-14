(
~perc = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac4,
    \chan, 0,
    \scale, Scale.chromatic,
    \degree, Pseq(
        Array.fill(
            16,
            Pseed(
                808,
                Pwrand(
                    [0, 1, 5, \rest],
                    [1, 1, 1, 5].normalizeSum,
                    inf
                )
            ).iter
        ),
        inf
    ),
    \dur, Pwrand([0.25, 0.5], [1, 2].normalizeSum, inf),
    \amp, 1, //Pseq(Array.fill(16, Pexprand(0.25, 0.5)), inf),
    \octave, Pwrand([5, 6, 7], [1, 2, 1].normalizeSum, inf),
).play(~link, quant:4);
)
~perc.stop;
