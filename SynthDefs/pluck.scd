(
SynthDef(\pluck, {
	arg
	amp = 0.1,
	freq = 440,
	mutedString = 0.1,
	decay = 5;

	var env, snd;
	env = Env.linen(0, decay, 0).kr(2);
	snd = Pluck.ar(
		in: WhiteNoise.ar(amp),
		trig: Impulse.kr(0),
		maxdelaytime: 0.1,
		delaytime: freq.reciprocal,
		decaytime: decay,
		coef: mutedString);
	Out.ar(0, [snd, snd]);
}).writeDefFile("/Users/nandi/Projects/SuperCollider/SynthDefs/");
);