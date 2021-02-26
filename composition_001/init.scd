(
var l = 0.165;
MIDIClient.init;
~iac = List[];
4.do({|i|
    var bus = MIDIOut.newByName("IAC Driver", "Bus " ++ (i + 1));
    bus.latency = l;
    ~iac.add(bus)
});

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