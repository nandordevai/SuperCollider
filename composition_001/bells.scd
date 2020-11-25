(
~bellsMelody = EventPatternProxy();
~bellsRhythm = EventPatternProxy();
~patternLength = 16;
~octave = 6;
~lc = LCXLKontrol.new;
~changeIsPlaying = false;
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
~lc.fader1.onChange = {|val|
    ~octave = val.linlin(0, 127, 4, 7).round;
    ~octave.postln;
};
)

(
~lc.control1.onPress = {
    if (~changeIsPlaying, {
        "stopping change".postln;
        ~changeIsPlaying = false;
        ~change.pause;
    }, {
        "starting change".postln;
        ~changeIsPlaying = true;
        ~change.play(~link, quant: 4);
    })
};
)

(
~setSource = {
    ~bellsMelody.source = Pbind(
        \degree, Pseq(
            [0] ++ ~bellsNotes,
            inf
        ),
        \root, -7,
        \octave, Pfunc { ~octave },
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
~change = Task({
    inf.do {
        ~i = rrand(1, 14).asInteger;
        ~bellsNotes[~i] = Pmeanrand(0, 18).round.asStream.next;
        ~bellsLengths[~i] = Pwrand([1/4, 6/4], [4, 1].normalizeSum).asStream.next;
        ~setSource.value;
        ~bellsNotes.postln;
        ~patternLength.wait;
    };
});
)

(
~changeIsRunning = true;
~change.play(~link, quant:4);
)

(
~changeIsRunning = false;
~change.stop;
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