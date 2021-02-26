(
SynthDef(\universe, { |out,
    amps(#[0.03, 0.3, 0.6, 1.2])|
    var freqs, env, signal;
    freqs = Array.fill(4, Pxrand([27, 28.44, 32, 36, 38.44, 42.66, 48, 54, 56.88, 64, 216, 227.55, 256, 288, 307.54, 341.33, 384, 432, 455.11, 512, 576], inf).iter);
    env = Env.sine(360, 1);
    signal = DynKlank.ar(`[freqs, amps], PinkNoise.ar([0.07, 0.07]));
    Out.ar(out, signal * EnvGen.kr(env, doneAction: Done.freeSelf));
}).add;
)

y = Synth('universe');