(
MIDIClient.init;
~iac = MIDIOut.newByName("IAC Driver", "Bus 1");
~iac2 = MIDIOut.newByName("IAC Driver", "Bus 2");
~iac3 = MIDIOut.newByName("IAC Driver", "Bus 3");
~link = LinkClock(1).latency_(Server.default.latency);
)

(
var maxDeg = 18;
var weights = Array.fill(maxDeg + 1, 1) ++ 5;
~bells = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac,
    \chan, 0,
    \degree, Pseq(Array.fill(32, Pwrand((0..maxDeg) ++ [\rest], weights.normalizeSum, inf).iter), inf),
    \scale, Scale.minor,
    \dur, 0.5, //Prand([0.5, 0.25], inf),
    \amp, Pexprand(0.5, 1.0, inf),
    \root, -7,
    \octave, [6, 5],
).play(~link, quant:4);
)
~bells.stop;

(
var maxDeg = 12;
var weights = Array.fill(maxDeg + 1, 1) ++ 2;
~bass = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac2,
    \chan, 0,
    \degree, Pseq(Array.fill(16, Pwrand((0..maxDeg) ++ [\rest], weights.normalizeSum, inf).iter), inf),
    \scale, Scale.minor,
    \dur, Pseq(
        Array.fill(16, Pwrand([0.5, 1, 2], [1, 1, 1].normalizeSum, inf).iter), inf),
    \amp, 1,
    \root, -7,
    \octave, 5
).play(~link, quant:4);
)
~bass.stop;

// drums
(
~kick = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac3,
    \chan, 0,
    \scale, Scale.chromatic,
    \degree, 0,
    \dur, 1,
    \amp, 1,
    \octave, 3
).play(~link, quant:4);
)
~kick.stop;

(
~hihat = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac3,
    \chan, 0,
    \scale, Scale.chromatic,
    \degree, Pseq(Array.fill(16, Pseed(808, Pwrand([6, \rest], [3, 1].normalizeSum, inf)).iter), inf),
    // \dur, Pbjorklund2(6, 16, inf) / 4,
    \dur, 0.25,
    \amp, Pseq(Array.fill(16, Pexprand(0.25, 0.5)), inf),
    \octave, 3
).play(~link, quant:4);
)
~hihat.stop;

(
~open_hihat = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac3,
    \chan, 0,
    \scale, Scale.chromatic,
    \degree, Pseq(Array.fill(16, Pseed(808, Pwrand([10, \rest], [1, 6].normalizeSum, inf)).iter), inf),
    \dur, 0.25,
    \amp, Pseq(Array.fill(16, Pexprand(0.25, 0.5)), inf),
    \octave, 3
).play(~link, quant:4);
)
~open_hihat.stop;

(
~clap = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac3,
    \chan, 0,
    \scale, Scale.chromatic,
    \degree, Pseq(Array.fill(16, Pwrand([3, \rest], [1, 10].normalizeSum, inf).iter), inf),
    \dur, 0.25,
    \amp, 0.5,
    \octave, 3
).play(~link, quant:4);
)
~clap.stop;

(
~kick.stop;
~hihat.stop;
~open_hihat.stop;
~clap.stop;
)

~bells.start;
~bass.start;

~bells.stop;
~bass.stop;













