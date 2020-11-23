(
~bellsMelody = EventPatternProxy();
~bellsRhythm = EventPatternProxy();
)

(
var maxDeg = 18;
var weights = Array.fill(maxDeg + 1, 1) ++ 5;
~bellsNotes = Array.fill(
    15,
    Pseed(
        6134,
        Pmeanrand(0, maxDeg).round
    ).iter,
    inf
);
)

(
~bellsLengths = Array.fill(
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
);
)

(
~bellsMelody.source = Pbind(
    \degree, Pseq(
        [0] ++ ~bellsNotes,
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
~bellsRhythm.source = Pbind(
    \dur, 1,
    \legato, Pseq(
        ~bellsLengths,
        inf
    )
);
)

(
~i = rrand(1, 14).asInteger;
~bellsNotes[~i] = Pmeanrand(0, 18).round.asStream.next;
~bellsLengths[~i + 1] = Pwrand([1/4, 6/4], [4, 1].normalizeSum).asStream.next;
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