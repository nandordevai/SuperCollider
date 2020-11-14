(
MIDIClient.init;
~iac = MIDIOut.newByName("IAC Driver", "Bus 1");
~iac.latency = 0.171;
~iac2 = MIDIOut.newByName("IAC Driver", "Bus 2");
~iac2.latency = 0.171;
~iac3 = MIDIOut.newByName("IAC Driver", "Bus 3");
~iac3.latency = 0.171;
~iac4 = MIDIOut.newByName("IAC Driver", "Bus 4");
~iac4.latency = 0.171;
~link = LinkClock(1).latency_(Server.default.latency);
~link.tempo = 75 / 60;
)

(
~bellDegree = PatternProxy.new;
)

(
var maxDeg = 18;
var weights = Array.fill(maxDeg + 1, 1) ++ 5;
~bellDegree.quant = 4;
~bellDegree.source = Pseq(
    Array.fill(
        //4,
        16,
        Pseed(
            6134,
            Pwrand(
                (0..maxDeg) ++ [\rest],
                weights.normalizeSum,
                inf
            )
        ).iter,
        inf
    ),
    inf
);
)

(
~bells = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac,
    \chan, 0,
    \degree, ~bellDegree,
    \scale, Scale.minor,
    \dur, 1,
    \amp, Pexprand(0.5, 1.0, inf),
    \root, -7,
    \octave, [6, 5],
    // \legato, Pexprand(0.8, 1.2, inf),
    // \legato, Pgauss(0.8, 0.4),
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
).play(~link, quant:4);
)
~bells.stop;

(
~pads = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac2,
    \chan, 0,
    \scale, Scale.minor,
    \amp, 1,
    \root, -7,
    \octave, 5,
    \dur, 8,
    \legato, 1.5,
    \degree, Pwrand(
        [[0, 7, 9, 11], [3, 10, 12, 14], [4, 11, 13, 15]],
        [2, 1, 1].normalizeSum,
        inf),
).play(~link, quant:4);
)
~pads.stop;

(
~bass = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac3,
    \chan, 0,
    \scale, Scale.minor,
    \degree, Pseq(
        [0, 7, 1, 5],
        inf
    ),
    \dur, 4,
    \amp, 1,
    \legato, 1,
    \octave, 3,
    \root, -7,
).play(~link, quant:4);
)
~bass.stop;


(
~hihat = Pbind(
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
~hihat.stop;
