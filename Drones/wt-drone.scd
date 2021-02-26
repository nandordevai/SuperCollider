(
~wavetable = Array.fill(90, {
	var i = rrand (90, 20);
	Env(
		levels: (({ rrand(0.0, 1.0) } ! (i - 1)) * [1, -1]).scramble,
		times: { rrand(1, 20) } ! i,
        curve: \sine
	).asSignal(1024)
    .asWavetable;
});

~wtbuffer = Buffer.allocConsecutive(90, s, 2048);
~wtbuffer.do({| buf, i |
	buf.loadCollection(~wavetable[i]);
});

SynthDef.new(\stargazer, {| amp = 1, out = 0, pan = 0.0, freq = 440, gain = -1.0, wave = 0,
    sub = 0, osc2Detune = 1, oscMix = (-1.0), filter1Freq = 880, filter2Freq = 880, res1 = 0.0,
    res2 = 0.0, alias = 44100, bitRateReduction = 24, filter1LFORate = 10, filter2LFORate = 10,
    ampLFORate = 10, filter1LFODepth = 1, filter2LFODepth = 1, ampLFODepth = 1,
    filter1LFOType = 0, filter2LFOType = 0, ampLFOType = 0 |

    var sig, detuned, pitch, filter1LFO, filter2LFO, ampLFO, filter1, filter2, wtPos;

    filter1LFO = Select.kr(
        filter1LFOType,
        [
            LFTri.kr(filter1LFORate),
            LFSaw.kr(filter1LFORate),
            LFPulse.kr(filter1LFORate)
        ]
    );
    filter2LFO = Select.kr(
        filter2LFOType,
        [
            LFTri.kr(filter2LFORate),
            LFSaw.kr(filter2LFORate),
            LFPulse.kr(filter2LFORate)
        ]
    );
    ampLFO = Select.kr(
        ampLFOType,
        [
            LFTri.kr(ampLFORate),
            LFSaw.kr(ampLFORate),
            LFPulse.kr(ampLFORate)
        ]
    );
    detuned = Select.ar(
        sub,
        [
            VOsc.ar(wave, freq * osc2Detune),
            VOsc.ar(wave, (freq * 0.5) * osc2Detune)
        ]
    );

    wave = ~wtbuffer[0].bufnum + wave;
    sig = VOsc.ar(wave, freq);
    sig = XFade2.ar(sig, detuned, oscMix);
    filter1 = MoogLadder.ar(sig, filter1Freq * filter1LFO.range(1, 1 - filter1LFODepth), res1);
    sig = Decimator.ar(filter1, alias, bitRateReduction);
    filter2 = MoogLadder.ar(sig, filter2Freq * filter2LFO.range(1, 1 - filter2LFODepth), res2);
    sig = Splay.ar(filter2);
    sig = LeakDC.ar(sig);
    sig = XFade2.ar(sig, sig.clip, gain);
    sig = sig * amp * ampLFO.range(1, 1 - ampLFODepth);
    sig = Limiter.ar(sig, 0.8);

    Out.ar(out, sig)
}).add;

x = Synth(\stargazer,
    [
        \freq, 55.midicps, //Pitch
        \wave, 19, //waveform selector, 0 to 89
        \osc2Detune, 1.midiratio,
        \sub, 1, // 1 takes osc2Detune one octave lower, 0 for using osc2Detune as it is
        \oscMix, 0, // -1 is 1st oscillator and 1 for the 2nd oscillator only 0 is the middle
        \filter1Freq, 1000,
        \filter1LFOType, 0, // 0 for Triangle, 1 for Saw, 2 for Pulse
        \filter1LFORate, 1,
        \filter1LFODepth, 0,
        \alias, 44100 / 8, // Sample rate reduction in Hz
        \bitRateReduction, 8, // 0-24 bits
        \filter2Freq, 600,
        \filter2LFOType, 0, // 0 for Triangle, 1 for Saw, 2 for Pulse
        \filter2LFORate, 60,
        \filter2LFODepth, 0.3,
        \gain, -1, // -1 is clean, 1 is dirty
        \ampLFOType, 2, // 0 for Triangle, 1 for Saw, 2 for Pulse
        \ampLFORate, 20,
        \ampLFODepth, 0
    ]
);
)