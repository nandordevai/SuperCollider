MIDIClient.init;
~iac = MIDIOut.newByName("IAC Driver", "Bus 1");
MIDIIn.connect(0, MIDIIn.findPort("IAC Driver", "Bus 1"));
MIDISyncClock.init;

(
p = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, ~iac,
    \chan, 0,
    \degree, Pseq(Array.fill(8, Prand((0..12), inf).iter), inf),
    \scale, Scale.chromatic,
    \dur, 0.5,
    \amp, 1
).play(MIDISyncClock, quant: 1);
)

p.stop;