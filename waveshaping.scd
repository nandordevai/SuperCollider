(
~tf = Env([-1, 1], [1], [0]).asSignal(1025);
~tf = ~tf + (
    Signal.sineFill(
        1025,
        (0 ! 3) ++ [0, 0, 0, 1, 1, 1].scramble(),
        { rrand(0, 2pi) } ! 9
    ) / 4;
);
~tf = ~tf.normalize();
Buffer.freeAll();
~tfBuf = Buffer.loadCollection(s, ~tf.asWavetableNoWrap());
)

(
{
    var sig, input;
    // input = SinOsc.ar(100) * Line.kr(0, 1, 7);
    input = SinOsc.ar({ 50 * Rand(-0.1, 0.1).midiratio() } ! 8);
    input = input * LFNoise1.kr(0.5 ! 8).range(0.1, 1);
    sig = Shaper.ar(~tfBuf, input);
    sig = Splay.ar(sig) * 0.5;
}.play();
)