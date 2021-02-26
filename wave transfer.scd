(
~tf = Signal.newClear(1025).waveFill({|
    x, old, i |
    sin(x)
}, -pi / 2, pi - 2);
~tf = ~tf.waveFill({|
    x, old, i |
    old * ((cos(x * 0.08) / 4) + 0.3);
}, 0, 50pi).normalize();
~tfBuf = Buffer.loadCollection(s, ~tf.asWavetableNoWrap());
)

(
{
    var sig, input, curve;
    // input = LFTri.ar(50);
    curve = LFNoise1.kr(0.5).bipolar(4);
    input = LFTri.ar({ 50 * Rand(-0.1, 0.1).midiratio } ! 8);
    input = input.lincurve(-1, 1, -1, 1, curve);
    sig = Shaper.ar(~tfBuf, input);
    sig = Splay.ar(sig) * 0.3;
    sig = LeakDC.ar(sig);
}.play();
)

(
SynthDef.new(\shaper, {
    var sig, input, curve, env, filter, buf;
    buf = \buf.ir(0);
    env = EnvGen.kr(
        Env.linen(\attack.ir(1), \sustain.ir(0), \release.ir(5), 1, [1, 0, -1]),
        doneAction: 2
    );
    curve = LFNoise1.kr(0.5 ! 8).bipolar(\curveMax.ir(1));
    input = LFTri.ar({ \freq.ir(50) * Rand(-0.1, 0.1).midiratio() } ! 8);
    input = input.lincurve(-1, 1, -1, 1, curve);
    sig = Shaper.ar(buf, input);
    sig = Shaper.ar(buf, sig);
    sig = Shaper.ar(buf, sig);
    sig = Shaper.ar(buf, sig);
    filter = MoogLadder.ar(sig, \filterFreq.ir(500), \resonance.ir(0.5));
    sig = Splay.ar(filter) * \amp.ir(0.3) * env;
    sig = LeakDC.ar(sig);
    Out.ar(\out.ir(0), sig);
}).add();
)

(
Synth(\shaper, [
    \curveMax: 1,
    \release: 20,
    \freq: 32.midicps();
]);
)

(
({ rrand(32, 50) } ! 4).do({| n |
    Synth(\shaper, [
        \buf, ~tBuf,
        \freq, n.nearestInScale([0, 7, 9, 10]).midicps(),
        \amp, n.lincurve(32, 50, 0.3, 0.5, -2),
        \release, 10,
        \attack, 3,
        \curveMax, 0,
        \filterFreq, n.lincurve(32, 50, 800, 1800, -1),
        \resonance, 0.8
    ]);
});
)