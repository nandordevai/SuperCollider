(
SynthDef(\pluck, {
	arg
	amp = 0.1,
	freq = 440,
	mutedString = 0.1,
	decay = 5,
	out_bus = 0;

	var env, snd;
	env = Env.linen(0, decay, 0).kr(2);
	snd = Pluck.ar(
		in: WhiteNoise.ar(amp),
		trig: Impulse.kr(0),
		maxdelaytime: 0.1,
		delaytime: freq.reciprocal,
		decaytime: decay,
		coef: mutedString);
	Out.ar(2, [snd, snd]);
}).writeDefFile("/Users/nandi/Projects/SuperCollider/SynthDefs/").load(s);
);

ServerOptions.devices
Server.default.options.device
Server.default.options.outDevice_("BlackHole")
Server.default.options.outDevice_("Onyx Blackjack")