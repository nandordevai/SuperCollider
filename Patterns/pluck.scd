"../SynthDefs/pluck.scd".loadRelative;

~dur = 0.75;
~decay = 1.75;
~muteAmount = 0.1;
~octave = -2;
~amp = 0.05;

(
~onOSCReceive = { |msg|
	case
	{ msg[0].asString.contains("/dur") } {
		~dur = msg[1];
	}
	{ msg[0].asString.contains("/decay") } {
		~decay = msg[1] * 5;
	}
	{ msg[0].asString.contains("/muteAmount") } {
		~muteAmount = msg[1];
	}
	{ msg[0].asString.contains("/octave") } {
		if (msg[1] == 1.0, {
			~octave = msg[0].asString.at(msg[0].asString.size - 1).digit - 3;
		})
	};
};
);

thisProcess.addOSCRecvFunc(~onOSCReceive);
// thisProcess.removeOSCRecvFunc(~onOSCReceive);

thisThread.randSeed = 4;

(
p = Pbind(*[
	instrument: 'pluck',
	scale: Scale.harmonicMinor,
	degree: Pseq((0..7).scramble, inf),
	ctranspose: Pfunc { ~octave * 12 },
	dur: Pfunc { ~dur },
	decay: Pfunc { ~decay },
	mutedString: Pfunc { ~muteAmount },
	amp: Pfunc { ~amp }
]).play(TempoClock(110 / 60), quant: 1);
);

// p.stop();