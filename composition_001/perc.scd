(
~l = Prewrite(
    0.25,
    (
        0.25: [0.25, 0.5],
        0.5: [0.25, 0.125, 0.125],
        0.125: [0.125, 0.5],
        1: [0.5, 0.25],
    ),
    4);
)

~pm = EventPatternProxy();

(
~pm.source = Pbind(
    \dur, ~l, //Pwrand([0.25, 0.5], [1, 2].normalizeSum, inf),
    \octave, 3, //Pwrand([5, 6, 7], [1, 2, 1].normalizeSum, inf),
);
)

(
~perc = Pchain(
    ~pdefs,
    ~pm,
    Pbind(
        \midiout, ~iac4,
        \scale, Scale.chromatic,
        // \degree, Pseq(
        //     Array.fill(
        //         16,
        //         Pseed(
        //             808,
        //             Pwrand(
        //                 [0, 1, 5, \rest],
        //                 [1, 1, 1, 5].normalizeSum,
        //                 inf
        //             )
        //         ).iter
        //     ),
        //     inf
        // ),
        \degree, Pseq([0], inf),
        \amp, Pseq(Array.fill(16, Pexprand(0.25, 0.5)), inf),
    )
).play(~link, quant:4);
)
~perc.stop;

// (
// a = Pseq([73, 71, 69], 2);
// b = Pseq([0, 0, 0, 4, 0]+64);
// c = Pswitch([a, b, 75], Pseq([2, 2, 0, 1], inf));
// x = c.asStream;
// 13.do({ x.next.postln; });
// )

(
~pm.source = Pbind(
    \octave, -1,
    //Pwrand([5, 6, 7], [1, 2, 1].normalizeSum, inf),
);
)

(
~perc = Pchain(
    Pbind(
        \type, \midi,
        \midicmd, \noteOn,
        \midiout, ~iac4,
        \chan, 0,
        \scale, Scale.chromatic,
        // \degree, Pseq(
        //     Array.fill(
        //         16,
        //         Pseed(
        //             808,
        //             Pwrand(
        //                 [0, 1, 5, \rest],
        //                 [1, 1, 1, 5].normalizeSum,
        //                 inf
        //             )
        //         ).iter
        //     ),
        //     inf
        // ),
        \degree, Pseq([0], inf),
        \dur, 0.25, //~l, //Pwrand([0.25, 0.5], [1, 2].normalizeSum, inf),
        \amp, 1, //Pseq(Array.fill(16, Pexprand(0.25, 0.5)), inf),
    ),
    ~pm,
).play(~link, quant:4);
)
~perc.stop;

// (
// a = Pseq([73, 71, 69], 2);
// b = Pseq([0, 0, 0, 4, 0]+64);
// c = Pswitch([a, b, 75], Pseq([2, 2, 0, 1], inf));
// x = c.asStream;
// 13.do({ x.next.postln; });
// )