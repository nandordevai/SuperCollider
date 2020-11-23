(
~bellsMelody = EventPatternProxy();
~bellsRhythm = EventPatternProxy();
~patternLength = 16;
)

(
var maxDeg = 18;
var weights = Array.fill(maxDeg + 1, 1) ++ 5;
~bellsNotes = Array.fill(
    ~patternLength - 1,
    Pseed(
        6134,
        Pmeanrand(0, maxDeg).round
    ).iter,
    inf
);
)

(
~bellsLengths = Array.fill(
    ~patternLength,
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
~setSource = {
    ~bellsMelody.source = Pbind(
        \degree, Pseq(
            [0] ++ ~bellsNotes,
            inf
        ),
        \root, -7,
        \octave, 5,
        \amp, Pseq(
            Array.fill(
                ~patternLength,
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
};
)

~setSource.value;

(
~change = Routine({
    inf.do {
        ~i = rrand(1, 14).asInteger;
        ~bellsNotes[~i] = Pmeanrand(0, 18).round.asStream.next;
        ~bellsLengths[~i] = Pwrand([1/4, 6/4], [4, 1].normalizeSum).asStream.next;
        ~setSource.value;
        ~bellsNotes.postln;
        ~patternLength.wait;
    };
});
~change.play(~link, quant:4);
)
~change.stop;

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