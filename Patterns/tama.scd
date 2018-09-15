"../SynthDefs/tama.scd".loadRelative;
"../MIDI/initIAC.scd".loadRelative;

~tension = 0.01;
~loss = 1.99;
~vel = 2;

(
~tama = Pbind(*[
	instrument: 'tama',
	note: Pseq([60, 80, 75, 80], inf),
	dur: Pseq([1, 0.5, 0.5], inf),
	tension: Pfunc { ~tension },
	loss: Pfunc { ~loss },
	vel: Pfunc { ~vel },
]);
);

// ~tamaPlayer= ~tama.play(TempoClock(110 / 60), quant: 1);
~tamaPlayer= ~tama.play(MIDISyncClock, quant: 1);

// ~tamaPlayer.stop;