b = Buffer.alloc(s, 2048);

(
~amps = [1] ++ ({[0, exprand(0.05, 0.5)].choose} ! 31);
~wt = Signal.sineFill(
    1024,
    ~amps,
    [0]
).asWavetable();
b.loadCollection(~wt);
// ~wt.plot();
)

(
b.sine3(
    ({ exprand(0.75, 40) } ! 16).sort,
    ({ exprand(0.05, 0.9) } ! 16).sort.reverse,
    { rrand(0, 2pi) } ! 16,
    asWavetable: true
);
)

(
b.loadCollection(
    Env(
        [0, 0.6, -0.9, 0.3, 0],
        [4, 3, 2, 1],
        { rrand(-20, 20) } ! 4
        // curve: \lin
    )
    .asSignal(1024)
    .asWavetable());
)

(
var i = rrand(4, 20);
b.loadCollection(
    Env(
        (({ rrand(0, 1.0) } ! (i + 1)) * [1, -1]).scramble,
        { exprand(1, 20) } ! i,
        { rrand(-20, 20) } ! i
    )
    .asSignal(1024)
    .asWavetable()
);
)

(
~sig = Signal.newClear(1024);
~sig.waveFill({| x, old, i |
    (sin(x.pow(1.5)) * 1.5).fold(-1, 1).cubed();
}, 0, 2pi);
b.loadCollection(~sig.asWavetable());
)

{ Osc.ar(b, 50 * [1, 2.01], mul: 0.2 ! 2) }.play;