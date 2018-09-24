"../SynthDefs/pluck.scd".loadRelative;
"../MIDI/initIAC.scd".loadRelative;

~dur = 0.5;
~decay = 4.23;
~decayMult = 5;
~muteAmount = 0.7;
~octave = -2;
~octaveOffset = 3;
~amp = 0.05;

~touchOSC = NetAddr("10.0.1.46", 9000);
~touchOSC.sendMsg("/pluck/octave/1/" ++ (~octave + ~octaveOffset), 1);
~touchOSC.sendMsg("/pluck/durVal", ~dur);
~touchOSC.sendMsg("/pluck/dur", ~dur.linlin(0.25, 2, 0, 1));
~touchOSC.sendMsg("/pluck/decayVal", ~decay);
~touchOSC.sendMsg("/pluck/decay", ~decay / ~decayMult);
~touchOSC.sendMsg("/pluck/muteVal", ~muteAmount);
~touchOSC.sendMsg("/pluck/mute", ~muteAmount);

OSCdef('setDuration', { |msg ... args|
		~dur = msg[1].linlin(0, 1, 0.25, 2).round(0.25);
		~touchOSC.sendMsg("/pluck/durVal", ~dur);
}, '/dur');
OSCdef('setDecay', { |msg ... args|
		~decay = msg[1] * ~decayMult;
		~touchOSC.sendMsg("/pluck/decayVal", ~decay.round(0.01));
}, '/decay');
OSCdef('setMuteAmount', {|msg ... args|
		~muteAmount = msg[1];
		~touchOSC.sendMsg("/pluck/muteVal", ~muteAmount.round(0.01));
}, '/muteAmount');
OSCdef('setOctave', {|msg ... args|
	if (msg[1] == 1.0, {
		~octave = msg[0].asString.at(msg[0].asString.size - 1).digit - ~octaveOffset;
	})
}, '/octave');

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

// ~pluckPlayer = ~pluck.play(TempoClock(110 / 60), quant: 1);
~pluckPlayer = ~pluck.play(MIDISyncClock, quant: 1);

// ~pluckPlayer.stop();