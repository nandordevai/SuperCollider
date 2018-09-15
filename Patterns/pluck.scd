"../SynthDefs/pluck.scd".loadRelative;

~dur = 0.5;
~decay = 1.75;
~muteAmount = 0.1;
~octave = -2;
~amp = 0.05;

~tOSC = NetAddr("10.0.1.46", 9000);
~tOSC.sendMsg("/pluck/octave/1/" ++ (~octave + 3), 1);

(
~onOSCReceive = { |msg|
	case
	{ msg[0].asString.contains("/dur") } {
		~dur = msg[1].round(0.25);
		~tOSC.sendMsg("/pluck/durVal", ~dur);
	}
	{ msg[0].asString.contains("/decay") } {
		~decay = msg[1] * 5;
		~tOSC.sendMsg("/pluck/decayVal", ~decay.round(0.01));
	}
	{ msg[0].asString.contains("/muteAmount") } {
		~muteAmount = msg[1];
		~tOSC.sendMsg("/pluck/muteVal", ~muteAmount.round(0.01));
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
~pluck = Pbind(*[
	instrument: 'pluck',
	scale: Scale.harmonicMinor,
	degree: Pseq((0..7).scramble, inf),
	ctranspose: Pfunc { ~octave * 12 },
	dur: Pfunc { ~dur },
	decay: Pfunc { ~decay },
	mutedString: Pfunc { ~muteAmount },
	amp: Pfunc { ~amp }
]);
);

~pluckPlayer = ~pluck.play(TempoClock(110 / 60), quant: 1);

// ~pluckPlayer.stop();