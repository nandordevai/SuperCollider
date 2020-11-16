(
var l = 0.165;
MIDIClient.init;
~iac1 = MIDIOut.newByName("IAC Driver", "Bus 1");
~iac1.latency = l;
~iac2 = MIDIOut.newByName("IAC Driver", "Bus 2");
~iac2.latency = l;
~iac3 = MIDIOut.newByName("IAC Driver", "Bus 3");
~iac3.latency = l;
~iac4 = MIDIOut.newByName("IAC Driver", "Bus 4");
~iac4.latency = l;
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
