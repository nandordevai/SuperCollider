l = LinkClock(1).latency_(Server.default.latency);

SynthDef(\click, { |freq=400, amp=0.2|
        var sig = SinOsc.ar(freq, 0.5pi) *
            Env.perc(0.001,0.06).ar(Done.freeSelf, levelScale: amp);
        OffsetOut.ar(0, sig.dup);
    }).add;

p = Pbind(\instrument, \click, \freq, Pseq([900, Pn(400,3)], inf)).play(l, quant:4);

l.tempo = 90/60;