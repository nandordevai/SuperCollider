"../SynthDefs/tama.scd".loadRelative;

~tension = 0.01;
~loss = 1.99;
~vel = 1;

(
p = Pbind(*[
	instrument: 'tama',
	note: Pseq([60, 80, 75, 80], inf),
	dur: Pseq([1, 0.5, 0.5], inf),
	tension: Pfunc { ~tension },
	loss: Pfunc { ~loss },
	vel: Pfunc { ~vel },
]).play(TempoClock(110 / 60));
);

// p.stop();