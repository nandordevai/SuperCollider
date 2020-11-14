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

~pdefs = Pbind(
        \type, \midi,
        \midicmd, \noteOn,
        \chan, 0
);

~scale = Scale.minor;

EventPatternProxy.defaultQuant = 4;
)
